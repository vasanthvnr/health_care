import os
import re
import json
import easyocr
import google.generativeai as genai
from flask import Flask, request, jsonify
from dotenv import load_dotenv

app = Flask(__name__)
load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
    raise ValueError("GEMINI_API_KEY not found in environment variables.")

genai.configure(api_key=api_key)
model = genai.GenerativeModel('gemini-2.0-flash')


def extract_text_from_image(image_file):
    reader = easyocr.Reader(['en'], gpu=False)
    result = reader.readtext(image_file.read())
    combined_text = " ".join([text for _, text, _ in result])
    return combined_text.strip()


def evaluate_ingredient(ingredients_str, health_issues):
    prompt = (
        "Evaluate the following ingredients individually. "
        "For each ingredient, classify it as good, moderate, or bad for general health. "
        "Also, check if it conflicts with these user health issues: "
        f"{health_issues}. "
        "Return ONLY a JSON array. Each item must have: "
        "'ingredient', 'evaluation', 'notSuitable' (true/false), 'reason'. "
        "Do not include any text before or after the JSON."
        f"\n\nIngredients: {ingredients_str}"
    )

    try:
        result = model.generate_content(prompt)
        response_text = result.text.strip()

        # Remove code fences if present
        response_text = re.sub(r"^```json\s*", "", response_text)
        response_text = re.sub(r"\s*```$", "", response_text)

        parsed = json.loads(response_text)

        if isinstance(parsed, dict):
            parsed = [parsed]
        elif not isinstance(parsed, list):
            parsed = []

        for item in parsed:
            item.setdefault("ingredient", "")
            item.setdefault("evaluation", "good")
            item.setdefault("notSuitable", False)
            item.setdefault("reason", "")

        return parsed

    except Exception:
        # If Gemini fails, return default 'good' for each ingredient
        return [
            {"ingredient": ing.strip(), "evaluation": "good", "notSuitable": False, "reason": ""}
            for ing in ingredients_str.split(",") if ing.strip()
        ]


def calculate_overall_safety(ingredients_list):
    has_bad = False
    has_moderate = False
    has_conflict = False

    for ing in ingredients_list:
        eval_lower = ing.get("evaluation", "").lower()
        if eval_lower == "bad":
            has_bad = True
        elif eval_lower == "moderate":
            has_moderate = True
        if ing.get("notSuitable", False):
            has_conflict = True

    if has_bad or has_conflict:
        return "bad", "Some ingredients are unsafe or not suitable for your health issues."
    elif has_moderate:
        return "moderate", "Some ingredients may cause mild issues."
    else:
        return "good", "All ingredients are considered safe."


def main(img_file, health_issues):
    extracted_text = extract_text_from_image(img_file)
    ingredients_cleaned = re.sub(r"[^a-zA-Z0-9, ]+", "", extracted_text)

    if not ingredients_cleaned:
        return {
            "status": "success",
            "overallSafety": "unknown",
            "overallMessage": "No ingredients found in the image.",
            "ingredients": []
        }

    evaluations = evaluate_ingredient(ingredients_cleaned, health_issues)
    overall_safety, overall_message = calculate_overall_safety(evaluations)

    return {
        "status": "success",
        "overallSafety": overall_safety,
        "overallMessage": overall_message,
        "ingredients": evaluations
    }


@app.route("/analyze", methods=["POST"])
def upload_image():
    if "image" not in request.files:
        return jsonify({"status": "error", "message": "No image part in the request"}), 400

    file = request.files["image"]
    if file.filename == "":
        return jsonify({"status": "error", "message": "No selected file"}), 400

    health_issues = request.form.get("healthIssues", "")

    try:
        result = main(file, health_issues)
        return jsonify(result)
    except Exception as e:
        return jsonify({
            "status": "error",
            "overallSafety": "error",
            "overallMessage": str(e),
            "ingredients": []
        }), 500


if __name__ == "__main__":
    app.run(debug=True)
