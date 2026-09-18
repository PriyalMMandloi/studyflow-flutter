# StudyFlow Google Play Release Checklist

## App setup

- Create the Android app in Play Console with the final package name `com.example.studyflow_flutter`.
- Confirm the app name is `StudyFlow` and the release version is incremented from `1.0.0+1`.
- Enroll in Google Play App Signing and create an upload key locally. Do not commit `android/key.properties`, `.jks`, or `.keystore` files.
- Replace the debug signing config in `android/app/build.gradle.kts` with the local upload-key config before uploading an AAB.

## Store listing

- Short description: `Turn study plans into a measurable daily habit.`
- Full description: Explain the Plan -> Focus -> Complete -> Track -> Build Streak journey, free features, and Pro analytics without claiming features that are not shipped.
- Category: Education.
- Upload a 1024x1024 launcher icon and at least one 1179x2556 screenshot without a device frame.
- Add additional phone screenshots, a feature graphic if requested by Play Console, and a demo video under two minutes.
- Add the public Privacy Policy URL and complete Content Rating, Target Audience, Ads declaration, and Data Safety forms.
- Provide app-access instructions for reviewers: create an account with email/password, or provide a dedicated review account through Play Console. Never publish a real user's password in source control.

## Billing and testing

- In RevenueCat, create the Google Play products `monthly`, `yearly`, and `lifetime`, attach them to offering `default`, and map the `studyflow_pro` entitlement.
- Connect RevenueCat to the Google Play service account and verify package name, products, base plans, offer/trial, and tester access.
- Use the Android public SDK key in the release build through `--dart-define=REVENUECAT_ANDROID_API_KEY=...`; keep the Test Store key as the development default only.
- Add license testers in Play Console and test purchase, cancellation, restore, account switching, reinstall, and entitlement refresh.
- Upload the signed AAB to an internal or closed test first, then promote to production after billing and Firebase checks pass.

## Data Safety basis for this project

- Firebase Authentication is used for email/password account access and stores account identifiers such as email, Firebase UID, and optional display name.
- RevenueCat processes the Firebase UID as the RevenueCat app user ID and purchase/subscription state needed to grant Pro access.
- The current task, note, goal, streak, and chart values are held in app memory and are not currently persisted to Firestore or local storage.
- No ads SDK or third-party analytics SDK is configured in the project. Firebase Analytics is not initialized by the current app code.
- Confirm these statements against the final Firebase and RevenueCat dashboards before submitting the Data Safety form and Privacy Policy URL.

## Final command

```powershell
flutter analyze
flutter build appbundle --release --dart-define=REVENUECAT_ANDROID_API_KEY=<public-google-play-sdk-key>
```
