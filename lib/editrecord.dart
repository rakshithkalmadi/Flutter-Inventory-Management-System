// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'databasehelper.dart';
import 'records.dart';

class EditRecordPage extends StatefulWidget {
  final VoidCallback refreshData;
  final Record record;
  const EditRecordPage(
      {super.key, required this.refreshData, required this.record});

  @override
  EditRecordPageState createState() => EditRecordPageState();
}

class EditRecordPageState extends State<EditRecordPage> {
  TextEditingController brandController = TextEditingController();
  TextEditingController designController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController warehouseSectionController = TextEditingController();
  TextEditingController costPriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with the values from the provided record
    brandController.text = widget.record.brand;
    designController.text = widget.record.design;
    sizeController.text = widget.record.size;
    supplierController.text = widget.record.supplier;
    warehouseSectionController.text = widget.record.warehouseSection;
    costPriceController.text = widget.record.costPrice.toString();
    sellingPriceController.text = widget.record.sellingPrice.toString();
    quantityController.text = widget.record.quantity.toString();
  }

  // Function add records to table
  void _addRecordToDatabase() async {
    final dbHelper = DatabaseHelper();
    final id = widget.record.id;
    final brand = brandController.text;
    final design = designController.text;
    final size = sizeController.text;
    final supplier = supplierController.text;
    final warehouseSection = warehouseSectionController.text;
    final costPrice = double.parse(costPriceController.text);
    final sellingPrice = double.parse(sellingPriceController.text);
    final quantity = int.parse(quantityController.text);

    final updatedRecord = {
      'id': id,
      'brand': brand,
      'design': design,
      'size': size,
      'supplier': supplier,
      'warehouse_section': warehouseSection,
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'quantity': quantity,
    };

    showDialog(
      //Alert box to confirm the updates
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Update'),
          content: const Text('Are you sure you want to update this record?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Update the record in the database
                await dbHelper.updateRecord(updatedRecord);
                //Refresh the list in the stock list page
                widget.refreshData();
                // Close the confirmation dialog
                Navigator.of(context).pop();

                // Display a success dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Record Updated'),
                      content: const Text(
                          'The record has been updated successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Close the success dialog
                            Navigator.of(context).pop(); // Close the edit page
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: const Color(0xFF2DA1E5),
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
                child: const Text('Update'),
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
        style: const TextStyle(
          color: Colors.white
        ),
        controller: controller,
        keyboardType: keyboardType,
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
