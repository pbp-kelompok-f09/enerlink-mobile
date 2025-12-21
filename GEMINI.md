# Enerlink Mobile

Enerlink is a sports community application designed to connect individuals with similar sports interests and facilitate venue rentals. It allows users to find training partners, form communities, and access information about sports venues.

## Tech Stack

*   **Framework:** Flutter (Dart)
*   **State Management:** Provider
*   **Networking:** `http`, `pbp_django_auth`
*   **Local Storage:** `shared_preferences`
*   **UI:** Material Design 3, `google_fonts`
*   **Backend:** Django (External)

## Architecture

The project follows a standard Flutter architecture:

*   `lib/models/`: Data models (User, Community, Event, etc.).
*   `lib/screens/`: UI Screens (Dashboard, Community, Auth, etc.).
*   `lib/services/`: API integration and Authentication (`api_client.dart`).
*   `lib/widgets/`: Reusable UI components.
*   `lib/utils/`: Constants and helpers.

## Key Files

*   **`lib/main.dart`**: Entry point of the application. Sets up the theme and routing.
*   **`lib/services/api_client.dart`**: Handles all HTTP requests, token management (JWT), and backend communication. It includes logic for handling base URLs for different environments (Web vs. Android Emulator).
*   **`lib/routes.dart`**: Manages application navigation.
*   **`pubspec.yaml`**: Lists dependencies and assets.

## Development

### Setup

1.  **Dependencies:** Run `flutter pub get` to install dependencies.
2.  **Environment:** Ensure backend is running or accessible. The app handles `localhost` (Web) and `10.0.2.2` (Android Emulator) automatically in `ApiClient`.

### Build & Run

*   **Run (Debug):** `flutter run`
*   **Build (APK):** `flutter build apk`
*   **Analyze:** `flutter analyze`
*   **Test:** `flutter test`

### Conventions

*   **API Calls:** Use `ApiClient` class in `lib/services/api_client.dart` for all backend interactions. It handles headers and authentication automatically.
*   **Styling:** defined in `EnerlinkApp` theme data in `lib/main.dart`. Use `primaryBlue` (0xFF2563EB) and `yellow` (0xFFFACC15) as core colors.
*   **Linting:** Follows `flutter_lints` rules defined in `analysis_options.yaml`.
*   **Assets:** Images are stored in `lib/assets/images/`.

## Backend Integration

The app connects to a Django backend.
*   **Base URL:**
    *   Web: `http://localhost:8000`
    *   Android Emulator: `http://10.0.2.2:8000`
*   **Authentication:** Uses Token-based authentication (saved in `SharedPreferences`).
