import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_bkash/flutter_bkash.dart';

enum PaymentType { payWithAgreement, payWithoutAgreement, createAgreement }

class BkashPaymentScreen extends StatefulWidget {
  final String title;
  final double amount;

  const BkashPaymentScreen({
    Key? key,
    required this.title,
    required this.amount,
  }) : super(key: key);

  @override
  BkashPaymentScreenState createState() => BkashPaymentScreenState();
}

class BkashPaymentScreenState extends State<BkashPaymentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _agreementIdController = TextEditingController();

  bool isLoading = false;
  PaymentType _paymentType = PaymentType.payWithoutAgreement;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.amount.toStringAsFixed(2); // Set the total amount in the text field
  }

  @override
  void dispose() {
    _amountController.dispose();
    _agreementIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: [
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            )
          else
            SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_paymentType != PaymentType.createAgreement) ...[
                    const Text(
                      'Amount :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        hintText: "Enter amount",
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.pink, width: 2.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 20),
                  ],
                  const Divider(),
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        backgroundColor: Colors.pink,
                      ),
                      child: const Text(
                        "Checkout",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => _onCheckoutButtonPressed(context),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onCheckoutButtonPressed(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final flutterBkash = FlutterBkash();

    try {
      FocusManager.instance.primaryFocus?.unfocus();

      if (_paymentType == PaymentType.createAgreement) {
        final result = await flutterBkash.createAgreement(context: context);
        dev.log(result.toString());
        _showSnackbar("(Success) AgreementId: ${result.agreementId}");
      } else if (_paymentType == PaymentType.payWithoutAgreement) {
        final amount = _amountController.text.trim();
        if (amount.isEmpty) {
          _showSnackbar(
              "Amount is empty. Without amount you can't pay. Try again");
        } else {
          final result = await flutterBkash.pay(
            context: context,
            amount: double.parse(amount),
            merchantInvoiceNumber: "tranId",
          );
          dev.log(result.toString());
          _showSnackbar("(Success) tranId: ${result.trxId}");
        }
      } else if (_paymentType == PaymentType.payWithAgreement) {
        final amount = _amountController.text.trim();
        final agreementId = _agreementIdController.text.trim();
        if (amount.isEmpty || agreementId.isEmpty) {
          _showSnackbar("Amount or AgreementId is empty. Please try again.");
        } else {
          final result = await flutterBkash.payWithAgreement(
            context: context,
            amount: double.parse(amount),
            agreementId: agreementId,
            marchentInvoiceNumber: "merchantInvoiceNumber",
          );
          dev.log(result.toString());
          _showSnackbar("(Success) tranId: ${result.trxId}");
        }
      }
    } on BkashFailure catch (e, st) {
      dev.log(e.message, error: e, stackTrace: st);
      _showSnackbar(e.message);
    } catch (e, st) {
      dev.log("Something went wrong", error: e, stackTrace: st);
      _showSnackbar("Something went wrong");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
