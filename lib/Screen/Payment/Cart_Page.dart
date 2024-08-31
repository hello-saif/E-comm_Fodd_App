import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:foodiapp/BottomNavBar.dart';
import 'Bkash.dart';

class CheckoutPage extends StatefulWidget {
  final double totalAmount;

  const CheckoutPage({super.key, required this.totalAmount});

  @override
  State<CheckoutPage> createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  String _selectedAddress = 'Home';
  String _selectedPaymentMethod = 'Nagad';

  void _handlePayment() {
    if (_selectedPaymentMethod == 'bkash') {
      // Initiating bkash payment process
      if (kDebugMode) {
        print('Initiating bkash payment...');
      }

      // Navigate to the bkash payment screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BkashPaymentScreen(
            title: 'bKash Payment',
            amount: widget.totalAmount, // Pass the total amount here
          ),
        ),
      );


    } else {
      // Handle other payment methods or show a message
      if (kDebugMode) {
        print('Other payment methods are not yet implemented.');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()),
                (route) => false);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AddressCard(
                      title: 'Home',
                      address:
                          '34 North Sulphur Springs Dr.\nAlexandria, VA 22304',
                      icon: Icons.location_on,
                      isSelected: _selectedAddress == 'Home',
                      onTap: () {
                        setState(() {
                          _selectedAddress = 'Home';
                        });
                      },
                    ),
                    AddressCard(
                      title: 'Office',
                      address:
                          '34 North Sulphur Springs Dr.\nAlexandria, VA 22304',
                      icon: Icons.business,
                      isSelected: _selectedAddress == 'Office',
                      onTap: () {
                        setState(() {
                          _selectedAddress = 'Office';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Divider(thickness: 5),
                    const SizedBox(height: 16),
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    PaymentMethodCard(
                      title: 'Nagad',
                      iconUrl:
                          'https://tfe-bd.sgp1.digitaloceanspaces.com/posts/53537/nagad-logo.jpg',
                      isSelected: _selectedPaymentMethod == 'Nagad',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Nagad';
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    PaymentMethodCard(
                      title: 'Rocket',
                      iconUrl:
                          'https://uniquepaybd.com/assets/uploads/userda39a3ee5e6b4b0d3255bfef95601890afd80709/5932889762496fc0e8aacd507f50aba0.png',
                      isSelected: _selectedPaymentMethod == 'Rocket',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'Rocket';
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    PaymentMethodCard(
                      title: 'bkash',
                      iconUrl:
                          'https://downloadr2.apkmirror.com/wp-content/uploads/2020/03/5e6ab3fa58a91.png',
                      isSelected: _selectedPaymentMethod == 'bkash',
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = 'bkash';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${widget.totalAmount.toStringAsFixed(2)}৳',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: _handlePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressCard({
    super.key,
    required this.title,
    required this.address,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 5 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? Colors.orange : Colors.grey,
            width: 2,
          ),
        ),
        child: ListTile(
          leading: Icon(icon, color: isSelected ? Colors.orange : Colors.grey),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(address),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.orange)
              : null,
        ),
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final String title;
  final String iconUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.title,
    required this.iconUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 5 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? Colors.orange : Colors.grey,
            width: 2,
          ),
        ),
        child: ListTile(
          leading: Image.network(iconUrl, width: 40, height: 40),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.orange)
              : null,
        ),
      ),
    );
  }
}
