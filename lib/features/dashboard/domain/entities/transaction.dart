/// Pure domain entity — no JSON, no framework imports.
/// Business rules like [isCredit] live here, not in DTOs or UI.
class Transaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime timestamp;

  const Transaction({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.timestamp,
  });

  bool get isCredit => amount >= 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Transaction && other.id == id && other.amount == amount);

  @override
  int get hashCode => Object.hash(id, amount);
}

