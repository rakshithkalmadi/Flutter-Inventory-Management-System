import 'package:flutter/material.dart';
import 'sharedprefshelper.dart';
import 'purchaseorder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  // Homepage that will display the options of the functionalities offered by the application
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87F892),
      appBar: AppBar(
        title: const Text('HOME'),
        backgroundColor: const Color(0xFF48CC56),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Text(
                'HELLO',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('Reset Password'),
              leading: const Icon(Icons.key),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController newPasswordController =
                        TextEditingController();
                    return AlertDialog(
                      title: const Text('Reset Password'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: newPasswordController,
                            decoration: const InputDecoration(
                                labelText: 'New Password'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Close the current dialog box
                            Navigator.of(context).pop();
                            String newPassword = newPasswordController.text;
                            await SharedPreferencesHelper.updatePassword(
                                newPassword);
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password changed'),
                              ),
                            );
                          },
                          child: const Text('Reset'),
                        ),
                      ],
                    );
                  },
                ); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        // List of functionalities
        child: Column(
          children: [
            buildCard(
              title: 'Purchase Order',
              imageAsset: 'assets/buying.jpg',
              onTap: () {
                // Navigate to the Purchase order page
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const RecordListPage())
                );
              },
              height: 81,
              width: 133,
            ),
            buildCard(
                title: 'Inventory Details',
                imageAsset: 'assets/stock.jpg', // Replace with your image asset
                onTap: () {
                  // Add your action for the Stock Details card here
                },
                height: 99,
                width: 148),
            buildCard(
              title: 'Sales Order',
              imageAsset: 'assets/selling.jpg', // Replace with your image asset
              onTap: () {
                // Add your action for the Purchase Order card here
              },
              height: 107,
              width: 118,
            ),
            buildCard(
              title: 'Warehouse Details',
              imageAsset:
                  'assets/warehouse.jpg', // Replace with your image asset
              onTap: () {
                // Add your action for the Warehouse Details card here
              },
              height: 97,
              width: 163,
            ),
          ],
        ),
      ),
    );
  }

  //Widget that build the custom designed cards
  Widget buildCard({
    required String title,
    required String imageAsset,
    required VoidCallback onTap,
    required double? height,
    required double? width,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: const Color(0xFF55C47B),
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imageAsset,
                  height: height,
                  width: width,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
