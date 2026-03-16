<div align="center">

<!-- Replace the path below with your actual logo file path -->
<img src="assets/images/logo/applogo.svg" alt="DayTask Logo" width="150"/>

# 📋 DayTask — Task Management App

*Stay organized. Stay productive. One task at a time.*

[![Download App](https://img.shields.io/badge/⬇️%20Download%20App-Google%20Drive-blue?style=for-the-badge)](https://drive.google.com/drive/folders/1ALa4LMLRSNlo-AfE8aKxtOtkfFS7qBxy?usp=sharing)
[![Demo Video](https://img.shields.io/badge/▶️%20Watch%20Demo-Google%20Drive-red?style=for-the-badge)](https://drive.google.com/drive/folders/15wpaOKLergvQVzf40ISyQte0X5RydYxL?usp=sharing)

</div>

---

## 📖 Table of Contents

- [About the App](#-about-the-app)
- [App Flow](#-app-flow)
- [Tech Stack](#-tech-stack)
- [Clean Architecture](#-clean-architecture)
- [Behind the Scenes](#-behind-the-scenes--key-technical-highlights)
- [Getting Started](#-getting-started)
- [Folder Structure](#-folder-structure)

---

## 🌟 About the App

**DayTask** is a clean, intuitive, and powerful task management mobile application built with **Flutter**. Whether you're juggling work deadlines, personal goals, or daily to-dos — DayTask helps you stay on top of everything with a smooth and delightful experience.

The app is designed with a focus on:
- ✅ **Simplicity** — A clean UI that gets out of your way
- ⚡ **Performance** — Snappy navigation and real-time data updates
- 🌗 **Personalization** — Full Dark and Light theme support that *remembers* your preference
- 🔒 **Security** — Powered by Supabase authentication so your data is always yours

---

## 🗺️ App Flow

Here's a walkthrough of the user journey through the app — from the moment you open it to managing your daily tasks.

### 1. 💫 Splash Screen
When you first launch DayTask, you're greeted by a **Splash Screen** featuring the app logo. But this isn't just a pretty face — it's doing smart work in the background.

> The Splash Screen checks your current session status:
> - **Already logged in?** → You'll be taken directly to the **Home Screen**. No friction.
> - **Not logged in?** → You'll be redirected to the **Authentication Screen**.

This makes every app launch fast and frictionless.

---

### 2. 🔐 Authentication Screen
If no active session is found, the user lands on the **Auth Screen**. Authentication is powered by **Supabase**, which handles:
- 📧 Email & Password sign-up and login
- 🔄 Session persistence across app restarts
- 🛡️ Secure token management under the hood

Once authenticated, you'll never see this screen again — unless you choose to log out.

---

### 3. 🏠 Home / Dashboard Screen
This is your **command center**. The dashboard gives you an instant bird's-eye view of all your tasks, beautifully laid out using Flutter's **Sliver Lists** for a smooth, high-performance scrolling experience.

The Home Screen is split into two key sections:

| Section | Description |
|---|---|
| ✅ **Completed Tasks** | All the tasks you've already knocked out |
| 🔄 **Ongoing Tasks** | Tasks that are still in progress and need your attention |

The Sliver-based layout ensures that even with hundreds of tasks, scrolling remains silky smooth.

---

### 4. ✏️ Task Management
Users have full control over their tasks:
- ➕ **Create a new task** — Add a title, description, and any relevant details
- 👁️ **View task details** — Tap any task to see its full information
- 🔄 **Update task status** — Mark tasks as complete or keep them ongoing

---

### 5. 👤 Profile Screen
The **Profile Screen** is your personal space within the app. Here you can:
- View your account information
- Manage your personal settings
- Log out of the app

---

## 🛠️ Tech Stack

| Technology | Role |
|---|---|
| **Flutter** | Cross-platform UI framework (iOS & Android) |
| **Dart** | Programming language |
| **BLoC / Cubit** | State management |
| **Supabase** | Backend — Authentication, Database & Real-time |
| **shared_preferences** | Local storage for caching user preferences |

---

## 🏛️ Clean Architecture

DayTask is built following **Clean Architecture** principles. This means the codebase is thoughtfully separated into distinct layers, making it easy to maintain, test, and scale.

Think of it like a well-organized kitchen — every ingredient has its place, and the chef (business logic) never has to worry about where the plates come from.

```
lib/
├── features/
│   └── tasks/
│       ├── presentation/     # UI Layer
│       ├── business_logic/   # BLoC / Cubit Layer
│       ├── data/             # Repository & API Layer
│       └── models/           # Data Models
```

---

### 🖼️ Layer 1 — Presentation Layer
**What it does:** Everything the user *sees* and *touches*.

This layer contains all the **Screens** (pages) and **Widgets** (reusable UI components). It is completely "dumb" — it knows nothing about where data comes from. It simply displays what the Business Logic Layer tells it to.

```
presentation/
├── screens/
│   ├── home_screen.dart
│   ├── task_detail_screen.dart
│   ├── auth_screen.dart
│   └── profile_screen.dart
└── widgets/
    ├── task_card.dart
    └── custom_button.dart
```

---

### 🧠 Layer 2 — Business Logic Layer (BLoC / Cubit)
**What it does:** The brain of the app. Handles all decisions and state changes.

Using Flutter **BLoC (Business Logic Component)** and **Cubit** patterns, this layer:
- Receives **events** triggered by user interactions (e.g., "user tapped Add Task")
- Processes the logic
- Emits new **states** that the UI reacts to

This keeps the UI clean and testable because all logic lives here, not scattered across widget files.

```dart
// Example: TaskCubit emitting a loaded state
class TaskCubit extends Cubit<TaskState> {
  TaskCubit(this._taskRepository) : super(TaskInitial());

  final TaskRepository _taskRepository;

  Future<void> fetchTasks() async {
    emit(TaskLoading());
    final tasks = await _taskRepository.getAllTasks();
    emit(TaskLoaded(tasks));
  }
}
```

---

### 🗄️ Layer 3 — Data / Repository Layer
**What it does:** The bridge between the app and the outside world (Supabase API).

This layer is responsible for:
- Making API calls to **Supabase** to fetch, create, and update tasks
- Handling errors gracefully so the app never crashes unexpectedly
- Abstracting data sources so the rest of the app doesn't need to know *how* data is fetched

```dart
// Example: TaskRepository fetching tasks from Supabase
class TaskRepository {
  Future<List<Task>> getAllTasks() async {
    final response = await supabase
        .from('tasks')
        .select()
        .order('created_at', ascending: false);
    return response.map((json) => Task.fromJson(json)).toList();
  }
}
```

---

### 📦 Layer 4 — Models
**What it does:** Defines the shape of the data.

Models are simple Dart classes that represent your data structures — like a `Task` object with an `id`, `title`, `description`, and `isCompleted` flag. They include `fromJson` and `toJson` methods to seamlessly convert between Supabase's JSON responses and Dart objects.

```dart
class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    isCompleted: json['is_completed'],
  );
}
```

---

## 🔬 Behind the Scenes — Key Technical Highlights

### 🌗 Theme Caching with `shared_preferences`

DayTask supports both **Dark Mode** and **Light Mode**. But here's the problem many apps face: *the app forgets which theme you picked every time you reopen it*, forcing you to change it again and again.

**We solved this.** 🎉

We use the [`shared_preferences`](https://pub.dev/packages/shared_preferences) package to **cache the user's theme choice locally on the device**. Here's how the flow works:

```
User selects Dark Mode
        ↓
Theme preference saved to local cache (shared_preferences)
        ↓
App is closed and reopened
        ↓
On startup, app reads the cached theme preference
        ↓
Dark Mode is applied instantly ✅ — before the first frame even renders
```

This means **zero flicker**, **zero re-selection** — the app just remembers.

```dart
// Saving the theme preference
final prefs = await SharedPreferences.getInstance();
await prefs.setBool('isDarkMode', true);

// Reading the theme preference on startup
final prefs = await SharedPreferences.getInstance();
final isDarkMode = prefs.getBool('isDarkMode') ?? false;
```

---

### ⚡ Real-time Data with Supabase

DayTask uses **Supabase** as its entire backend — not just for login, but as a fully-featured database with **real-time capabilities**.

Here's what Supabase powers in the app:

| Feature | How Supabase Helps |
|---|---|
| 🔐 **Authentication** | Handles sign-up, login, and secure session management |
| 📋 **Task Storage** | Stores all tasks in a Postgres database in the cloud |
| ➕ **Create Tasks** | Inserts new task records instantly |
| 🔄 **Update Status** | Updates task completion status in real time |
| 🗑️ **Delete Tasks** | Removes tasks cleanly from the database |
| 📡 **Real-time Sync** | Listens to database changes and updates the UI automatically |

The real-time feature means that if you're ever using the app on multiple devices, your task list stays **in sync automatically** — no need to manually refresh.

```dart
// Subscribing to real-time task changes
supabase
  .from('tasks')
  .stream(primaryKey: ['id'])
  .listen((List<Map<String, dynamic>> data) {
    // UI updates automatically whenever tasks change in the database
    taskCubit.updateTaskList(data);
  });
```

---

## 🚀 Getting Started

Follow these steps to run DayTask locally on your machine.

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK
- A Supabase project ([create one free at supabase.com](https://supabase.com))

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/thisisouvik/daytask.git

# 2. Navigate to the project directory
cd daytask

# 3. Install all dependencies
flutter pub get

# 4. Set up your Supabase credentials
#    Create .env file and add your keys:
#    SUPABASE_URL = 'YOUR_SUPABASE_URL';
#    SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';

# 5. Run the app
flutter run
```

---

## 📁 Folder Structure

```
daytask/
├── lib/
│   ├── core/
│   │   ├── constants/        # App-wide constants (colors, strings, Supabase keys)
│   │   ├── theme/            # Light & Dark theme definitions
│   │   └── utils/            # Helper functions
│   ├── features/
│   │   ├── auth/
│   │   │   ├── presentation/ # Login & Signup screens
│   │   │   ├── business_logic/
│   │   │   └── data/
│   │   ├── tasks/
│   │   │   ├── presentation/ # Home, Task Detail screens & widgets
│   │   │   ├── business_logic/ # TaskCubit / TaskBloc
│   │   │   ├── data/         # TaskRepository, Supabase API calls
│   │   │   └── models/       # Task model
│   │   └── profile/
│   │       └── presentation/ # Profile screen
│   └── main.dart             # App entry point
├── assets/
│   └── images/               # App logo and other assets
├── pubspec.yaml              # Dependencies
└── README.md
```

---

<div align="center">

Made with ❤️ using Flutter

*DayTask — Because every task deserves to get done.*

</div>
