
# Flutter Firebase Chat App
A real-time messaging application that uses Firebase for backend services. Supports email authentication, user profiles, friend systems, and one-on-one chat functionalities including time stamps and image sending. 

## Why I Built This

I built this project as my first hands-on experience with both Flutter and Firebase and tested it with family and friends!


## Screenshots
<div style="display: flex; flex-direction: row; justify-content: space-between;">
    <img src="https://github.com/user-attachments/assets/d20802c3-fe75-47c0-af7a-f647894ba070" width="22%" />
    <img src="https://github.com/user-attachments/assets/ac5cf65d-6045-4661-8d3f-ce0c22477689" width="22%" />
    <img src="https://github.com/user-attachments/assets/33cfc64a-f9a2-40a6-8b08-8345ffc77a36" width="22%" />
    <img src="https://github.com/user-attachments/assets/fef652a4-1590-4579-9877-01e7e5ca93e4" width="22%" />
</div>

## Features

- Email authentication (Firebase Auth)
- User profiles with editable display names and profile pictures
- Friend requests and friend list
- One-on-one private chat (text and images, with time stamps)
- Real-time updates via Firestore


## Project Setup

### Prerequisites
- Flutter SDK (version 3.0 or higher)
- Dart SDK (version 2.17 or higher)
- Node.js and npm
- Firebase account

### Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/flutter-firebase-chat.git
   cd flutter-firebase-chat
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Install the FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

4. Log into Firebase:
   ```bash
   firebase login
   ```

5. Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com/)

6. Configure your Flutter app with Firebase:
   ```bash
   flutterfire configure
   ```
   This command will:
   - Create Android, iOS, and web apps in your Firebase project (note the app currently only supports android)
   - Download and add the necessary configuration files
   - Add the required Firebase configuration to your Flutter project

7. Enable Firebase services:
   - Go to Firebase Console
   - Enable Authentication (Email/Password)
   - Set up Cloud Firestore
   - Set up Firebase Storage

8. Update Firestore rules:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /{document=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

9. Update Storage rules:
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /{allPaths=**} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

10. Run the app:
    ```bash
    flutter run
    ```

## License
Distributed under the MIT License. See `LICENSE` for more information.

## Contact
Dhruva Kumar - dhruva@dhruva-kumar.com


