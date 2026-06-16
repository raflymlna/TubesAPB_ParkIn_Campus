# park_in_campus

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Vehicle Management System

Users can register and manage multiple vehicles linked to their account:

### Features
- **Add Multiple Vehicles**: Register cars or motorcycles with license plate, brand, and model
- **Edit Vehicles**: Modify existing vehicle information
- **Delete Vehicles**: Remove vehicles from account
- **Real-time Sync**: All changes sync instantly across the app via Firebase

### License Plate Format
Format: `REGION NUMBER SERIES` (e.g., `B 1234 AMN`)
- Region: 1-2 letters (e.g., B for Jakarta)
- Number: 1-4 digits (e.g., 1234)
- Series: 1-3 letters (e.g., AMN)

### Firebase Collections
- **vehicles**: Stores vehicle records
  - `userId`: User's Firebase UID
  - `type`: 'mobil' or 'motor'
  - `licensePlate`: Vehicle plate number
  - `brand`: Vehicle brand/manufacturer
  - `model`: Vehicle model name
  - `createdAt`: Timestamp when created
  - `updatedAt`: Last update timestamp

### Security
- Vehicles are linked to each user's account via Firebase Auth UID
- Users can only view/edit/delete their own vehicles
- Firestore rules enforce ownership verification

**Firebase Hosting**
- **Files**: [firebase.json](firebase.json), [.firebaserc](.firebaserc)
- **Hosting public folder**: `build/web` (Flutter web build output)
- **Build (locally)**: run `flutter build web --release`
- **Setup & Deploy**:
	1. Install Firebase CLI if needed: `npm install -g firebase-tools`
	2. Login: `firebase login`
	3. Select your Firebase project (or set project id): `firebase use --add` and choose your project, or edit [.firebaserc](.firebaserc)
	4. Build the app: `flutter build web --release`
	5. Deploy hosting: `firebase deploy --only hosting`

Notes: If you haven't initialized Firebase hosting in this repo, running `firebase init hosting` can help set project and resource links; keep `public` set to `build/web` when prompted.
