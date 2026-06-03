# 🛡️ CyberShield

### AI-Powered Personal Cybersecurity Guardian for Android

CyberShield is an AI-powered Flutter Android application designed to protect smartphone users from phishing SMS, malicious links, and online scams in real time.

The app combines on-device machine learning, offline-first architecture, native Android notification monitoring, and cybersecurity workflows to provide secure threat detection and monitoring.

---

# 📱 Application Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/8c45812c-e2bf-4c88-8ee8-74c20fb55dde" width="230"/>
  <img src="https://github.com/user-attachments/assets/c77e9e31-0e5c-421c-8612-58a2617b21b2" width="230"/>
  <img src="https://github.com/user-attachments/assets/b845532b-ba79-4218-8f6b-1ae6ee7b7908" width="230"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/91ac8dff-9499-4008-b7c6-eff886c441d7" width="230"/>
  <img src="https://github.com/user-attachments/assets/cb187f99-97bf-40a9-be20-2fb1aee8e7cf" width="230"/>
  <img src="https://github.com/user-attachments/assets/f2c2027a-4591-4d90-b5be-b25478575945" width="230"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/5e11e627-38b6-47e0-b9c1-b0a8095bb5f0" width="230"/>
  <img src="https://github.com/user-attachments/assets/de005a98-4eb6-4803-9e01-f40477784e89" width="230"/>
  <img src="https://github.com/user-attachments/assets/c9511bec-0c23-4dd3-a93a-21a2f30952af" width="230"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/b86bc19e-0a4c-42c2-8fc0-143f089855eb" width="230"/>
  <img src="https://github.com/user-attachments/assets/bdc5ad48-11f6-4069-8c32-de2702d32eb7" width="230"/>
  <img src="https://github.com/user-attachments/assets/e3ab9655-cea7-4904-91d8-2c9ebefe14d3" width="230"/>
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/0913ded2-f741-4550-966a-8a2349b1d797" width="230"/>
  <img src="https://github.com/user-attachments/assets/30b211d1-f30b-4b84-b146-69a7b6644c60" width="230"/>
  <img src="https://github.com/user-attachments/assets/5d05627c-5691-4b62-b1eb-2a89fc36acd1" width="230"/>
</p>

---

# 🚀 Features

## 📩 Real-Time SMS Scam Detection

* Detects suspicious SMS and notification-based scams in real time.
* Uses TensorFlow Lite-based LSTM Neural Network for on-device phishing prediction.
* Generates scam/safe classification with risk scoring.
* Works even in offline mode.

## 🔔 Notification Listener Integration

* Captures incoming notifications using Android Notification Listener Service.
* Uses native Kotlin + Flutter EventChannel communication.
* Supports detection from messaging applications.

## 🌐 Phishing Link Scanner

* Scans suspicious URLs using Google Safe Browsing API.
* Classifies links as SAFE or DANGEROUS.
* Maintains scan history for security tracking.

## 💾 Offline-First Storage

* Stores scam detection history locally using Realm Database.
* Allows uninterrupted functionality without internet connection.
* Planned MongoDB synchronization for cloud backup and cross-device persistence.

## 🔐 Firebase Authentication

* Secure Email/Password authentication.
* User login and signup using Firebase Auth.

## 📊 CyberShield Score

* Generates dynamic cybersecurity risk score.
* Tracks threat activity and suspicious detections.

## 📧 Cyber Crime Reporting

* Generates structured cybercrime reporting workflow.
* Supports email-based reporting using external email applications.

---

# 🧠 Machine Learning Pipeline

```text
Notification Received
        ↓
Notification Listener Service
        ↓
Flutter EventChannel
        ↓
PredictionService
        ↓
TokenizerService
        ↓
TensorFlow Lite Model
        ↓
PredictionResult
        ↓
Realm Storage
        ↓
Detection History UI
```

---

# 🏗️ Architecture

CyberShield follows a modular feature-based architecture with layered separation.

```text
Presentation Layer
    ↓
Domain Layer
    ↓
Data Layer
```

## Architecture Highlights

* Feature-based folder structure
* Provider state management
* Offline-first design
* Native Android + Flutter bridge
* Modular service architecture
* Separation of presentation, domain, and data layers

---

# 📂 Project Structure

```text
lib/
│
├── core/
│   ├── constants/
│   ├── reliability/
│   ├── settings/
│   ├── shared/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── dashboard/
│   ├── links/
│   ├── report/
│   └── sms/
│       ├── data/
│       │   ├── cloud/
│       │   ├── local/
│       │   │   ├── notifications/
│       │   │   ├── realm/
│       │   │   └── tflite/
│       ├── domain/
│       └── presentation/
│
├── firebase_options.dart
└── main.dart
```

---

# ⚙️ Tech Stack

| Category         | Technologies                          |
| ---------------- | ------------------------------------- |
| Frontend         | Flutter, Dart                         |
| Machine Learning | TensorFlow Lite, LSTM Neural Networks |
| Backend/Cloud    | Firebase Auth, MongoDB                |
| Local Database   | Realm                                 |
| State Management | Provider                              |
| Native Android   | Kotlin, Notification Listener Service |
| APIs             | Google Safe Browsing API, REST APIs   |
| Utilities        | url_launcher                          |

---

# 📱 Screens Included

* Login Screen
* Signup Screen
* Dashboard
* Detection History
* Link Scanner
* Cybercrime Report Screen
* Profile Screen

---

# 🔒 Security Highlights

* Offline on-device ML inference
* No dependency on continuous internet access
* Real-time notification monitoring
* Suspicious link detection
* Secure Firebase authentication
* Modular cybersecurity architecture

---

# 📈 Future Improvements

* MongoDB cloud synchronization
* Dynamic dashboard analytics
* Push notification alert system
* Dark web monitoring
* Multi-language support
* Advanced phishing detection models
* Play Store deployment

---

# 🛠️ Installation

## 1. Clone Repository

```bash
git clone https://github.com/Ramya755/CyberShield.git
```

## 2. Navigate to Project

```bash
cd CyberShield
```

## 3. Install Dependencies

```bash
flutter pub get
```

## 4. Run Application

```bash
flutter run
```

---

# 🔥 Firebase Setup

1. Create Firebase project.
2. Enable Email/Password Authentication.
3. Run:

```bash
flutterfire configure
```

4. Ensure generated `firebase_options.dart` is used.

---

# 📌 Note

CyberShield is an educational and research-oriented cybersecurity project focused on real-time phishing awareness, offline-first protection, and secure Android threat monitoring.

---

# ⭐ GitHub

If you found this project useful, consider giving it a star.
