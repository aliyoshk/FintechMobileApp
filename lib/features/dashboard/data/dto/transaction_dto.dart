/// JSON-aware data transfer object for transactions.
/// Decoupled from the domain entity so a backend schema change
/// only touches this file and its mapper — not the rest of the app.
class TransactionDto {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime timestamp;

  const TransactionDto({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.timestamp,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    return TransactionDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}

