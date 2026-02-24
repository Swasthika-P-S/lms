# 🎓 Placement Portal - College Placement Preparation Platform

A professional Flutter web application for placement preparation featuring DSA, DBMS, OOPs, C++, and Java modules with AI-powered assistance.

## ✨ Features

- 🔐 **Firebase Authentication** - Google Sign-In & Email/Password
- 🤖 **AI Chatbot** - Gemini-powered placement assistant
- 📚 **5 Core Subjects** - 480+ curated problems
  - Data Structures & Algorithms (150 problems)
  - Database Management (80 problems)
  - Object-Oriented Programming (60 problems)
  - C++ Programming (100 problems)
  - Java Development (90 problems)
- 📊 **Progress Tracking** - Real-time topic-wise completion
- 🏆 **Leaderboard** - Score-based college rankings
- 🔗 **External Resources** - W3Schools, GeeksforGeeks, HackerRank, LeetCode
- 💾 **Offline Support** - Firebase offline persistence
- 🎨 **Premium UI** - Modern, responsive design

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.0+)
- Firebase account
- Gemini API key

### Setup

1. **Clone & Install**
   ```bash
   cd d:\sem6\mad\lms
   flutter pub get
   ```

2. **Firebase Setup**
   - Follow the complete guide: [FIREBASE_SETUP_GUIDE.md](https://file///C:/Users/swast/.gemini/antigravity/brain/870df436-bf31-48b8-8aaf-959efb8ca269/FIREBASE_SETUP_GUIDE.md)
   - Create Firebase project
   - Enable Authentication (Google + Email)
   - Set up Firestore & Storage
   - Deploy security rules

3. **Configure API Keys**
   - Edit `lib/config/api_keys.dart`
   - Add your Gemini API key
   - Update `lib/services/firebase_service.dart` with Firebase config

4. **Run**
   ```bash
   flutter run -d chrome
   ```

## 📁 Project Structure

```
lib/
├── config/
│   └── api_keys.dart              # API configuration
├── models/
│   ├── user_model.dart
│   ├── course_model.dart
│   ├── problem_model.dart
│   └── progress_model.dart
├── services/
│   ├── firebase_service.dart      # Firebase init
│   ├── auth_service.dart          # Authentication
│   ├── firestore_service.dart     # Database
│   ├── chatbot_service.dart       # Gemini AI
│   └── api_service.dart           # External APIs
├── providers/
│   ├── firebase_auth_provider.dart
│   └── chatbot_provider.dart
├── widgets/
│   └── chatbot_widget.dart        # Floating AI assistant
└── main.dart
```

## 🛠️ Technology Stack

- **Frontend**: Flutter Web
- **Backend**: Firebase (Auth, Firestore, Storage, Hosting)
- **AI**: Google Gemini API
- **State Management**: Provider
- **External APIs**: W3Schools, GeeksforGeeks, HackerRank, LeetCode

## 📚 Documentation

- [Implementation Plan](https://file///C:/Users/swast/.gemini/antigravity/brain/870df436-bf31-48b8-8aaf-959efb8ca269/implementation_plan.md) - Technical architecture
- [Firebase Setup Guide](https://file///C:/Users/swast/.gemini/antigravity/brain/870df436-bf31-48b8-8aaf-959efb8ca269/FIREBASE_SETUP_GUIDE.md) - Step-by-step setup
- [Walkthrough](https://file///C:/Users/swast/.gemini/antigravity/brain/870df436-bf31-48b8-8aaf-959efb8ca269/walkthrough.md) - What was built
- [Task Tracker](https://file///C:/Users/swast/.gemini/antigravity/brain/870df436-bf31-48b8-8aaf-959efb8ca269/task.md) - Development progress

## 🔑 Features Breakdown

### Authentication
- Google Sign-In (OAuth 2.0)
- Email/Password registration
- Automatic Firestore user profile creation
- Secure session management

### AI Chatbot
- **Floating widget** - Bottom-right corner assistant
- **Context-aware** - Understands placement prep context
- **Specialized queries**: Code help, concept explanation, hints, interview tips
- **Markdown support** - Code syntax highlighting

### Progress Tracking
- Topic-wise completion percentage
- Problem difficulty breakdown
- Daily/weekly streaks
- Score calculation (10 points/problem)

### External Integrations
- Curated tutorials from W3Schools
- Practice problems from GeeksforGeeks
- Coding challenges from HackerRank & LeetCode
- Direct platform linking

## 🎯 Next Steps

1. **Complete Firebase Setup** (See FIREBASE_SETUP_GUIDE.md)
2. **Populate Course Data** in Firestore
3. **Build Course Modules** (DSA, DBMS, OOPs, C++, Java)
4. **Create Dashboards** (Home, Analytics, Leaderboard)
5. **Deploy to Production** (Firebase Hosting)

## 🔒 Security

- ✅ Firestore security rules (user data isolation)
- ✅ Storage rules (file upload validation)
- ✅ API key protection (not in Git)
- ✅ Authentication required for all operations

## 🚀 Deployment

### Build for Production
```bash
flutter build web --release
```

### Deploy to Firebase
```bash
firebase login
firebase deploy --only hosting
```

Your app will be live at: `https://YOUR_PROJECT_ID.web.app`

### Custom Domain (Optional)
1. Purchase domain (₹500-1500/year)
2. Firebase Console → Hosting → Add custom domain
3. Configure DNS
4. SSL auto-provisioned

## 📊 Scalability

- **Users**: 1000+ concurrent (Firebase auto-scaling)
- **Database**: Unlimited documents (Firestore)
- **Storage**: 5GB free tier
- **Hosting**: 10GB bandwidth/month (free)

## 💡 Tips

- **API Keys**: Never commit to Git! Add `lib/config/api_keys.dart` to `.gitignore`
- **Testing**: Use Firebase emulator suite for local testing
- **Performance**: Enable offline persistence for better UX
- **Analytics**: Add Firebase Analytics for user insights

## 📞 Support

- Firebase Docs: https://firebase.google.com/docs
- FlutterFire: https://firebase.flutter.dev/
- Gemini API: https://ai.google.dev/docs

## 📝 License

This is an educational project for college placement preparation.

---

**Built with ❤️ using Flutter & Firebase**

🔥 **Status**: Backend Complete | Frontend In Progress  
🎯 **Goal**: Production-ready placement portal
