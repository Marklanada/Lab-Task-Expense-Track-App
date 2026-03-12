import 'package:flutter/material.dart';
import '../models/expense.dart';

// ExpenseProvider extends ChangeNotifier so it can notify
// widgets to rebuild whenever the expense list changes.
class ExpenseProvider extends ChangeNotifier {

  // Private list of expenses with 3 dummy items
  final List<Expense> _expenses = [
    Expense(id: '1', title: 'Groceries',       amount: 850.00),
    Expense(id: '2', title: 'Electricity Bill', amount: 1240.00),
    Expense(id: '3', title: 'Coffee',           amount: 150.00),
  ];

  // Returns an unmodifiable copy so the list
  // can only be changed through the provider methods
  List<Expense> get expenses => List.unmodifiable(_expenses);

  // Computes the total of all expense amounts
  double get total => _expenses.fold(0.0, (sum, e) => sum + e.amount);

  // Adds a new expense and notifies listeners to rebuild the UI
  void addExpense(String title, double amount) {
    _expenses.add(Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
    ));
    notifyListeners();
  }

  // Finds the expense by id, updates it, and notifies listeners
  void editExpense(String id, String title, double amount) {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index != -1) {
      _expenses[index].title  = title;
      _expenses[index].amount = amount;
      notifyListeners();
    }
  }

  // Removes the expense by id and notifies listeners
  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}