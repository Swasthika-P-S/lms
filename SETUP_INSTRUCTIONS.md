# ⚠️ IMPORTANT: Enable Windows Developer Mode

Before running `flutter pub get`, you **MUST** enable Windows Developer Mode:

## Quick Steps:

1. Press `Win + I` to open Windows Settings
2. Navigate to: **Privacy & Security** → **For developers**
3. Toggle **Developer Mode** to **ON**
4. Accept the confirmation prompt
5. **Restart your computer** if prompted

## Why is this needed?

The video player packages require symbolic link support, which is only available with Developer Mode enabled on Windows.

## Alternative: Run on Web (No Developer Mode needed)

If you cannot enable Developer Mode, run the app on web instead:

```bash
flutter run -d chrome
```

## After Enabling Developer Mode:

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## All Features Implemented ✅

- ✅ App renamed to "Learning Management System"
- ✅ Fixed login navigation
- ✅ Role-based access (Admin/Student with different dashboards)
- ✅ In-app YouTube video player
- ✅ Light/Dark mode with persistence
- ✅ Theme toggle in app bar
- ✅ Professional admin dashboard

Ready for your submission! 🚀

See `walkthrough.md` in the artifacts folder for complete documentation.
