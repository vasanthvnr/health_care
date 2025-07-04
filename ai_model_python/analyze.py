import os
import re
import json
import requests
from dotenv import load_dotenv
import easyocr
from requests.exceptions import RequestException
import google.generativeai as genai
from flask import Flask, request, jsonify


app = Flask(__name__)
load_dotenv()
api_key = os.getenv("GEMINI_API_KEY")

if not api_key:
    raise ValueError("GEMINI_API_KEY not found in environment variables.")

genai.configure(api_key=api_key)

model = genai.GenerativeModel('gemini-2.0-flash')

def extract_text_from_image(image_file):
    reader = easyocr.Reader(['en'], gpu=False)
    result = reader.readtext(image_file.read())  # read bytes
    combined_text = " ".join([text for _, text, _ in result])
    return combined_text.strip()

def evaluate_ingredient(ingredients_str):
    prompt = (
        "Evaluate the following ingredients individually. "
        "For each one, classify if it's good, moderate, or bad for health, and explain why. "
        "Return ONLY a JSON array. Each item must have: 'ingredient', 'evaluation'. "
        "Do not include any text before or after the JSON."
        f"\n\nIngredients: {ingredients_str}"
    )

    try:
        result = model.generate_content(prompt)
        response_text = result.text.strip()

        # Remove code fencing if present
        if response_text.startswith("```json"):
            response_text = re.sub(r"^```json\s*", "", response_text)
            response_text = re.sub(r"\s*```$", "", response_text)

        parsed = json.loads(response_text)
        return parsed

    except json.JSONDecodeError:
        return {"error": "Invalid JSON from Gemini", "raw": response_text}
    except Exception as error:
        print('Error generating response:', error)
        raise

def main(img):
    extracted_text = extract_text_from_image(img)
    ingredients = re.sub(r"[^a-zA-Z0-9, ]+", "", extracted_text)
    if not ingredients:
        return {"error": "No ingredients found in the image."}
    evaluations = evaluate_ingredient(ingredients)
    return evaluations

@app.route('/analyze', methods=['POST'])
def upload_image():
    if 'image' not in request.files:
        return jsonify({'error': 'No image part in the request'}), 400

    file = request.files['image']

    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    try:
        result = main(file)
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
    