import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'databasehelper.dart';
class InvoicePage extends StatefulWidget {
  final SharedPreferences prefs;

  const InvoicePage({super.key, required this.prefs});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  List<int> idList = List<int>.filled(10, -1);
  double totalAmt=0;
  List<FocusNode> qtyFocusNodes = List.generate(10, (index) => FocusNode());


  List<TextEditingController> itemControllers = List.generate(10, (index) => TextEditingController());
  List<TextEditingController> qtyControllers = List.generate(10, (index) {
    final controller = TextEditingController();
    controller.text = '0';
    return controller;
  });

  List<TextEditingController> rateControllers = List.generate(10, (index) {
    final controller = TextEditingController();
    controller.text = '0';
    return controller;
  });

  List<TextEditingController> amtControllers = List.generate(10, (index) {
    final controller = TextEditingController();
    controller.text = '0';
    return controller;
  });

  //Function to update the amount based on the quantity and rate of the product
  void updateAmount(int index) {
    int qty = int.tryParse(qtyControllers[index].text) ?? 0;
    double rate = double.tryParse(rateControllers[index].text) ?? 0.0;
    double amount = qty * rate;
    amtControllers[index].text = amount.toString();
  }

  //Function to get the selling price of the product based on item name
  Future<void> fetchSellingPrice(int itemId, TextEditingController controller) async {
    final databaseHelper = DatabaseHelper();
    double sellingPrice = await databaseHelper.getSellingPriceById(itemId);
    // Set the selling price in the TextFormField
    controller.text = sellingPrice.toString();
  }


  //Function to fetch the filtered items from database
  Future<List<Map<String, dynamic>>> fetchItemsFromDatabase(String pattern) async {
    final databaseHelper = DatabaseHelper();
    final databaseRecords = await databaseHelper.getAllRecords(); // Call your database query method
    // Extract item names in the format "brand-design-size" along with their IDs from the database records
    final itemsWithIds = databaseRecords.map((record) {
      final brand = record['brand'] as String;
      final design = record['design'] as String;
      final size = record['size'] as String;
      final id = record['id'] as int; // Assuming the ID field in your database is of type int
      final itemName = '$brand-$design-$size';
      return {'id': id, 'itemName': itemName};
    }).toList();

    // Filter items that match the input pattern
    final filteredItems = itemsWithIds.where((item) {
      final itemName = item['itemName'] as String;
      return itemName.toLowerCase().contains(pattern.toLowerCase());
    }).toList();

    return filteredItems;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 10; i++) {
      qtyFocusNodes[i].addListener(() { // Creates focus node for each quantity field
        if (!qtyFocusNodes[i].hasFocus) {
          updateAmount(i);
        }
      });
    }
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        backgroundColor: const Color(0xFF48CC56),
        actions: [
          TextButton(onPressed:(){

          },
              child: const Text("Generate Invoice",
                style: TextStyle(color: Colors.white),
              ))
        ],
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
                      padding: const EdgeInsets.only(top:8.0, left: 8.0, right: 8.0),
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
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Reciept No. : ${widget.prefs.getString('_receiptNumKey')??''}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            labelText: 'Customer Details',
                            labelStyle: TextStyle(color: Colors.black), // Set label text color to black
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
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
                                    child:
                                    TypeAheadField(
                                      textFieldConfiguration: TextFieldConfiguration(

                                        controller: itemControllers[i] ,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all( 15.0),
                                          labelText: 'Item',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        // Fetch item suggestions based on the input pattern
                                        return await fetchItemsFromDatabase(pattern);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        final item = suggestion;
                                        return ListTile(
                                          title: Text(item['itemName'] as String),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        final item = suggestion;
                                        final id = item['id'] as int; // Extract the ID from the suggestion
                                        setState(() {
                                          idList[i]=id;
                                          itemControllers[i].text = item['itemName'] as String; // Set the text field to the item string
                                          fetchSellingPrice(id, rateControllers[i]);
                                        });
                                     },
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.grey, // Border color
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: qtyControllers[i],
                                          focusNode: qtyFocusNodes[i],
                                          keyboardType: TextInputType.number, // Specify the keyboard type for numbers
                                          decoration: const InputDecoration(
                                            border: InputBorder.none, // Remove the default input border
                                          ),

                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.grey, // Border color
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: rateControllers[i],
                                          keyboardType: TextInputType.number, // Specify the keyboard type for numbers
                                          decoration: const InputDecoration(
                                            border: InputBorder.none, // Remove the default input border
                                          ),

                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.grey, // Border color
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: amtControllers[i],

                                          keyboardType: TextInputType.number, // Specify the keyboard type for numbers
                                          decoration: const InputDecoration(
                                            border: InputBorder.none, // Remove the default input border
                                          ),

                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        for (int i = 0; i < amtControllers.length; i++) {
                          totalAmt += double.tryParse(
                              amtControllers[i].text) ?? 0;
                        }
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total Amount = $totalAmt',
                            style: const TextStyle(
                               fontSize: 18,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
