# 🚀 SafeRoute Navigator - Flutter Safety Navigation App

SafeRoute Navigator is a Flutter-based safety-focused navigation app. It allows users to search any destination, draw a route from their live location, get distance and ETA, start the journey, and view or submit safety reviews for any location.

---

## 📱 Features

✅ **Live Location Tracking**  
✅ **Search Places with Geocoding**  
✅ **Route Drawing (Polyline) from Current Location to Destination**  
✅ **Distance & ETA Calculation using Google Directions API**  
✅ **Start Journey with Navigation Details**  
✅ **Location Reviews - Submit & View**  
✅ **Responsive UI with Google Maps**

---

## 🗘️ Screenshots (Optional - Add later)

> _(Add your screenshots here using: ![screenshot](path-to-image))_

---

## 🧐 Tech Stack

- **Flutter**
- **Google Maps SDK**
- **Google Directions API**
- **Geocoding API**
- **Geolocator Plugin**
- **Firebase Firestore (Optional for review storage)**

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
  - Places API (if required)
- Add your API Key in `AndroidManifest.xml` & `AppDelegate.swift`:

```xml
<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_API_KEY"/>
```

### 4️⃣ Run the App

```bash
flutter run
```

---

## 💻 Project Structure

```
lib/
│
├── models/
│   └── review_model.dart
│
├── services/
│   ├── geocoding_service.dart
│   └── route_service.dart
│
├── widgets/
│   ├── reviews_dialog.dart
│   └── review_bottom_sheet.dart
│
└── screens/
    └── map_screen.dart
```

---

## ✍️ How to Use

1. Search a destination using the search bar.
2. The app fetches your live location and draws the route to the destination.
3. View ETA and distance.
4. Start the journey for step-by-step navigation.
5. Submit or view reviews for the area to ensure safety insights.

---

## 📌 Future Improvements

- Firebase integration for real-time review storage
- Live location updates during the journey
- Voice-based turn-by-turn navigation
- Safety rating heatmap

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙌 Contributions

Pull requests are welcome! Feel free to open issues or suggest new features.
