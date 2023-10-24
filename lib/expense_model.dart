// ignore_for_file: public_member_api_docs, sort_constructors_first
class ExpenseModel {
  String item;
  int amount;
  bool isIncome;
  DateTime date;
  ExpenseModel({
    required this.item,
    required this.amount,
    required this.isIncome,
    required this.date,
  });
}
