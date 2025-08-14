# 🎬 Cinec Movies - Movie Booking App

A Flutter mobile application for **Cinec Movie Theatre** that allows users to browse movies, view showtimes, select seats, and book tickets online.  
Admins can manage movies, showtimes, and view all bookings.

Built with:

- **Flutter**
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Storage**

---

## 📱 Features

### 🔹 User Features

- **Login & Registration** (Email/Password via Firebase Auth)
- Browse movies that are **currently showing and not hidden**
- View **movie details** (Title, Genre, Duration, Synopsis, Poster)
- View **available showtimes**
- **Seat selection** with booked seats marked as unavailable
- Confirm bookings and view **your own booking history**

### 🔹 Admin Features

- Add new movies (Title, Genre, Duration, Synopsis, Poster)
- Edit or delete movies
- Hide/unhide movies (hidden movies are invisible to users)
- Add showtimes to movies
- View **all bookings** from all users

---

## 🗄 Firestore Structure

users (collection)
└── userId (document)
├── name: String
├── email: String
├── role: String (user/admin)
├── createdAt: Timestamp
├── lastLogin: Timestamp
└── other profile fields...

movies (collection)
└── movieId (document)
├── title: String
├── genre: String
├── duration: int (minutes)
├── synopsis: String
├── posterUrl: String
├── nowShowing: bool
├── hidden: bool
└── showtimes (subcollection)
└── showtimeId (document)
├── dateTime: Timestamp
├── ticketPrice: double
└── bookedSeats: Array<String>

bookings (collection)
└── bookingId (document)
├── movieId: String
├── movieTitle: String
├── showtimeId: String
├── userId: String
├── seats: Array<String>
└── bookingDate: Timestamp

## 🏗 Architecture & Workflow Diagram

The Cinec Movies App follows a client-server architecture using Flutter for the frontend and Firebase for the backend. Below is an overview of the architecture and workflow:

ChatGPT said:
Here’s a Markdown section for Architecture & Workflow Diagram with a textual diagram you can use in your README:

markdown
Copy code

## 🏗 Architecture & Workflow Diagram

The Cinec Movies App follows a client-server architecture using Flutter for the frontend and Firebase for the backend. Below is an overview of the architecture and workflow:

+-------------------+ +--------------------+
| | | |
| Flutter Client | <--> | Firebase Auth |
| | | Firestore DB |
+-------------------+ +--------------------+
| |
| |
v v
+-------------------+ +--------------------+
| | | |
| User Actions | | Admin Actions |
| - Login/Register | | - Add/Edit Movies |
| - Browse Movies | | - Hide/Unhide |
| - Select Showtimes| | - Add Showtimes |
| - Select Seats | | - View All Bookings|
| - Confirm Booking | | |
+-------------------+ +--------------------+
| |
+-----------+---------------+
|
v
+-------------------+
| Firestore DB |
| - users |
| - movies |
| - showtimes |
| - bookings |
+-------------------+

**Workflow:**

1. **User Flow**

   - Register / Login → Browse Movies → View Showtimes → Select Seats → Confirm Booking → Booking saved in `bookings` collection.

2. **Admin Flow**

   - Login as Admin → Add / Edit / Hide Movies → Add Showtimes → View All Bookings.

3. **Data Sync**

   - Real-time updates using Firestore streams.
   - Hidden movies automatically excluded from user queries.

4. **Media Management**
   - Posters uploaded via Image Picker → Stored in Firebase Storage → URL saved in Firestore.

**Flow Explanation:**

1. User/Admin signs in → Firebase Auth
2. Role checked → directs to appropriate dashboard
3. Users see only non-hidden movies → can book tickets
4. Admins can manage movies/showtimes and view all bookings
5. All data is synced via Firestore and images via Firebase Storage

---

## 🚀 Installation

### 1️⃣ Download APK

- Get the APK file from the provided link or [Releases](#)
- Transfer it to your Android device (if downloaded on PC)

### 2️⃣ Install

- Open the APK on your device
- Allow installation from **unknown sources** if prompted

### 3️⃣ Open the App

- Tap the **Cinec Movies** icon

---

## 🔑 Login & Registration

### User Sign Up

1. Open app → **Register**
2. Enter name, email, password, and profile details
3. Profile stored in Firestore under `users` collection

### Login

1. Open app → Enter email & password
2. Redirected to dashboard based on **role** (`user` or `admin`)

---

## 🎟 Booking Process

1. Browse available movies
2. Select a movie and **choose a showtime**
3. Pick seats from seat map (booked seats unavailable)
4. Confirm booking
5. Booking is stored in **`bookings`** collection

---

## ⚙ Admin Management

- **Add Movie:** Fill form + upload poster → Save
- **Edit Movie:** Update details → Save
- **Hide Movie:** Toggle hide → Users can’t see hidden movies
- **Add Showtimes:** Add date, time, ticket price
- **View All Bookings:** Access all users’ bookings

---

## 📦 Dependencies

- Flutter SDK (latest stable)
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- `bloc` / `cubit` for state management
- `image_picker` for posters
- `intl` for date formatting

---

## 🛠 Developer Setup

```bash
# Clone repository
git clone https://github.com/MujithabaFarahi/cinec-movie-booking-app

# Install dependencies
flutter pub get

# Run app
flutter run
```
