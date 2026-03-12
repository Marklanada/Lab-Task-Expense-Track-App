import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';

// ── Color Palette (from image) ───────────────────
const Color kBlue       = Color(0xFF1155CC); // Bright Royal Blue — header, FAB
const Color kBlueMid    = Color(0xFF2979FF); // Lighter Blue — gradient, accents
const Color kBgGrey     = Color(0xFFEEF2F7); // Light Grey-Blue — background
const Color kCard       = Color(0xFFFFFFFF); // White — cards
const Color kGreen      = Color(0xFF00BFA5); // Teal Green — positive amounts
const Color kRed        = Color(0xFFFF1744); // Vivid Red — delete, negative
const Color kOrange     = Color(0xFFFF6D00); // Orange — icon accent
const Color kTextDark   = Color(0xFF0D1B3E); // Very Dark Navy — titles
const Color kTextGrey   = Color(0xFF8A94A6); // Muted Grey — subtitles, hints

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _confirmDelete(
      BuildContext context, String id, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kCard,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Expense',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: kTextDark)),
        content: Text('Remove "$title"?',
            style: const TextStyle(color: kTextGrey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: kBlueMid)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kRed,
              foregroundColor: kCard,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<ExpenseProvider>().deleteExpense(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted: $title'),
          backgroundColor: kRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _openAddScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
    );
  }

  void _openEditScreen(
      BuildContext context, String id, String title, double amount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddExpenseScreen(
          expenseId: id,
          initialTitle: title,
          initialAmount: amount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGrey,
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: kCard, fontSize: 20),
        ),
        backgroundColor: kBlue,
        foregroundColor: kCard,
        elevation: 0,
        surfaceTintColor: kBlue,
      ),
      body: Column(
        children: [
          // ── Total Card ──────────────────────────
          Consumer<ExpenseProvider>(
            builder: (context, provider, _) => Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kBlue, kBlueMid],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: kBlue.withOpacity(0.45),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Expenses',
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'P${provider.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: kCard,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${provider.expenses.length} item(s)',
                      style: const TextStyle(
                          color: kCard,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expense List ────────────────────────
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, provider, _) {
                final expenses = provider.expenses;

                if (expenses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: kBlue.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.receipt_long,
                              size: 56, color: kBlue),
                        ),
                        const SizedBox(height: 16),
                        const Text('No expenses yet.',
                            style: TextStyle(
                                color: kTextDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        const Text('Tap + to add one.',
                            style: TextStyle(
                                color: kTextGrey, fontSize: 13)),
                      ],
                    ),
                  );
                }

                // icon colors cycling like the app in image
                final List<Color> iconColors = [
                  kOrange,
                  kGreen,
                  kBlue,
                  kRed,
                  const Color(0xFF9C27B0),
                  const Color(0xFF00ACC1),
                ];

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: expenses.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    final iconColor =
                        iconColors[index % iconColors.length];
                    return Card(
                      color: kCard,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: iconColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text('P',
                              style: TextStyle(
                                  color: iconColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17)),
                        ),
                        title: Text(expense.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: kTextDark,
                                fontSize: 15)),
                        subtitle: Text(
                          'P${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: kGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  color: kBlueMid, size: 22),
                              tooltip: 'Edit',
                              onPressed: () => _openEditScreen(
                                  context,
                                  expense.id,
                                  expense.title,
                                  expense.amount),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: kRed, size: 22),
                              tooltip: 'Delete',
                              onPressed: () => _confirmDelete(
                                  context, expense.id, expense.title),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddScreen(context),
        backgroundColor: kBlue,
        foregroundColor: kCard,
        elevation: 6,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}