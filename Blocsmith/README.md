
```md
# 🛠️ Blocsmith

Blocsmith is an open-source command-line tool created by Siva Sankar, designed to enforce Modular Cubit/Bloc Architecture standards for Flutter applications. It helps developers generate clean and scalable module structures with minimal effort.

---

## 📦 Features

- Supports both **Cubit** and **Bloc** state management.
- Automatically creates feature-based folders:
```

lib/
modules/
your\_module/
view/
cubit/ or bloc/
services/

````
- Prompts for and installs required dependencies (e.g., `bloc`, `flutter_bloc`, `equatable`, etc.).
- Generates boilerplate code for Cubit/Bloc, States, Services, and Views.
- Follows best practices used at **Hum Studios**.
- MIT licensed and free to use in your own projects.

---

## 🚀 Installation & Setup

### 1. Clone or Download

```bash
curl -O https://github.com/siva-sankar-dev/flutter-automation/blob/main/Blocsmith/blocsmith.sh
```

### 2. Move to Your Flutter Project Root

```bash
mv blocsmith.sh your_flutter_project/
cd your_flutter_project/
```

### 3. Grant Execute Permission

```bash
chmod +x blocsmith.sh
```

---

## 🧪 Usage

Run the script from the root of your Flutter project:

```bash
./blocsmith.sh
```

You’ll be prompted to:

1. Enter the module name (in `snake_case`)
2. Choose state management: `Cubit` or `Bloc`
3. Select additional packages to install (e.g., `dio`, `sizer`, etc.)

The tool will then:

✅ Create a properly structured directory under `lib/modules/<your_module>`
✅ Generate the necessary Dart files
✅ Install any selected packages into `pubspec.yaml`
✅ Print a success message with your name and the date

---

## 📁 Example Output

For module `user_profile` with Cubit:

```
lib/
└── modules/
    └── user_profile/
        ├── view/
        │   └── user_profile_view.dart
        ├── cubit/
        │   ├── user_profile_cubit.dart
        │   └── user_profile_state.dart
        └── services/
            └── user_profile_service.dart
```

---

## 📜 License

This project is open source under the **MIT License**.
You’re free to share, modify, and use it in personal or commercial projects.

---

## 👨‍💻 Created by

**Siva Sankar**

Feel free to fork, improve, or contribute back to Blocsmith. ✨

---
