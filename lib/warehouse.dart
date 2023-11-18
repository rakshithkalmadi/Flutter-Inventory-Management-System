import 'package:flutter/material.dart';
import 'databasehelper.dart';
import 'editrecord.dart';
import 'records.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  WarehousePageState createState() => WarehousePageState();
}

class WarehousePageState extends State<WarehousePage> {
  List<Record> records = [];

  // Function refresh the page
  void refreshData() {
    fetchRecordsFromDatabase();
  }

  @override
  void initState() {
    super.initState();
    fetchRecordsFromDatabase();
  }

  // Function to load the records from database
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

  // Group records by warehouse section
  Map<String, List<Record>> groupRecordsByWarehouse() {
    final groupedRecords = <String, List<Record>>{};

    for (final record in records) {
      final section = record.warehouseSection;
      if (!groupedRecords.containsKey(section)) {
        groupedRecords[section] = [];
      }
      groupedRecords[section]!.add(record);
    }

    return groupedRecords;
  }

  // Function to get the filtered cards
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
    final groupedRecords = groupRecordsByWarehouse();
    final groupedWidgets = buildGroupedWidgets(groupedRecords);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2DA1E5),
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
        body: ListView(
          children: searchQuery.isEmpty
              ? groupedWidgets // Display grouped widgets when searchQuery is empty
              : buildSearchResults(), // Display search results with headings
        ));
  }

  //Function to display the cards grouped according to warehouse sections
  List<Widget> buildGroupedWidgets(Map<String, List<Record>> groupedRecords) {
    final widgets = <Widget>[];

    groupedRecords.forEach((section, recordsInSection) {
      widgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                section,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...recordsInSection.map((record) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditRecordPage(
                        refreshData: fetchRecordsFromDatabase,
                        record: record,
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: const Color(0xFF52ADE3),
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
            }).toList(),
          ],
        ),
      );
    });

    return widgets;
  }

  // Function to display the cards that are being searched
  List<Widget> buildSearchResults() {
    final searchResults = getFilteredCards();

    if (searchResults.isEmpty) {
      return [
        const Center(
          child: Text(
            'No items found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ];
    }

    return searchResults.map((record) {
      final section = record.warehouseSection;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              section,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditRecordPage(
                    refreshData: fetchRecordsFromDatabase,
                    record: record,
                  ),
                ),
              );
            },
            child: Card(
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
          ),
        ],
      );
    }).toList();
  }
}
