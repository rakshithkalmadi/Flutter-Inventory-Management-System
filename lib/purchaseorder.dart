// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'databasehelper.dart';
import 'addorder.dart';

class Record {
  final int id;
  final String brand;
  final String design;
  final String size;
  final int quantity;

  Record({
    required this.id,
    required this.brand,
    required this.design,
    required this.size,
    required this.quantity,
  });
}

class RecordListPage extends StatefulWidget {
  const RecordListPage({super.key});

  @override
  RecordListPageState createState() => RecordListPageState();
}

class RecordListPageState extends State<RecordListPage> {
  List<Record> records = [];

  // Callback function to refresh data
  void refreshData() {
    fetchRecordsFromDatabase();
  }

  @override
  void initState() {
    super.initState();
    fetchRecordsFromDatabase();
  }

  //Function to load the records from database
  void fetchRecordsFromDatabase() async {
    final dbHelper = DatabaseHelper();
    final database = await dbHelper.database;

    final List<Map<String, dynamic>> maps =
        await database.query('tyre_inventory');

    setState(() {
      records = List.generate(maps.length, (index) {
        return Record(
          id: maps[index]['id'],
          brand: maps[index]['brand'],
          design: maps[index]['design'],
          size: maps[index]['size'],
          quantity: maps[index]['quantity'],
        );
      });
    });
  }

  String searchQuery = '';
  TextEditingController searchcontroller = TextEditingController();
  bool isSearch = false;

  List<Record> getFilteredCards() {
    // Filter the records list based on the searchQuery
    return records.where((record) {
      final brandDesignSize =
          '${record.brand} - ${record.design} - ${record.size}';
      return brandDesignSize.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2DA1E5),
        title: isSearch
            ? TextField( // Search bar in the appbar
                controller: searchcontroller,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Search',
                  contentPadding: const EdgeInsets.all(12.0),
                  prefixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear, // Clear icon
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        searchcontroller.text = ''; //clear the text
                        searchQuery = '';
                        FocusScope.of(context).unfocus();
                        setState(() {
                          isSearch = !isSearch;
                        });
                      });
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Hide the keyboard when the search icon is tapped
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              )
            : const Text("Purchase Order"),
        actions: <Widget>[
          Visibility(
            visible: !isSearch,
            child: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isSearch = !isSearch;
                  });
                }),
          ),
          IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                // Navigate to Add new record page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>  AddRecordPage(refreshData: refreshData),
                  ),
                );
              }),
        ],
      ),
      body: getFilteredCards().isEmpty
          ? const Center(
              child: Text(
                'No items found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: searchQuery.isEmpty
                  ? records.length
                  : getFilteredCards().length,
              itemBuilder: (context, index) {
                final record = searchQuery.isEmpty? records[index]:getFilteredCards()[index];
                return GestureDetector(
                  onTap: () {
                    // Show a dialog to enter the quantity
                    showDialog(
                      context: context,
                      builder: (context) {
                        int inputQuantity = 0;
                        return AlertDialog(
                          title: const Text('Enter Purchase Quantity'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  inputQuantity = int.tryParse(value) ?? 0;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Quantity',
                                ),
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
                                // Update the quantity in the database
                                final dbHelper = DatabaseHelper();
                                final updatedQuantity =
                                    record.quantity + inputQuantity;
                                await dbHelper.updateQuantity(
                                    record.id, updatedQuantity);

                                // Refresh the record list
                                fetchRecordsFromDatabase();

                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    // Wrap the ListTile in a Card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: const Color(0xFF52ADE3),
                    child: ListTile(
                      title:
                      Text('${record.brand} - ${record.design} - ${record.size}',
                      style: const TextStyle(color: Colors.white),),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
