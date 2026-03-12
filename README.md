# Expense Tracker App

A simple expense tracking app built with Flutter that demonstrates the use of `MultiProvider`, `ChangeNotifier`, and `Consumer` for state management.

---

## Instructions Checklist

| Instruction | Status | Where It Is |
|---|---|---|
| MultiProvider | ✅ | `main.dart` |
| ChangeNotifier | ✅ | `expense_provider.dart` |
| Consumer | ✅ | `home_screen.dart` |
| ExpenseProvider | ✅ | `expense_provider.dart` |
| Simple list with data | ✅ | `expense_provider.dart` |
| Read / Write / Edit / Delete | ✅ | `expense_provider.dart` |

---

## About the App

I created a simple Expense Tracker app using Flutter. The app allows users to add, edit, and delete their expenses. It has a clean blue and white design inspired by modern fintech apps, with smart icons that automatically match the expense title.

---

## State Management

### MultiProvider
I used `MultiProvider` in `main.dart` to wrap the entire app. This makes the `ExpenseProvider` available to all screens without passing it manually. It also makes it easy to add more providers in the future.

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ExpenseProvider()),
  ],
  child: MaterialApp(...),
)
```

### ChangeNotifier
I created an `ExpenseProvider` class in `expense_provider.dart` that extends `ChangeNotifier`. This class holds the list of expenses and handles all the logic. Whenever the data changes, it calls `notifyListeners()` so the UI automatically updates without needing to reload the whole screen.

```dart
class ExpenseProvider extends ChangeNotifier {
  void addExpense(String title, double amount) {
    _expenses.add(...);
    notifyListeners(); // tells the UI to rebuild
  }
}
```

### Consumer
I used `Consumer<ExpenseProvider>` in `home_screen.dart` to listen to changes. It is used in two places — the total card and the expense list — so only those parts rebuild when data changes, not the whole screen.

```dart
Consumer<ExpenseProvider>(
  builder: (context, provider, _) {
    return Text('P${provider.total.toStringAsFixed(2)}');
  },
)
```

---

## ExpenseProvider

The `ExpenseProvider` contains a simple list of expenses and four functions:

```dart
// Simple list with dummy data
final List<Expense> _expenses = [
  Expense(id: '1', title: 'Groceries',       amount: 850.00),
  Expense(id: '2', title: 'Electricity Bill', amount: 1240.00),
  Expense(id: '3', title: 'Coffee',           amount: 150.00),
];
```

| Function | Type | Description |
|---|---|---|
| `get expenses` | Read | Returns the full list of expenses |
| `addExpense()` | Write | Adds a new expense to the list |
| `editExpense()` | Edit | Updates the title and amount of an existing expense |
| `deleteExpense()` | Delete | Removes an expense from the list by ID |

---

## Features

- View a list of expenses with title, amount, and smart icons
- Smart icons automatically match the expense title keyword (e.g. Groceries = basket icon, Coffee = coffee icon)
- Unknown expense titles show a ₱ peso symbol as the icon
- See the total amount of all expenses at the top
- Add a new expense with a title and amount
- Edit an existing expense
- Delete an expense with a confirmation dialog
- Validation — title cannot be empty, amount must be a valid number greater than 0
- Empty state message when there are no expenses

---

## Smart Icon System

The app automatically assigns an icon and color based on the expense title:

| Keyword | Icon | Color |
|---|---|---|
| Groceries / Market | Shopping Basket | Green |
| Electricity / Power | Bolt | Yellow |
| Coffee / Cafe | Coffee | Brown |
| Food / Meal / Resto | Restaurant | Green |
| Transport / Bus / Grab | Bus | Blue |
| Rent / House / Home | Home | Purple |
| Internet / WiFi / Phone | WiFi / Phone | Cyan |
| Medical / Hospital | Hospital | Red |
| School / Book | School | Orange |
| Gym / Fitness | Fitness | Teal |
| Travel / Flight | Flight | Indigo |
| Shopping / Clothes | Shopping Bag | Pink |
| Others | ₱ Peso Symbol | Blue |

---

## Design

The app uses the **"Calm Financial" blue and white** color palette inspired by modern fintech apps:

| Color | Hex | Used For |
|---|---|---|
| Royal Blue | `#1155CC` | AppBar, FAB, save button |
| Lighter Blue | `#2979FF` | Gradient, edit icon, labels |
| Light Grey-Blue | `#EEF2F7` | App background |
| White | `#FFFFFF` | Cards, input fields |
| Teal Green | `#00BFA5` | Expense amounts |
| Vivid Red | `#FF1744` | Delete button and icon |
| Dark Navy | `#0D1B3E` | Titles and text |

---

## Folder Structure

```
lib/
├── main.dart                   # Entry point, MultiProvider setup
├── models/
│   └── expense.dart            # Expense data model
├── providers/
│   └── expense_provider.dart   # ChangeNotifier, list, CRUD functions
└── screens/
    ├── home_screen.dart        # Expense list, Consumer, smart icons
    └── add_expense_screen.dart # Add and Edit screen
```

---

## How to Run

1. Make sure Flutter is installed on your machine.
2. Run `flutter pub get` to install the `provider` package.
3. Run `flutter run` to launch the app.

### pubspec.yaml dependency
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
```
