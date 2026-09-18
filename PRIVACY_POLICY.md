# StudyFlow Privacy Policy

**Effective date:** 2026-09-18

StudyFlow helps users plan and complete study sessions. This policy describes the data handled by the current Android application.

## Information used for account access

StudyFlow uses Firebase Authentication with email and password. Firebase handles the email address, Firebase user ID, authentication credentials, and account state required to sign in, create an account, and reset a password. When an account is created, the app may send the display name entered by the user to Firebase Authentication.

## Purchases and Pro access

StudyFlow uses RevenueCat to provide in-app purchases. After Firebase sign-in, the app uses the Firebase user ID as the RevenueCat app user ID. RevenueCat processes purchase and entitlement information so the app can grant or restore the `studyflow_pro` entitlement. Google Play may separately process payment and transaction information under its own policies.

The app does not place RevenueCat secret keys in the client. The Android client uses a public RevenueCat SDK key.

## Study data

The current app keeps tasks, notes, goal progress, streak values, focus-session totals, and analytics chart values in application memory during the current run. The current code does not persist these values to Firestore or local device storage. These values can be lost when the app process is cleared or the app is reinstalled.

## Analytics and advertising

The current app code does not initialize a third-party analytics SDK and does not include an advertising SDK. The in-app Analytics screen displays study values calculated from the current in-memory session; it is a product feature, not a separate tracking service.

## Sharing and retention

Firebase and RevenueCat receive the information needed to provide authentication and purchase entitlement services. StudyFlow does not currently implement a separate data-sharing database or user-profile service. Retention of Firebase Authentication and purchase records is governed by the respective providers and account actions available through those services.

## Security

Use a unique password and keep account credentials private. The app communicates with Firebase and RevenueCat through their SDKs. No online service can guarantee absolute security.

## Changes and contact

This policy must be updated with the publisher's legal name, support email, jurisdiction, account deletion process, and applicable provider links before publication. Publish this document at a stable public HTTPS URL and ensure it matches the final production configuration.
