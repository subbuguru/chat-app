
# Flutter Firebase Chat App
A real-time messaging application that uses Firebase for backend services. Supports essential features such as email authentication, user profiles, friend systems, and one-on-one chat functionalities including time stamps and image sending capabilities. Currently only android has been tested.

## Screenshots
<div style="display: flex; flex-direction: row; justify-content: space-between;">
    <img src="https://github.com/user-attachments/assets/d20802c3-fe75-47c0-af7a-f647894ba070" width="22%" />
    <img src="https://github.com/user-attachments/assets/ac5cf65d-6045-4661-8d3f-ce0c22477689" width="22%" />
    <img src="https://github.com/user-attachments/assets/33cfc64a-f9a2-40a6-8b08-8345ffc77a36" width="22%" />
    <img src="https://github.com/user-attachments/assets/fef652a4-1590-4579-9877-01e7e5ca93e4" width="22%" />
</div>

## Features
- **Email Authentication**: Securely sign up and log in using Firebase Authentication with email and password.
- **User Profiles**: Create and edit user profiles, including profile pictures, to personalize the chat experience.
- **Friends System**: Send and receive friend requests to build your chat network.
- **One-on-One Chat**: Engage in private conversations with friends, complete with time-stamped messages.
- **Image Sending**: Share images within chats to enhance communication.
- **Real-Time Updates**: Experience seamless real-time chat thanks to Firebase's real-time database updates.

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

## Usage
- **Sign Up/Log In**: Start by signing up or logging in using your email and password.
- **Edit Profile**: Navigate to the profile section to add or edit your profile picture and details.
- **Add Friends**: Use the friend system to connect with other users by sending friend requests.
- **Chat**: Select a friend from your friend list to start a one-on-one chat. You can send text messages, images, and view time-stamped messages.

## License
Distributed under the MIT License. See `LICENSE` for more information.

## Contact
Dhruva Kumar - dkumardevelopment@gmail.com

## Note
This Readme.MD was generated with ChatGPT

