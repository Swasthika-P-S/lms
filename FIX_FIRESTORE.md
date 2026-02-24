# 🔴 FIRESTORE CONNECTIVITY FIX

The error `[cloud_firestore/unavailable]` usually means the **Database doesn't exist yet**.

## ⚡ STEP 1: Check Firebase Console (CRITICAL)

1. Go to: https://console.firebase.google.com/
2. Open Project: **placement-lms-a8ca5**
3. Click **"Firestore Database"** in the left sidebar.
4. **DO YOU SEE DATA?**
   - **NO (It says "Create Database"):** 👉 Click **"Create Database"**
     - Select **"Start in Test Mode"** (easier for now)
     - Select a location (e.g., `nam5 (us-central)`)
     - Click **"Enable"**
   - **YES:** Go to Step 2.

## ⚡ STEP 2: Check Rules

If the database exists, check the **"Rules"** tab at the top of Firestore.
Paste this to allow everything for testing:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```
*(Click "Publish" after pasting)*

## ⚡ STEP 3: Restart App

1. **Close** the browser tab.
2. Press `R` in your terminal to restart the app.
3. Try the **"Direct Firebase Test"** red button again.

---
**MOST LIKELY CAUSE:** You authorized Login, but you didn't click "Create Database" for Firestore yet!
