import 'package:flutter/material.dart';
import 'paytmui.dart';
import 'stripeui.dart';
import 'razorpaylikeui.dart'; // Removed Razorpay Flutter import

class Event {
  final String name;
  final String date;
  final double price;
  final String description;
  final String image;

  Event({
    required this.name,
    required this.date,
    required this.price,
    required this.description,
    required this.image,
  });
}

class TicketBookingPage extends StatefulWidget {
  final Event event;

  const TicketBookingPage({required this.event, Key? key}) : super(key: key);

  @override
  State<TicketBookingPage> createState() => _TicketBookingPageState();
}

class _TicketBookingPageState extends State<TicketBookingPage> {
  int _ticketCount = 1;
  String _paymentMethod = 'Razorpay';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _startPayment() {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    if (_paymentMethod == 'Razorpay') {
      // Use Razorpay-like UI for Razorpay option
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              RazorpayLikeUI(event: widget.event, ticketCount: _ticketCount),
        ),
      );
    } else if (_paymentMethod == 'Paytm') {
      // Navigate to Paytm UI
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PaytmUI(event: widget.event, ticketCount: _ticketCount),
        ),
      );
    } else if (_paymentMethod == 'Stripe') {
      // Navigate to Stripe UI
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              StripeUI(event: widget.event, ticketCount: _ticketCount),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.event.price * _ticketCount;

    return Scaffold(
      appBar: AppBar(title: Text('Book Tickets')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.event.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Date: ${widget.event.date}', style: TextStyle(fontSize: 18)),
            Text('Price: ₹${widget.event.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Number of Tickets:', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _ticketCount > 1
                      ? () {
                          setState(() {
                            _ticketCount--;
                          });
                        }
                      : null,
                ),
                Text('$_ticketCount', style: TextStyle(fontSize: 24)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _ticketCount++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Text('Select Payment Method:', style: TextStyle(fontSize: 18)),
            Column(
              children: [
                // Grouping Razorpay, Paytm, Stripe together
                Row(
                  children: [
                    Radio<String>(
                      value: 'Razorpay',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                    Text("Razorpay"),
                    Radio<String>(
                      value: 'Paytm',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                    Text("Paytm"),
                    Radio<String>(
                      value: 'Stripe',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                    Text("Stripe"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _startPayment,
              child: Text('Pay ₹${totalAmount.toStringAsFixed(2)}'),
            ),
            if (_isLoading)
              Center(
                  child: CircularProgressIndicator()), // Show loading indicator
          ],
        ),
      ),
    );
  }
}
