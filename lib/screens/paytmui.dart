import 'package:flutter/material.dart';

class PaytmUI extends StatelessWidget {
  final event;
  final int ticketCount;

  PaytmUI({required this.event, required this.ticketCount});

  @override
  Widget build(BuildContext context) {
    double totalAmount = event.price * ticketCount;

    return Scaffold(
      appBar: AppBar(title: Text("Paytm Payment")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Processing payment...'),
            SizedBox(height: 20),
            Text('Amount: ₹${totalAmount.toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: () {
                // Simulate payment success
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Payment Successful!"),
                    content: Text("Thank you for your purchase."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(
                              context); // Go back to the TicketBookingPage
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Confirm Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
