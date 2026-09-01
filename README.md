# WhatsApp Clone Using Flutter

A Flutter-based WhatsApp-style mobile application that demonstrates a chat application interface with Firebase Authentication, local chat/profile persistence, phone verification testing, image selection, status updates, and account settings.

> **Project type:** Flutter Mobile Application  
> **Primary language:** Dart  
> **Backend service:** Firebase Authentication  
> **Local persistence:** SharedPreferences  
> **Target platforms:** Android and iOS (Flutter project structure also contains desktop platform folders)

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [Application Flow](#application-flow)
- [File-by-File Explanation](#file-by-file-explanation)
- [Authentication](#authentication)
- [Chat System](#chat-system)
- [Status System](#status-system)
- [Profile and Settings](#profile-and-settings)
- [Local Data Storage](#local-data-storage)
- [Firebase Configuration](#firebase-configuration)
- [Permissions](#permissions)
- [Installation and Setup](#installation-and-setup)
- [Running the Project](#running-the-project)
- [GitHub Commands](#github-commands)
- [Limitations](#limitations)
- [Possible Future Improvements](#possible-future-improvements)
- [Author](#author)

---

## Overview

This project is a **WhatsApp UI and functionality clone built with Flutter**. It is designed as an educational/project application to demonstrate how a messaging application can be developed using Flutter and Dart.

The application includes:

- Email/password registration and login using Firebase Authentication
- A phone-number login/testing flow
- WhatsApp-style Chats, Status, and Calls tabs
- One-to-one chat screens
- Local message persistence
- Profile name, About information, and profile image
- Camera/gallery image selection
- Status image selection and viewing
- Account settings
- Logout navigation

The project follows a simple Flutter architecture where individual application screens are separated into Dart files.

---

## Features

### 1. User Registration

Users can create an account using:

- Email address
- Password

Firebase Authentication handles the account creation.

### 2. User Login

Existing users can log in using:

- Email
- Password

Firebase Authentication validates the credentials.

### 3. Phone Login / Test OTP

The project contains a phone authentication screen and OTP verification screen.

The current implementation includes a **test authentication flow** with a configured test phone number and test OTP. This is useful for demonstration purposes but should be replaced with production Firebase Phone Authentication before deployment.

### 4. Chat Interface

The application provides a WhatsApp-style chat screen where users can:

- Open a conversation
- Type a message
- Send a message
- View message timestamps
- Persist messages locally

### 5. Recent Chat Updates

When a message is sent, the corresponding contact's latest message is moved to the top of the chat list.

### 6. Status

Users can:

- Select an image from the gallery
- Add it as their status
- View their added status images
- Tap through multiple status images

### 7. Calls Tab

A Calls tab is provided as part of the WhatsApp-style navigation.

Currently it displays:

```text
No Calls
```

Actual audio/video calling is not implemented.

### 8. Profile Settings

Users can update:

- Profile name
- About/status text
- Profile picture

The profile picture can be selected using:

- Camera
- Gallery

### 9. Local Persistence

The application stores selected profile information and chat messages locally using `SharedPreferences`.

---

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application framework |
| Dart | Programming language |
| Material UI | Application interface components |
| Firebase Core | Firebase initialization |
| Firebase Authentication | Email/password authentication and Firebase phone-auth support |
| SharedPreferences | Local key-value storage |
| Image Picker | Camera/gallery image selection |
| Dart `dart:io` | Local file handling |
| JSON | Serialization of chat messages |
| Hive / Hive Flutter | Included as project dependencies for local storage |
| Path Provider | Included as a project dependency for filesystem paths |
| Cupertino Icons | iOS-style icons |
| Flutter Lints | Dart/Flutter code analysis |

### Important implementation note

`hive`, `hive_flutter`, and `path_provider` are present in `pubspec.yaml`, but the current application code primarily uses `SharedPreferences` for its implemented local persistence. They should therefore be described as **included dependencies**, not as the main storage mechanism of the current implementation.

---

## Project Structure

```text
WhatsAppClone-main/
└── WhatsAppClone-main/
    └── whatsapp/
        │
        ├── android/
        │   ├── app/
        │   │   ├── src/
        │   │   │   ├── debug/
        │   │   │   └── main/
        │   │   │       ├── java/
        │   │   │       ├── kotlin/
        │   │   │       │   └── com/example/whatsapp/
        │   │   │       │       └── MainActivity.kt
        │   │   │       ├── res/
        │   │   │       └── AndroidManifest.xml
        │   │   ├── build.gradle.kts
        │   │   └── google-services.json
        │   └── ...
        │
        ├── assets/
        │   └── whatsapp.jpg
        │
        ├── ios/
        │   ├── Runner/
        │   ├── Runner.xcodeproj/
        │   ├── Runner.xcworkspace/
        │   └── ...
        │
        ├── lib/
        │   ├── main.dart
        │   ├── LoginScreen.dart
        │   ├── SignupScreen.dart
        │   ├── PhoneAuthScreen.dart
        │   ├── OtpVerifyScreen.dart
        │   ├── StatusPage.dart
        │   ├── ChatPage.dart
        │   ├── ChatStorage.dart
        │   └── SettingsPage.dart
        │
        ├── linux/
        ├── macos/
        ├── test/
        ├── web/
        ├── windows/
        │
        ├── analysis_options.yaml
        ├── pubspec.yaml
        ├── pubspec.lock
        └── .gitignore
```

### Important generated folders

The following folders/files are generated or IDE-specific and should normally not be committed:

```text
.dart_tool/
build/
.idea/
.gradle/
```

The project's `.gitignore` already excludes several Flutter-generated files and build artifacts.

---

# Application Flow

```text
                    ┌─────────────────┐
                    │    main.dart    │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   LoginScreen   │
                    └───────┬─────────┘
                            │
              ┌─────────────┼──────────────┐
              │             │              │
              ▼             ▼              ▼
        Email Login      Sign Up       Phone Login
              │             │              │
              │             ▼              ▼
              │       Firebase Auth   OTP Screen
              │                            │
              └──────────────┬─────────────┘
                             ▼
                    ┌─────────────────┐
                    │   StatusPage    │
                    │ CHATS | STATUS  │
                    │       | CALLS   │
                    └────────┬────────┘
                             │
          ┌──────────────────┼─────────────────┐
          │                  │                 │
          ▼                  ▼                 ▼
      ChatPage          Status Images      Calls Tab
          │                  │                 │
          ▼                  ▼                 ▼
 SharedPreferences      Image Picker       Placeholder
```

---

# File-by-File Explanation

## `lib/main.dart`

This is the entry point of the Flutter application.

Main responsibilities:

- Initializes Flutter bindings
- Initializes Firebase
- Starts the Flutter application
- Configures the application theme
- Opens `LoginScreen` as the first screen

Important initialization:

```dart
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
```

---

## `lib/LoginScreen.dart`

Provides the login interface.

### Functions

- Email input
- Password input
- Firebase email/password login
- Navigation to Sign Up
- Navigation to Phone Authentication
- Error handling for invalid credentials

Firebase method used:

```dart
signInWithEmailAndPassword()
```

The **Forgot Password** button is currently present in the UI but does not contain an implemented password-reset action.

---

## `lib/SignupScreen.dart`

Provides account registration.

### Functions

- Email input
- Password input
- Firebase account creation
- Validation of empty fields
- Handling existing email
- Handling weak passwords

Firebase method used:

```dart
createUserWithEmailAndPassword()
```

---

## `lib/PhoneAuthScreen.dart`

Provides the phone-number login/testing interface.

The current code checks for a configured test phone number and then opens the OTP screen.

This is a **demo/test implementation**, not a complete production phone-number authentication flow.

---

## `lib/OtpVerifyScreen.dart`

Handles OTP verification.

It supports two paths:

### Test mode

The current code uses a predefined test OTP.

```text
654321
```

### Firebase mode

The code also contains the Firebase credential-based verification path:

```dart
PhoneAuthProvider.credential(
    verificationId: verificationId,
    smsCode: otp,
);
```

After successful verification, the user is taken to `StatusPage`.

---

## `lib/StatusPage.dart`

This is the main application screen after authentication.

It contains three tabs:

```text
CHATS
STATUS
CALLS
```

### Chats tab

Displays predefined chat contacts and their latest messages.

Selecting a contact opens `ChatPage`.

### Status tab

Allows the user to:

- Pick an image from the gallery
- Add it to the status list
- View status images

### Calls tab

Currently displays:

```text
No Calls
```

### Menu

The top-right menu provides:

- Settings
- Logout

---

## `lib/ChatPage.dart`

Displays an individual chat conversation.

### Main functions

- Loads messages from `SharedPreferences`
- Displays messages
- Sends new messages
- Adds timestamps
- Saves messages locally
- Updates the chat list

Messages are stored using a key based on the contact name:

```text
chat_<contact_name>
```

Messages are serialized using JSON.

---

## `lib/ChatStorage.dart`

Provides a separate helper class for chat persistence.

It contains:

```dart
loadMessages()
saveMessages()
```

It also maintains an in-memory cache:

```dart
_cachedMessages
```

This reduces repeated access to `SharedPreferences` during the application's execution.

---

## `lib/SettingsPage.dart`

Handles user profile settings.

### User can update:

- Name
- About
- Profile image

### Image sources

```text
Camera
Gallery
```

Profile information is stored using:

```text
name
status
imagePath
```

The same file also contains `ProfilePage`, which displays the saved profile information.

---

# Authentication

The application uses **Firebase Authentication**.

## Email Authentication

Registration:

```text
SignupScreen
      ↓
FirebaseAuth
      ↓
createUserWithEmailAndPassword()
```

Login:

```text
LoginScreen
      ↓
FirebaseAuth
      ↓
signInWithEmailAndPassword()
```

## Phone Authentication

The project contains the required Flutter/Firebase authentication code structure for OTP verification, but the current `PhoneAuthScreen` uses a hardcoded test number and the OTP screen supports a hardcoded test OTP.

For a production application, this should be replaced with Firebase's actual phone verification flow.

---

# Chat System

The chat system is currently **local**, rather than a real-time cloud messaging system.

### Message format

A message is represented approximately as:

```json
{
  "text": "Hello",
  "time": "10:30 PM"
}
```

A list of these message objects is converted into JSON and stored in `SharedPreferences`.

### Storage key

```text
chat_<contact_name>
```

Example:

```text
chat_pratyaksh
```

### Message flow

```text
User types message
       ↓
Send button
       ↓
Message added to list
       ↓
Timestamp generated
       ↓
JSON encoding
       ↓
SharedPreferences
```

---

# Status System

The Status feature uses the `image_picker` package.

### Flow

```text
Status Tab
    ↓
Add button
    ↓
Gallery
    ↓
Select image
    ↓
File object
    ↓
Status list
    ↓
Status viewer
```

The status viewer allows the user to tap the screen to move through the selected status images.

Current status data is maintained in memory and is not persisted across application restarts.

---

# Profile and Settings

The Settings screen allows users to configure their profile.

### Profile fields

```text
Name
About
Profile Picture
```

### Storage

The following keys are used:

```text
name
status
imagePath
```

The profile page reads these values from `SharedPreferences` and displays them.

---

# Local Data Storage

The project primarily uses:

## SharedPreferences

Used for:

- Chat messages
- Profile name
- About information
- Profile image path

Example:

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString('name', name);
```

### JSON

Chat messages are converted into JSON before being saved:

```dart
jsonEncode(messages)
```

and reconstructed using:

```dart
jsonDecode(savedChats)
```

---

# Firebase Configuration

The Android Firebase configuration is included through:

```text
android/app/google-services.json
```

Firebase is initialized in:

```text
lib/main.dart
```

Before running the application on another machine, Firebase should be configured for the developer's own Firebase project.

### Required Firebase setup

1. Create a Firebase project.
2. Add the Android application.
3. Download the Firebase Android configuration file.
4. Place it in:

```text
android/app/google-services.json
```

5. Enable Email/Password authentication in Firebase Authentication.
6. If production phone authentication is required, enable Phone Authentication.
7. Configure Firebase test phone numbers if using Firebase's test-number feature.

> Do not publish real service credentials, private keys, or other sensitive configuration in a public repository.

---

# Permissions

The Android application declares permissions related to image and camera functionality.

Examples include:

```xml
android.permission.CAMERA
android.permission.READ_EXTERNAL_STORAGE
android.permission.WRITE_EXTERNAL_STORAGE
android.permission.READ_MEDIA_IMAGES
android.permission.READ_MEDIA_VIDEO
```

These permissions support camera and media selection functionality on Android.

---

# Installation and Setup

## Prerequisites

Install:

- Flutter SDK
- Dart SDK (included with Flutter)
- Android Studio
- Android SDK
- Android Emulator or a physical Android device
- Firebase project

Verify Flutter:

```bash
flutter --version
```

Check the development environment:

```bash
flutter doctor
```

---

## Clone the Repository

```bash
git clone https://github.com/abhinavgupta30/WhatsApp-Clone-using-Flutter.git
```

Move into the Flutter application directory:

```bash
cd WhatsApp-Clone-using-Flutter
```

If the GitHub repository contains the `whatsapp` directory as the project root:

```bash
cd whatsapp
```

---

## Install Dependencies

Run:

```bash
flutter pub get
```

---

## Check Connected Devices

```bash
flutter devices
```

---

## Run the Application

```bash
flutter run
```

To run specifically on an Android device/emulator:

```bash
flutter run -d android
```

---

# GitHub Commands

After making changes:

```bash
git add .
git commit -m "Update WhatsApp clone"
git push
```

To check the current Git state:

```bash
git status
```

To view the remote repository:

```bash
git remote -v
```

Repository:

```text
https://github.com/abhinavgupta30/WhatsApp-Clone-using-Flutter
```

---

# Limitations

This project is a **WhatsApp-style educational clone**, not a production replacement for WhatsApp.

Current limitations include:

1. **Chat messages are stored locally** using `SharedPreferences`.
2. There is no Firebase/Firestore real-time chat backend.
3. Messages are not synchronized between different devices/users.
4. The Calls tab is a placeholder.
5. Audio/video calling is not implemented.
6. The Forgot Password button does not currently perform a password reset.
7. Status images are currently stored in memory and are not persisted after app restart.
8. Phone login currently contains a test-number/test-OTP flow.
9. There are no push notifications for new messages.
10. There is no end-to-end encryption implementation.
11. User search/contact management is not implemented.
12. The chat list currently contains predefined contacts.

---

# Possible Future Improvements

The project can be extended with:

### Backend

- Firebase Firestore
- Firebase Storage
- Real-time messaging
- User profiles
- Online/offline status
- Message synchronization

### Messaging

- Message delivery status
- Read receipts
- Typing indicators
- Reply to messages
- Message deletion
- Image/video/document sharing
- Voice messages
- Group chats

### Status

- Persistent status storage
- Status expiration after 24 hours
- Status viewer tracking
- Video status support

### Calls

- Voice calling
- Video calling
- Call history
- WebRTC integration

### Notifications

- Firebase Cloud Messaging
- New-message notifications
- Call notifications

### Security

- Better authentication flow
- Secure backend access rules
- Firestore security rules
- Firebase Storage security rules
- Removal of hardcoded test credentials from application code

---

# Learning Objectives

This project demonstrates practical use of:

- Flutter application development
- Dart programming
- Stateful and Stateless widgets
- Flutter navigation
- Material UI
- Firebase Authentication
- Local data persistence
- JSON serialization
- Image selection
- File handling
- Android permissions
- Multi-screen application architecture
- Git and GitHub version control

---

# Conclusion

The WhatsApp Clone project demonstrates how a modern messaging application's interface and core educational functionality can be developed using **Flutter and Dart**.

The application combines Firebase Authentication with local storage to provide authentication, chat, profile, and status functionality while maintaining a simple and understandable project structure.

It can serve as a foundation for developing a more complete real-time messaging application by integrating Firebase Firestore, Firebase Storage, Cloud Messaging, and real-time calling technologies.

---

# Author

**Abhinav Gupta**

GitHub:

```text
https://github.com/abhinavgupta30
```

Repository:

```text
https://github.com/abhinavgupta30/WhatsApp-Clone-using-Flutter
```

---

## Disclaimer

This project is developed for **educational and demonstration purposes**. It is an independent WhatsApp-style application and is not affiliated with or endorsed by WhatsApp or Meta Platforms, Inc.
