// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'databasehelper.dart';

class AddRecordPage extends StatefulWidget {
  final VoidCallback refreshData;
  const AddRecordPage({super.key,required this.refreshData});

  @override
  AddRecordPageState createState() => AddRecordPageState();
}

class AddRecordPageState extends State<AddRecordPage> {
  TextEditingController brandController = TextEditingController();
  TextEditingController designController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController warehouseSectionController = TextEditingController();
  TextEditingController costPriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  // Function add records to table
  void _addRecordToDatabase() async {
    final dbHelper = DatabaseHelper();
    final brand = brandController.text;
    final design = designController.text;
    final size = sizeController.text;
    final supplier = supplierController.text;
    final warehouseSection = warehouseSectionController.text;
    final costPrice = double.parse(costPriceController.text);
    final sellingPrice = double.parse(sellingPriceController.text);
    final quantity = int.parse(quantityController.text);

    final record = {
      'brand': brand,
      'design': design,
      'size': size,
      'supplier': supplier,
      'warehouse_section': warehouseSection,
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'quantity': quantity,
    };

    await dbHelper.insertRecord(record);



    // Call fetchRecordsFromDatabase to refresh the data
    widget.refreshData();
    // Navigate back to RecordListPage
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2DA1E5),
        title: const Text('Add Record'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildStyledTextField(
                controller: brandController,
                labelText: 'Brand',
              ),
              const SizedBox(height: 16.0),
              _buildStyledTextField(
                controller: designController,
                labelText: 'Design',
              ),
              const SizedBox(height: 16.0),
              _buildStyledTextField(
                controller: sizeController,
                labelText: 'Size',
              ),
              const SizedBox(height: 16.0),
              _buildStyledTextField(
                controller: supplierController,
                labelText: 'Supplier',
              ),
              const SizedBox(height: 16.0),
              _buildStyledTextField(
                controller: warehouseSectionController,
                labelText: 'Warehouse Section',
              ),
              const SizedBox(height: 16.0),
              _buildStyledTextField(
                controller: costPriceController,
                labelText: 'Cost Price',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              _buildStyledTextField(
                controller: sellingPriceController,
                labelText: 'Selling Price',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              _buildStyledTextField(
                controller: quantityController,
                labelText: 'Quantity',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DA1E5),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0), // Add border radius here
                  ),
                ),
                onPressed: () {
                  _addRecordToDatabase();
                },
                child: const Text('Add Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Callback to build custom text fields
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF52ADE3),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white, // Set the typed text color to white
        ),
        decoration: InputDecoration(
          hintText: labelText,
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
