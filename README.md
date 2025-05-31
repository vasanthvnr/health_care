# 🏥 Healthcare Analyzer App - Flutter + Spring Boot Fullstack

A smart healthcare mobile application developed using Flutter (frontend) and Spring Boot (backend), connected via REST APIs. The app allows users to register/login and scan food or skincare product ingredients. It analyzes ingredients and provides insights like health effects or skin compatibility—especially helpful for children and sensitive users.

## 📁 Folder Structure
healthcare-analyzer-app/
├── frontend/         # Flutter app
└── backend/          # Java Spring Boot project

## ⚙️ Prerequisites

### Backend:
- Java 17 or above
- Spring Boot
- Maven
- MySQL
- Postman (optional, for testing APIs)

### Frontend:
- Flutter SDK (3.x recommended)
- Dart
- Android Studio or VS Code with Flutter plugin
- Android Emulator or Physical Device.

## 📦 How to Download and Set Up

1. **Download ZIP**
   - Click on `Code → Download ZIP` or clone using Git.

2. **Unzip the File**
   - Extract the ZIP file to your desired location.

## 🚀 Backend Setup (Spring Boot + MySQL)

1. Open the backend folder:
terminal :
  cd healthcare-analyzer-app/backend

2. Import into IntelliJ IDEA, Eclipse, or VS Code.

3. Configure your `application.properties` file:

**properties**
spring.datasource.url=jdbc:mysql://localhost:3306/healthcare
spring.datasource.username=your_mysql_username
spring.datasource.password=your_mysql_password
spring.jpa.hibernate.ddl-auto=update

4. Make sure the MySQL database healthcare exists

5. Run the Spring Boot project using your IDE or terminal

6. Test APIs using Postman:

   * POST → http://localhost:8080/api/auth/register
   * POST → http://localhost:8080/api/auth/login
   * POST → http://localhost:8080/api/analyze/food
   * POST → http://localhost:8080/api/analyze/skincare

## 📱 Frontend Setup (Flutter)

1. Open the frontend folder:

terminal :
  cd healthcare-analyzer-app/frontend


2. Install dependencies:

terminal :
  flutter pub get


3. Run the Flutter app:

terminal :
  flutter run

> 💡 Ensure your backend is running and your Android Emulator or device is connected.
>
> For Android Emulator, backend URL should be:
> `http://10.0.2.2:8080/`


## 🧪 Features

* ✅ User Registration and Login with JWT
* ✅ Food ingredient scanner with health analysis
* ✅ Skincare product ingredient scanner with skin compatibility
* ✅ Shows warnings for allergies or harmful ingredients
* ✅ Responsive Flutter UI
* ✅ Secure communication with Spring Boot backend


## 📌 Notes

* Make sure you replace the API base URL in the Flutter code (`http://10.0.2.2:8080/` for emulator, or your IP for a real device).
* Use HTTPS and domain in production.

## ✉️ Contact

* **Name:** Vasanth S
* **Email:** [vasanthvnr31@gmail.com](mailto:vasanthvnr31@gmail.com)
* **GitHub:** [vasanthvnr](https://github.com/vasanthvnr)
