# 🚀 SafeRoute Navigator - Flutter Safety Navigation App

SafeRoute Navigator is a Flutter-based safety-focused navigation app. It allows users to search any destination, draw a route from their live location, get distance and ETA, start the journey, and view or submit safety reviews for any location. It also integrates with **Google Cloud Vertex AI** to offer intelligent, personalized assistance based on user behavior.

---

## 📱 Features

✅ **Live Location Tracking**  
✅ **Search Places with Geocoding**  
✅ **Route Drawing (Polyline) from Current Location to Destination**  
✅ **Distance & ETA Calculation using Google Directions API**  
✅ **Start Journey with Navigation Details**  
✅ **Location Reviews - Submit & View**  
✅ **Responsive UI with Google Maps**  
✅ **AI-Enhanced Interaction using Vertex AI**

---

## 💮 Tech Stack

- **Flutter**
- **Google Maps SDK**
- **Google Directions API**
- **Geocoding API**
- **Geolocator Plugin**
- **Google Cloud Vertex AI**
- **Firebase Firestore** *(optional for review storage)*

---

## 🔧 Setup & Installation

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/your-username/safe-route-navigator.git
cd safe-route-navigator
```

### 2️⃣ Install Dependencies

```bash
flutter pub get
```

### 3️⃣ Setup API Keys

- Enable the following APIs in your **Google Cloud Console**:
  - Maps SDK for Android/iOS
  - Directions API
  - Geocoding API
  - Places API *(if needed)*
  - Vertex AI API *(for smart assistant features)*

- Add your API Key to the appropriate files:

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_API_KEY"/>
```

**iOS** (`ios/Runner/AppDelegate.swift`):

```swift
GMSServices.provideAPIKey("YOUR_API_KEY")
```

### 4️⃣ Run the App

```bash
flutter run
```

---

## ✍️ How to Use

1. Use the search bar to enter a destination.
2. The app fetches your live location and draws a route to the destination.
3. View Estimated Time of Arrival (ETA) and distance.
4. Tap **Start Journey** to begin step-by-step navigation.
5. Tap the **Review** button to submit or read safety insights for that location.
6. Interact with the built-in AI assistant powered by Vertex AI for smart suggestions and route assistance.

---

## 📌 Future Improvements

- Firebase integration for real-time review storage  
- Live location sharing during the journey  
- Voice-based turn-by-turn navigation  
- Heatmap overlays based on user safety reviews  
- **Personalized AI Assistant using Vertex AI to learn user behavior**  
- **Smart route re-routing based on safety scores and historical data**

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙌 Contributions

Pull requests are welcome!  
If you have suggestions for improvements, feel free to open an issue or submit a feature request.

---

## 🤖 Powered By

- [Google Cloud Vertex AI](https://cloud.google.com/vertex-ai)  
- [Flutter](https://flutter.dev)  
- [Google Maps Platform](https://developers.google.com/maps)

