# Cat Facts App (Pick Your Own API)

Flutter app using the free **Cat Facts API** (https://catfact.ninja, no API key).

- **Screen 1 – The Order (FutureBuilder):** loads 10 facts once. Spinner, error + Retry, empty message, list.
- **Screen 2 – The Belt (StreamBuilder):** a new random fact every 5 seconds. Loading, error, live data. A failed fetch doesn't stop the stream.
- Typed objects via `CatFact.fromJson`, status-code check and 10s timeout on every request.

## Run
```
flutter create .
flutter pub get
flutter run
```
(`flutter create .` adds the android/ios folders; it keeps these lib files.)

## Files
- `lib/cat_fact.dart` – model + fromJson
- `lib/api_service.dart` – API calls
- `lib/future_screen.dart` – Screen 1
- `lib/stream_screen.dart` – Screen 2
- `lib/main.dart` – app + bottom tabs
