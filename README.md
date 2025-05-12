# SafeRoute

## Overview

SafeRoute is designed to provide a safe and secure commuting experience for women by utilizing crowd-sourced data, real-time alerts, and emergency response features. This application enables users to find safe routes based on community reviews and access immediate assistance in distressing situations.

## Features

- **Safe Route Recommendations**: Users can search for safe routes based on real-time user reviews and ratings.
- **Community-Based Rating System**: Streets are categorized into three safety levels (Red, Yellow, Green) based on user feedback.
- **Emergency Alert System**: A panic button that instantly shares the user’s real-time location with emergency contacts and the community.
- **Integration with Google Maps API**: Provides route mapping and navigation services.
- **User Authentication**: Secure login and account management.
- **Real-Time Notifications**: Alerts and safety updates for users.

## Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Firestore, Authentication, Cloud Functions)
- **APIs**: Google Maps API, Firebase Cloud Messaging (FCM)
- **Hosting**: Firebase Hosting
- **Authentication**: Firebase Authentication

## Architecture

1. **User Interface (Flutter App)**: Provides an intuitive UI for navigation and interaction.
2. **Backend (Firebase Firestore & Cloud Functions)**: Manages user data, route ratings, and emergency alerts.
3. **APIs (Google Maps & Firebase Cloud Messaging)**: Retrieves maps and sends real-time notifications.
4. **Security Layer**: Authentication using Firebase Authentication.
5. **Emergency Module**: Enables real-time distress alerts and community assistance.

## Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-repository/saferoute.git
   cd saferoute
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Set up Firebase**:
   - Create a Firebase project.
   - Add Firebase to your Flutter app.
   - Enable Firestore, Authentication, and Cloud Messaging.
4. **Run the app**:
   ```bash
   flutter run
   ```

## Contribution Guidelines

- Fork the repository and create a new branch.
- Follow proper coding practices and documentation.
- Create a pull request with a detailed explanation of your changes.

## Future Enhancements

- **AI-Based Safety Prediction**: Implement AI to analyze past reports and predict safe paths.
- **Sentiment Analysis**: Analyze user reviews to determine sentiment trends.
- **Integration with Local Law Enforcement**: Direct alerts to police in emergencies.
- **Voice-Activated Emergency Commands**: Allow users to trigger emergency alerts using voice commands.

## MVP Snapshot

- Functional login and authentication system.
- Interactive map showing real-time safety ratings.
- Panic button feature working with Firebase Cloud Messaging.
- User-generated safety ratings successfully stored in Firestore.

## License

This project is licensed under the GNU General Public License - see the [LICENSE](LICENSE) file for details.
