# 🔥 Chain Keeper

A beautiful Flutter habit tracking app that motivates users through creative, animated visualizations. Each habit grows a unique visual representation as you maintain your daily streak.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## ✨ Features

- **🎨 3 Unique Animated Visualizations**
  - **Garden Theme** 🌸: A flower that grows, blooms, and attracts butterflies
  - **Bridge Theme** 🌉: A bridge that extends with support pillars and decorative arches
  - **Constellation Theme** ✨: Stars that appear and connect, with shooting stars and moon phases

- **🔥 Streak Tracking**: Monitor current and longest streaks for each habit
- **📊 Detailed Statistics**: Success rates, total completions, and completion history
- **🔔 Daily Reminders**: Customizable notification times for each habit
- **💾 Local Storage**: All data persists locally using Shared Preferences
- **🌙 Beautiful Dark UI**: Modern, clean interface with smooth animations
- **📱 Responsive Design**: Works seamlessly on different screen sizes

## 📱 Screenshots
<img width="1344" height="2992" alt="screenshot" src="https://github.com/user-attachments/assets/6424d052-015f-4eaa-b327-60c5e013a4fe" style="width: 336px; height: auto;" />


<img width="336" height="748" alt="screenshot" src="https://github.com/user-attachments/assets/1717a4a7-305d-403c-8a27-e44be451a72a" style="width: 336px; height: auto;" />

<img width="336" height="748" alt="screenshot" src="https://github.com/user-attachments/assets/f1ddbfa0-e001-4aa5-a524-9fd756b070b1" style="width: 336px; height: auto;" />

<img width="336" height="748" alt="screenshot" src="https://github.com/user-attachments/assets/2093aacb-3a7f-4d13-84f7-793d97964876" style="width: 336px; height: auto;" />

<img width="336" height="748" alt="screenshot" src="https://github.com/user-attachments/assets/597a500c-62a6-4f7e-81de-bd297f5d5e66" style="width: 336px; height: auto;" />

> Add screenshots here to showcase your app's UI

## 🎯 Visualizations in Detail

### 🌸 Garden Theme
- **Day 1-3**: Small stem starts growing
- **Day 4-7**: Stem grows taller, leaves appear
- **Day 8-14**: Flower blooms with petals
- **Day 15+**: Fully mature, vibrant flower
- **Day 30+**: Butterflies appear with animation!

### 🌉 Bridge Theme
- **Each day**: New plank extends the bridge
- **Every 7 days**: Support pillar appears
- **Day 20+**: Birds fly in the sky
- **Day 30+**: Golden decorative arch crowns the bridge

### ✨ Constellation Theme
- **Each day**: New star appears in the night sky
- **Day 7+**: Stars connect with lines forming patterns
- **Day 10+**: Moon appears in the corner
- **Day 15+**: Shooting stars cross the sky
- **Day 30+**: Pulsating glow effect on constellation

## 🛠️ Technologies & Packages

| Technology | Purpose |
|------------|---------|
| Flutter | Cross-platform mobile framework |
| Dart | Programming language |
| Provider | State management |
| Shared Preferences | Local data persistence |
| Flutter Local Notifications | Daily habit reminders |
| Timezone | Notification scheduling |
| Intl | Date formatting (French locale) |
| CustomPaint | Custom graphics and animations |

## 📦 Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   └── habit.dart                     # Habit data model
├── services/
│   ├── database_service.dart          # Local storage operations
│   └── notification_service.dart      # Notification handling
├── providers/
│   └── habit_provider.dart            # State management
├── screens/
│   ├── home_screen.dart               # Main habits list
│   ├── add_habit_screen.dart          # Create new habit
│   └── habit_detail_screen.dart       # Habit statistics & details
└── widgets/
    ├── habit_card.dart                # Habit list item
    └── visualizations/
        ├── garden_visual.dart         # Garden animation
        ├── bridge_visual.dart         # Bridge animation
        └── constellation_visual.dart  # Constellation animation
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.0 or higher)
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/mohdop/chain_keeper.git
cd chain_keeper
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

## 🎓 What I Learned Building This

- **Custom Graphics with CustomPaint**: Created three unique, animated visualizations from scratch using Canvas API
- **Advanced Animations**: Implemented smooth growth animations, twinkling effects, and complex visual transitions
- **State Management**: Used Provider pattern for efficient state updates across the app
- **Local Persistence**: Implemented JSON serialization/deserialization for complex data structures
- **Notification System**: Configured timezone-aware daily reminders with proper Android permissions
- **UI/UX Design**: Created an engaging dark-themed interface with consistent design patterns
- **Date/Time Handling**: Managed streak calculations and date comparisons accurately
- **Widget Composition**: Built reusable, maintainable widget architecture

## 🔧 Technical Highlights

### Custom Painting
All three visualizations are drawn using Flutter's `CustomPaint` widget with hand-coded painters. Each painter calculates positions, colors, and animations based on the user's streak count.

```dart
class GardenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Custom drawing logic for flower growth
    _drawStem(canvas, centerX, centerY, stemHeight);
    _drawLeaves(canvas, x, y, stemHeight);
    _drawFlower(canvas, x, y, streak);
  }
}
```

### Smooth Animations
Used `AnimationController` with custom curves for organic-feeling growth animations:

```dart
_growAnimation = CurvedAnimation(
  parent: _controller,
  curve: Curves.easeOutBack,
);
```

### Streak Logic
Implemented robust streak tracking with edge case handling:
- Handles same-day completions
- Calculates day differences accurately
- Manages streak breaks and continuations
- Tracks longest streaks

## 🐛 Known Issues

- Notifications may be delayed on devices with aggressive battery optimization
- Exact alarm permissions required on Android 12+

## 🚀 Future Enhancements

- [ ] Add calendar view for visual completion history
- [ ] Implement data export/import functionality
- [ ] Add habit categories and filtering
- [ ] Create achievement/badge system
- [ ] Add cloud sync with Firebase
- [ ] Support light theme
- [ ] Add more visualization themes
- [ ] Implement habit editing
- [ ] Add weekly/monthly statistics graphs
- [ ] Support for iOS platform

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Author

**Mohamed**
- GitHub: [@mohdop](https://github.com/mohdop)

## 🙏 Acknowledgments

- Built as a portfolio project to demonstrate Flutter development skills
- Inspired by habit tracking apps like Habitica and Streaks
- Designed to showcase custom graphics, animations, and state management

---

⭐ If you found this project interesting, please consider giving it a star!

**Built with ❤️ using Flutter**
