# StudyFlow Shipaton 2026 Submission Brief

## 1. App name

StudyFlow

## 2. One-line pitch

StudyFlow turns studying into a measurable daily habit: Plan -> Focus -> Complete -> Track -> Build Streak.

## 3. Problem

Students often have intentions and scattered tasks but no simple daily loop that connects planning, focused work, completion, and visible progress.

## 4. Solution

StudyFlow puts planning, a focused timer, notes, goals, streaks, motivation, and premium progress analytics in one lightweight study workflow.

## 5. Target users

Students who want a clear daily study routine, visible progress, and gentle accountability without a complex productivity system.

## 6. Core features

- Firebase email/password account access
- Planner and add-task flow
- Focus timer with task context
- Notes and add-note flow
- Goals and progress
- Study streak
- Motivation
- Pro analytics with weekly study progress

## 7. Free features

Planner, Notes, Basic Focus Timer, Study Streak, Motivation, and Basic Goals/progress.

## 8. Pro features

Advanced Analytics, Detailed Study History, Advanced Focus Sessions, Unlimited Goals, and Personalized Study Insights. Only features actually enabled in the production build should be described as available.

## 9. RevenueCat monetization flow

1. User signs in with Firebase Authentication.
2. The Firebase UID is used as the RevenueCat app user ID.
3. A non-Pro user opens Analytics and sees the RevenueCat paywall.
4. RevenueCat presents the `default` offering with `monthly`, `yearly`, and `lifetime` products.
5. A successful purchase activates `studyflow_pro`.
6. The app checks CustomerInfo and unlocks Analytics.
7. The user can restore purchases from Profile.
8. Signing out logs out of RevenueCat before Firebase sign-out.

## 10. Technical stack

Flutter 3.38.7, Dart 3.10.7, Android/Kotlin/Gradle, Firebase Core, Firebase Authentication, Cloud Firestore dependency, RevenueCat Purchases SDK, and RevenueCat Paywalls UI.

## 11. User journey

Fresh launch -> Firebase initialization -> sign up or sign in -> Dashboard -> Planner -> Focus -> Notes -> More -> Analytics paywall -> purchase or trial -> studyflow_pro entitlement -> Analytics unlocked.

## 12. Demo video under two minutes

- 0:00-0:10: Open StudyFlow and sign in.
- 0:10-0:25: Show Dashboard progress and streak.
- 0:25-0:45: Add a planner task and start Focus.
- 0:45-1:00: Add a note and set a goal.
- 1:00-1:15: Open Analytics to show the Pro paywall.
- 1:15-1:40: Complete a RevenueCat test purchase or free-trial/promo path.
- 1:40-1:55: Reopen Analytics and show weekly progress and entitlement access.
- 1:55-2:00: End on the StudyFlow value proposition.

## 13. Google Play launch checklist

- Public listing created with final package name.
- Signed release AAB uploaded through Play App Signing.
- Store text, icon, screenshots, demo video, category, content rating, target audience, ads declaration, Data Safety, and privacy URL completed.
- Login/reviewer access instructions supplied.
- Firebase Android package and SHA-1/SHA-256 release fingerprints registered.
- RevenueCat Google Play products, offering, entitlement, service account, and test users verified.
- Internal/closed testing completed before production rollout.

## 14. Shipaton submission checklist

- Public Google Play listing URL.
- Demo video under two minutes.
- 1024x1024 app icon.
- At least one 1179x2556 screenshot without a device frame.
- Product pitch and feature list.
- RevenueCat purchase/trial/promo demonstration.
- Production build link or AAB evidence.
- Confirmed reviewer account or app-access instructions.
