🚀 SafeRoute Navigator - Flutter Safety Navigation App
SafeRoute Navigator is a Flutter-based safety-focused navigation app. It allows users to search any destination, draw a route from their live location, get distance and ETA, start the journey, and view or submit safety reviews for any location. It also leverages Google Cloud Vertex AI to learn from user behavior and enhance interaction for personalized experiences.

📱 Features
✅ Live Location Tracking
✅ Search Places with Geocoding
✅ Route Drawing (Polyline) from Current Location to Destination
✅ Distance & ETA Calculation using Google Directions API
✅ Start Journey with Navigation Details
✅ Location Reviews - Submit & View
✅ Responsive UI with Google Maps
✅ AI-Enhanced Interaction using Vertex AI

🧐 Tech Stack
Flutter

Google Maps SDK

Google Directions API

Geocoding API

Geolocator Plugin

Google Cloud Vertex AI

Firebase Firestore (Optional for review storage)

🔧 Setup & Installation
1️⃣ Clone the Repository
bash
Copy
Edit
git clone https://github.com/your-username/safe-route-navigator.git
cd safe-route-navigator
2️⃣ Install Dependencies
bash
Copy
Edit
flutter pub get
3️⃣ Setup API Keys
Enable the following APIs in your Google Cloud Console:

Maps SDK for Android/iOS

Directions API

Geocoding API

Places API (if required)

Vertex AI API (for AI interaction features)

Add your API Key in AndroidManifest.xml & AppDelegate.swift:

xml
Copy
Edit
<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_API_KEY"/>
4️⃣ Run the App
bash
Copy
Edit
flutter run
✍️ How to Use
Search a destination using the search bar.

The app fetches your live location and draws the route to the destination.

View ETA and distance.

Start the journey for step-by-step navigation.

Submit or view reviews for the area to ensure safety insights.

Interact with the app's AI assistant, powered by Vertex AI, for smarter suggestions and responses.

📌 Future Improvements
Firebase integration for real-time review storage

Live location updates during the journey

Voice-based turn-by-turn navigation

Safety rating heatmap

Personalized AI travel assistant using Vertex AI

Behavioral learning to adapt suggestions and routing preferences

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

🙌 Contributions
Pull requests are welcome! Feel free to open issues or suggest new features.

