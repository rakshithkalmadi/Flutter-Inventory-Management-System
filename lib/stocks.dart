// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_ims/editrecord.dart';
import 'databasehelper.dart';
import 'records.dart';

class StockRecordListPage extends StatefulWidget {
  const StockRecordListPage({super.key});

  @override
  StockRecordListPageState createState() => StockRecordListPageState();
}

class StockRecordListPageState extends State<StockRecordListPage> {
  List<Record> records = [];

  // Function to refresh the page
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
          supplier: maps[index]['supplier'],
          warehouseSection: maps[index]['warehouse_section'],
          costPrice: maps[index]['cost_price'],
          sellingPrice: maps[index]['selling_price'],
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
      backgroundColor: const Color(0xFF87F892),
      appBar: AppBar(
        backgroundColor: const Color(0xFF48CC56),
        title: isSearch
            ? TextField(
                // Search bar in the appbar
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
            : const Text("Stock In Inventory"),
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
                final record = searchQuery.isEmpty
                    ? records[index]
                    : getFilteredCards()[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditRecordPage(
                            refreshData: fetchRecordsFromDatabase,
                            record: record),
                      ),
                    );
                  },
                  child: Card(
                    // Wrap the ListTile in a Card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: const Color(0xFF55C47B),
                    child: ListTile(
                      title: Text(
                        '${record.brand} - ${record.design} - ${record.size}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Quantity: ${record.quantity}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
