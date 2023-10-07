import 'package:flutter/material.dart';
import 'package:flutter_ims/infoupdate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'invoice.dart';
import 'purchaseorder.dart';
import 'stocks.dart';
import 'warehouse.dart';

class HomePage extends StatefulWidget {
  final SharedPreferences pref;
  const HomePage({super.key,required this.pref});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String propName="";

  void getPropName(){
    setState(() {
      propName=widget.pref.getString('proprietorName')??'';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPropName();
  }
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
             DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Text(
                'HELLO $propName',
                style: const TextStyle(color: Colors.white , fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text("Update Info"),
              leading: const Icon(Icons.info_outline),
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                  builder: (_) =>ProfilePage(pref:widget.pref,refresh: getPropName)
                  )
                );
              },
            )
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
                imageAsset: 'assets/stock.jpg',
                onTap: () {
                  // Navigate to the Inventory details page
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const StockRecordListPage())
                  );
                },
                height: 99,
                width: 148),
            buildCard(
              title: 'Sales Order',
              imageAsset: 'assets/selling.jpg',
              onTap: () {
                // Navigate to the warehouse invoice page
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => InvoicePage(prefs: widget.pref,))
                );
              },
              height: 107,
              width: 118,
            ),
            buildCard(
              title: 'Warehouse Details',
              imageAsset:
                  'assets/warehouse.jpg',
              onTap: () {
                // Navigate to the warehouse details page
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const WarehousePage())
                );
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
