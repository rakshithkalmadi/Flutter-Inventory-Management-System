import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'databasehelper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class InvoicePage extends StatefulWidget {
  final SharedPreferences prefs;
  const InvoicePage({super.key, required this.prefs});
  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  bool istotal=false;
  String firmName = '', address = '', email = '', phoneNumber = '';
  int recptNum=0;
  List<int> idList = List<int>.filled(10, -1);
  double totalAmt = 0;
  List<FocusNode> qtyFocusNodes = List.generate(10, (index) => FocusNode());

  List<TextEditingController> itemControllers =
      List.generate(10, (index) => TextEditingController());
  TextEditingController custName = TextEditingController();
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
  Future<void> fetchSellingPrice(
      int itemId, TextEditingController controller) async {
    final databaseHelper = DatabaseHelper();
    double sellingPrice = await databaseHelper.getSellingPriceById(itemId);
    // Set the selling price in the TextFormField
    controller.text = sellingPrice.toString();
  }

  //Function to fetch the filtered items from database
  Future<List<Map<String, dynamic>>> fetchItemsFromDatabase(
      String pattern) async {
    final databaseHelper = DatabaseHelper();
    final databaseRecords =
        await databaseHelper.getAllRecords(); // Call your database query method
    // Extract item names in the format "brand-design-size" along with their IDs from the database records
    final itemsWithIds = databaseRecords.map((record) {
      final brand = record['brand'] as String;
      final design = record['design'] as String;
      final size = record['size'] as String;
      final id = record['id']
          as int; // Assuming the ID field in your database is of type int
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
    istotal=true;
    firmName = widget.prefs.getString('firmName') ?? '';
    address = widget.prefs.getString('address') ?? '';
    email = widget.prefs.getString('email') ?? '';
    phoneNumber = widget.prefs.getString('phoneNumber') ?? '';
    try {
      recptNum = int.parse(widget.prefs.getString('receiptNum') ?? '');
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
    for (int i = 0; i < 10; i++) {
      qtyFocusNodes[i].addListener(() {
        // Creates focus node for each quantity field
        if (!qtyFocusNodes[i].hasFocus) {
          updateAmount(i);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve values from SharedPreferences

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        backgroundColor: const Color(0xFF48CC56),
        actions: [
          TextButton(
              onPressed: () async {
                await generateInvoice();
                // Update the receipt number in SharedPreferences
                await widget.prefs.setString('receiptNum', (recptNum + 1).toString());
                int sold=0;
                for(int i=0;i<10;i++){
                  if(idList[i]!=-1){
                    int currentQty=await DatabaseHelper().getQuantityById(idList[i]);
                    try {
                       sold = int.parse(qtyControllers[i].text);
                    } catch (e) {
                      // ignore: avoid_print
                      print("Error: $e");
                    }
                    int newQty=currentQty-sold;
                    DatabaseHelper().updateQuantity(idList[i], newQty);
                  }
                }
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text(
                "Generate Invoice",
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
                height: screenHeight+100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0),
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
                                'Reciept No. : ${widget.prefs.getString('receiptNum') ?? ''}',
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
                            const SizedBox(
                                height: 5.0), // Adjust spacing as needed
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
                          controller: custName,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(5),
                            labelText: 'Customer Details',
                            labelStyle: TextStyle(
                                color: Colors
                                    .black), // Set label text color to black
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
                        width:
                            screenWidth, // Set the width of the parent container
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
                                    color: Colors
                                        .grey[300], // Optional background color
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
                                    color: Colors
                                        .grey[300], // Optional background color
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
                                    color: Colors
                                        .grey[300], // Optional background color
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
                                    color: Colors
                                        .grey[300], // Optional background color
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
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        controller: itemControllers[i],
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(15.0),
                                          labelText: 'Item',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        // Fetch item suggestions based on the input pattern
                                        return await fetchItemsFromDatabase(
                                            pattern);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        final item = suggestion;
                                        return ListTile(
                                          title:
                                              Text(item['itemName'] as String),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        final item = suggestion;
                                        final id = item['id']
                                            as int; // Extract the ID from the suggestion
                                        setState(() {
                                          idList[i] = id;
                                          itemControllers[i].text = item[
                                                  'itemName']
                                              as String; // Set the text field to the item string
                                          fetchSellingPrice(
                                              id, rateControllers[i]);
                                        });
                                      },
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.grey, // Border color
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: qtyControllers[i],
                                          focusNode: qtyFocusNodes[i],
                                          keyboardType: TextInputType
                                              .number, // Specify the keyboard type for numbers
                                          decoration: const InputDecoration(
                                            border: InputBorder
                                                .none, // Remove the default input border
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.grey, // Border color
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: rateControllers[i],
                                          keyboardType: TextInputType
                                              .number, // Specify the keyboard type for numbers
                                          decoration: const InputDecoration(
                                            border: InputBorder
                                                .none, // Remove the default input border
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.grey, // Border color
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: amtControllers[i],

                                          keyboardType: TextInputType
                                              .number, // Specify the keyboard type for numbers
                                          decoration: const InputDecoration(
                                            border: InputBorder
                                                .none, // Remove the default input border
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
                      onTap: istotal? (){
                        setState(() {
                          for (int i = 0; i < amtControllers.length; i++) {
                            if(idList[i]!=0) {
                              totalAmt +=
                                  double.tryParse(amtControllers[i].text) ?? 0;
                            }
                          }
                        });

                      }:null,
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

  // Function to generate the invoice in pdf format
  Future<File?> generateInvoice() async {
    final PermissionStatus status = await Permission.storage.request();
    if (!status.isGranted) {
      // Permission is denied, handle accordingly (e.g., show a message to the user).
      return null; // You might want to return or handle this differently
    }
    final pw.Document doc = pw.Document();
    final font = await rootBundle.load("assets/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(font);
    final fontBold = await rootBundle.load("assets/Roboto-Bold.ttf");
    final ttfBold = pw.Font.ttf(fontBold);
    List<pw.TableRow> tableRows = [];

    for (int i = 0; i < 10; i++) {
      final itemText = itemControllers[i].text;
      final qtyText = qtyControllers[i].text;
      final rateText = rateControllers[i].text;
      final amtText = amtControllers[i].text;

      if (itemText.isNotEmpty &&
          qtyText.isNotEmpty &&
          rateText.isNotEmpty &&
          amtText.isNotEmpty) {
        tableRows
            .add(_buildTableRow(itemText, qtyText, rateText, amtText, ttf));
      }
    }

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Column(children: [
              pw.Padding(
                padding:
                    const pw.EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.white,
                      width: 2.0,
                    ),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          'Receipt No. : $recptNum',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: ttfBold,
                              fontSize: 20),
                        ),
                      ),
                      pw.Text(
                        firmName,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: ttfBold,
                            fontSize: 20),
                      ),
                      pw.SizedBox(height: 5.0), // Adjust spacing as needed
                      pw.Text(
                        address,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: ttfBold,
                            fontSize: 20),
                      ),
                      pw.SizedBox(height: 5.0),
                      pw.Text(
                        phoneNumber,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: ttfBold,
                            fontSize: 20),
                      ),
                      pw.SizedBox(height: 5.0),
                      pw.Text(
                        email,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            font: ttfBold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(10.0),
                    border: pw.Border.all(
                      color: PdfColors.black,
                      width: 2.0,
                    ),
                  ),
                  child: pw.Text(
                    'Customer Details : ${custName.text} ',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        font: ttfBold,
                        fontSize: 20),
                  ),
                ),
              ),
            ]),
            pw.SizedBox(height: 10),
            pw.Table(
              defaultColumnWidth: const pw.IntrinsicColumnWidth(flex: 1.0),
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              children: [
                // Table Head
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  children: [
                    pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text('Item',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: ttfBold,
                              fontSize: 20)),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text('Quantity',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: ttfBold,
                              fontSize: 20)),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text('Rate',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: ttfBold,
                              fontSize: 20)),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text('Amount',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              font: ttfBold,
                              fontSize: 20)),
                    ),
                  ],
                ),
                ...tableRows,
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Total Amount = $totalAmt',
                textAlign: pw.TextAlign.center,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfBold,fontSize: 15),
              ),
            ),
          ]);
        },
      ),
    );

    // Stores data in  Android/data/user/0/com.example.flutter_ims/app_flutter path
    final Directory? downloadsDirectory =
        (await getExternalStorageDirectory());
    if (!(await downloadsDirectory!.exists())) {
      await downloadsDirectory.create(recursive: true);
    }
    final String inventoryPath = downloadsDirectory.path;
    final File file = File('$inventoryPath/invoice$recptNum.pdf');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  // Function to create the items in table
  pw.TableRow _buildTableRow(String item, String quantity, String rate,
      String amount, pw.Font ttf) {
    return pw.TableRow(
      children: [
        pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Text(item, style: pw.TextStyle(font: ttf,fontSize: 15,)),
        ),
        pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Text(quantity, style: pw.TextStyle(font: ttf,fontSize: 15)),
        ),
        pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Text(rate, style: pw.TextStyle(font: ttf,fontSize: 15)),
        ),
        pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Text(amount, style: pw.TextStyle(font: ttf,fontSize: 15)),
        ),
      ],
    );
  }
}
