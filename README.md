# Procalax - Professional Calculator Application

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
![MIT License](https://img.shields.io/badge/license-MIT-blue)

Procalax is a comprehensive calculator application designed for professionals, students, and everyday users. Offering a suite of specialized calculation tools within an intuitive interface, it combines powerful functionality with modern design principles.

## 🌟 Key Features

### Core Functionalities
- **Basic Calculator**: Clean interface for arithmetic operations
- **Loan Calculator**: EMI, interest rate, and repayment schedule calculations
- **Unit Conversion**: Real-time conversion across multiple categories:
  - Length (meters, feet, inches, etc.)
  - Area (square meters, square feet, acres)
  - Weight (kg, lbs, ounces)
  - Volume (liters, gallons, cubic meters)
  - Data Storage (bytes, KB, MB, GB, TB)
  - Temperature (Celsius, Fahrenheit, Kelvin)
- **BMI Calculator**: Health metric calculation with categorization

### Enhanced User Experience
- 🕶️ **Dark/Light Theme**: Adaptive theming system
- 📚 **Calculation History**: Persistent storage with management options
- 🔢 **Precision Control**: Configurable decimal accuracy
- 📱 **Responsive Design**: Optimized for all screen sizes

## 🚧 Planned Features
- Real-time currency conversion (API integration)
- Scientific calculator functions
- Multi-language localization
- Customizable unit presets

## 🧰 Technical Implementation

### Technology Stack
- **Framework**: Flutter (cross-platform compatibility)
- **Language**: Dart (null-safe implementation)
- **State Management**: Provider pattern with setState
- **Persistence**: SharedPreferences for history storage
- **Architecture**: Modular component-based design

### Project Structure
```plaintext
lib/
├── main.dart                # Application entry point
├── screens/                 # UI View controllers
│   ├── home_screen.dart     # Main navigation hub
│   ├── calculator/          # Calculation modules
│   ├── converters/          # Unit conversion handlers
│   └── bmi/                 # Health calculation logic
├── widgets/                 # Reusable UI components
├── utils/                   # Helper functions & constants
│   ├── calculation.dart     # Core math operations
│   ├── converters/          # Conversion algorithms
│   └── theme.dart           # Theme configuration
└── models/                  # Data structures
```
## 🚀 Getting Started 
Prerequisites
- Flutter SDK (version 3.0 or higher)
- Dart SDK (version 2.17 or higher)
- IDE (VS Code or Android Studio recommended)

## 🧪 How to Run

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/procalax.git
   cd procalax
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the App**

   ```bash
   flutter run
   ```

## 📊 Roadmap

Feature | Status
---|---
Basic Calculator | ✅ Implemented
Unit Conversion | ✅ Implemented
Loan Calculator | ✅ Implemented
BMI Calculator | ✅ Implemented
Currency Conversion | ⏳ In Progress
Scientific Functions | ⏳ Planned
Localization | ⏳ Planned

## 🤝 Contribution Guidelines

Contributions are welcome through GitHub Issues and Pull Requests. Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**  
   `git checkout -b feature/your-feature`
3. **Commit your changes** with descriptive messages
4. **Push to your branch**  
   `git push origin feature/your-feature`
5. **Open a Pull Request**

## 📄 License

Distributed under the MIT License. See `LICENSE` for full terms.

## 📬 Contact

**Sai Hemanth** - Flutter Developer  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?logo=linkedin)](https://www.linkedin.com/in/thogaruchesti-hemanth/)
