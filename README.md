# SynaPlay

A Flutter application for SynaPlay — built with Supabase for authentication and backend services.

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- A [Supabase](https://supabase.com) project with the URL and anon key configured

### Setup

1. Clone the repository
2. Copy your Supabase credentials into `lib/core/config/supabase_config.dart`
3. Run `flutter pub get`
4. Launch with `flutter run`

## Project Structure

```
lib/
├── app.dart                  # App entry point and MaterialApp setup
├── main.dart                 # Supabase initialization and runApp
├── common/widgets/           # Shared UI components
├── core/
│   ├── config/               # Environment configuration
│   ├── supabase/             # Supabase client singleton
│   └── theme/                # Colors and theme
└── features/
    └── auth/                 # Authentication feature (landing, signup, player card)
```

## Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Supabase Flutter SDK](https://supabase.com/docs/reference/dart/introduction)
