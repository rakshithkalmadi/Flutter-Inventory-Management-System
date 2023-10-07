import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'databasehelper.dart';
class InvoicePage extends StatefulWidget {
  final SharedPreferences prefs;

  InvoicePage({required this.prefs});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {

  Future<List<String>> fetchItemsFromDatabase(String pattern) async {
    final databaseHelper = DatabaseHelper(); // Create an instance of your DatabaseHelper

    final databaseRecords = await databaseHelper.getAllRecords(); // Call your database query method




    // Extract item names in the format "brand-design-size" from the database records
    final itemNames = databaseRecords.map((record) {
      final brand = record['brand'] as String;
      final design = record['design'] as String;
      final size = record['size'] as String;
      return '$brand-$design-$size';
    }).toList();

    // Filter item names that match the input pattern
    final filteredItems = itemNames.where((itemName) {
      return itemName.toLowerCase().contains(pattern.toLowerCase());
    }).toList();

    return filteredItems;
  }


  @override
  Widget build(BuildContext context) {
    // Retrieve values from SharedPreferences
    final firmName = widget.prefs.getString('firmName') ?? '';
    final address = widget.prefs.getString('address') ?? '';
    final email = widget.prefs.getString('email') ?? '';
    final phoneNumber = widget.prefs.getString('phoneNumber') ?? '';

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    List<TextEditingController> itemControllers = List.generate(10, (index) => TextEditingController());


    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            children: [
              // Invoice Container
              Container(
                height: screenHeight,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: screenWidth,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Text(
                              firmName,
                               textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0), // Adjust spacing as needed
                             Text(
                              address,
                               textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                             Text(
                              email,
                               textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                             Text(
                              phoneNumber,
                               textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      width: screenWidth, // Set the width of the parent container
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(4), // 40% width for Item
                          1: FlexColumnWidth(2), // 20% width for Qty
                          2: FlexColumnWidth(2), // 20% width for Rate
                          3: FlexColumnWidth(2), // 20% width for Amount
                        },
                        children: [
                          // First Row (Item)
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.grey[300], // Optional background color
                                  child: const Text(
                                    'Item',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.grey[300], // Optional background color
                                  child: const Text(
                                    'Quantity',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.grey[300], // Optional background color
                                  child: const Text(
                                    'Rate',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.grey[300], // Optional background color
                                  child: const Text(
                                    'Amount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Add 8 more empty rows for a total of 10 rows
                          for (int i = 0; i < 10; i++)
                            TableRow(
                              children: [
                                TableCell(
                                  child: TypeAheadField(

                                    textFieldConfiguration: TextFieldConfiguration(
                                      controller: itemControllers[i] ,
                                      decoration: InputDecoration(
                                        labelText: 'Item',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    suggestionsCallback: (pattern) async {
                                      // Fetch item suggestions based on the input pattern
                                      return await fetchItemsFromDatabase(pattern);
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion),
                                      );
                                    },
                                    onSuggestionSelected: (suggestion) {
                                      setState(() {
                                        itemControllers[i].text=suggestion;
                                        print(suggestion);
                                      });

                                      // Handle the selected item for the 'Item' column
                                    },
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text(''), // Empty cell
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text(''), // Empty cell
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text(''), // Empty cell
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle the action for the first button
                    },
                    child: const Text('Button 1'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle the action for the second button
                    },
                    child: const Text('Button 2'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
