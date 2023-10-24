import 'package:expense_tracker/expense_model.dart';
import 'package:expense_tracker/item.dart';
import 'package:expense_tracker/fund_condition_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List options = ["expense", "income"];
List<ExpenseModel> expenses = [];

class _HomePageState extends State<HomePage> {
  final itemController = TextEditingController();
  final amountController = TextEditingController();
  int amount = 0;
  final dateController = TextEditingController();
  int totalMoney = 0;
  int spentMoney = 0;
  int income = 0;
  DateTime? pickedDate;
  String currentOption = options[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        height: 67,
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 400,
                  child: AlertDialog(
                    title: const Padding(
                      padding: EdgeInsets.only(left: 1.6),
                      child: Text("ADD TRANSICTION"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          amount = int.parse(amountController.text);
                          // adding a new item
                          final expense = ExpenseModel(
                            item: itemController.text,
                            amount: amount,
                            isIncome: currentOption == "income" ? true : false,
                            date: pickedDate!,
                          );
                          expenses.add(expense);
                          if (expense.isIncome) {
                            income += expense.amount;
                            totalMoney += expense.amount;
                            setState(() {});
                          } else if (!expense.isIncome) {
                            spentMoney += expense.amount;
                            totalMoney -= expense.amount;
                            setState(() {});
                          }

                          itemController.clear();
                          amountController.clear();
                          dateController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "ADD",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "CANCEL",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                    content: SizedBox(
                      height: 340,
                      width: 400,
                      child: Column(
                        children: [
                          TextField(
                            controller: itemController,
                            decoration: const InputDecoration(
                              hintText: "Enter the Item",
                              hintStyle: TextStyle(
                                color: Colors.blueGrey,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "Enter the Amount",
                              hintStyle: TextStyle(
                                color: Colors.blueGrey,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              onTap: () async {
                                // user can pick date
                                pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                String date =
                                    DateFormat.yMMMMd().format(pickedDate!);
                                dateController.text = date;
                                setState(() {});
                              },
                              controller: dateController,
                              decoration: const InputDecoration(
                                labelText: "DATE",
                                hintStyle: TextStyle(
                                  color: Colors.blueGrey,
                                ),
                                filled: true,
                                prefixIcon: Icon(Icons.calendar_today),
                                prefixIconColor: Colors.blue,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(height: 15),
                          RadioMenuButton(
                            value: options[0],
                            groupValue: currentOption,
                            onChanged: (expense) {
                              currentOption = expense.toString();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                "Expense",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.4,
                                ),
                              ),
                            ),
                          ),
                          RadioMenuButton(
                            style: ButtonStyle(
                              iconSize: MaterialStateProperty.all(20),
                            ),
                            value: options[1],
                            groupValue: currentOption,
                            onChanged: (income) {
                              currentOption = income.toString();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                "Income",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add, size: 26),
        ),
      ),
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        centerTitle: true,
        backgroundColor: Colors.red.shade500,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FundCondition(
                    type: "DEPOSIT",
                    amount: "$totalMoney",
                    icon: "blue",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: FundCondition(
                    type: "EXPENSE",
                    amount: "$spentMoney",
                    icon: "orange",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 8),
                  child: FundCondition(
                    type: "INCOME",
                    amount: "$income",
                    icon: "grey",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Confirm to Delete the Item ?",
                              style: TextStyle(
                                fontSize: 19.0,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "CANCEL",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  final myExpense = expenses[index];
                                  if (myExpense.isIncome) {
                                    income -= myExpense.amount;
                                    totalMoney -= myExpense.amount;
                                    setState(() {});
                                  } else if (!myExpense.isIncome) {
                                    spentMoney -= myExpense.amount;
                                    totalMoney += myExpense.amount;
                                    setState(() {});
                                  }
                                  expenses.remove(myExpense);
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "DELETE",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Item(
                      expense: ExpenseModel(
                        item: expenses[index].item,
                        amount: expenses[index].amount,
                        isIncome: expenses[index].isIncome,
                        date: expenses[index].date,
                      ),
                      onDelete: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
