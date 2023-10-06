// Class to represent the records
class Record {
  final int id;
  final String brand;
  final String design;
  final String size;
  final String supplier;
  final String warehouseSection;
  final double costPrice;
  final double sellingPrice;
  final int quantity;

  Record({
    required this.id,
    required this.brand,
    required this.design,
    required this.size,
    required this.supplier,
    required this.warehouseSection,
    required this.costPrice,
    required this.sellingPrice,
    required this.quantity,
  });
}
