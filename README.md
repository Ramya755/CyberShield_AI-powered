# 🛡️ CyberShield

AI-Powered Personal Cybersecurity Guardian for Android

CyberShield is an AI-powered Flutter Android application designed to protect smartphone users from phishing SMS, malicious links, and online scams in real time. The app combines on-device machine learning, offline-first architecture, native Android notification monitoring, and cybersecurity workflows to provide secure threat detection and monitoring.

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


# 📌 Note

CyberShield is an educational and research-oriented cybersecurity project focused on real-time phishing awareness, offline-first protection, and secure Android threat monitoring.

---

# ⭐ GitHub

If you found this project useful, consider giving it a star.
