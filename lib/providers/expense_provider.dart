import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  final List<Expense> _expenses = [
    Expense(id: '1', title: 'Groceries',        amount: 850.00),
    Expense(id: '2', title: 'Electricity Bill',  amount: 1240.00),
    Expense(id: '3', title: 'Coffee',            amount: 150.00),
  ];

  List<Expense> get expenses => List.unmodifiable(_expenses);

  double get total => _expenses.fold(0.0, (sum, e) => sum + e.amount);

  void addExpense(String title, double amount) {
    _expenses.add(Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
    ));
    notifyListeners();
  }

  void editExpense(String id, String title, double amount) {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index != -1) {
      _expenses[index].title  = title;
      _expenses[index].amount = amount;
      notifyListeners();
    }
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}