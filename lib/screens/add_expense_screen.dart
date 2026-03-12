import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  final String? expenseId;
  final String? initialTitle;
  final double? initialAmount;

  const AddExpenseScreen({
    super.key,
    this.expenseId,
    this.initialTitle,
    this.initialAmount,
  });

  bool get isEditMode => expenseId != null;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  String? _titleError;
  String? _amountError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _amountController = TextEditingController(
      text: widget.initialAmount != null
          ? widget.initialAmount!.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    final title  = _titleController.text.trim();
    final rawAmt = _amountController.text.trim();

    String? titleErr;
    String? amountErr;

    if (title.isEmpty) titleErr = 'Title cannot be empty.';

    final parsed = double.tryParse(rawAmt);
    if (rawAmt.isEmpty) {
      amountErr = 'Amount cannot be empty.';
    } else if (parsed == null) {
      amountErr = 'Enter a valid number.';
    } else if (parsed <= 0) {
      amountErr = 'Amount must be greater than 0.';
    }

    if (titleErr != null || amountErr != null) {
      setState(() {
        _titleError  = titleErr;
        _amountError = amountErr;
      });
      return;
    }

    final provider = context.read<ExpenseProvider>();

    if (widget.isEditMode) {
      provider.editExpense(widget.expenseId!, title, parsed!);
    } else {
      provider.addExpense(title, parsed!);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.isEditMode ? 'Updated: $title' : 'Added: $title'),
        backgroundColor: Colors.indigo,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.isEditMode ? 'Edit Expense' : 'Add Expense',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),

            // Title field
            TextField(
              controller: _titleController,
              autofocus: !widget.isEditMode,
              decoration: InputDecoration(
                labelText: 'Expense Title',
                hintText: 'e.g. Coffee, Groceries, Rent...',
                prefixIcon: const Icon(Icons.label_outline),
                errorText: _titleError,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (_) {
                if (_titleError != null) setState(() => _titleError = null);
              },
            ),

            const SizedBox(height: 16),

            // Amount field
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: '0.00',
                prefixText: 'P  ',
                errorText: _amountError,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (_) {
                if (_amountError != null) setState(() => _amountError = null);
              },
            ),

            const SizedBox(height: 28),

            // Save button
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_rounded),
              label: Text(
                widget.isEditMode ? 'Save Changes' : 'Save Expense',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 10),

            // Cancel button
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.indigo,
                side: const BorderSide(color: Colors.indigo),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Cancel', style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}