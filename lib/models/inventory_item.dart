// Import the cloud_firestore package
import 'package:cloud_firestore/cloud_firestore.dart';


// Create a class called InventoryItem
class InventoryItem {
  // Declare the properties of the class
  final String id; // A unique id for the inventory item
  final String itemName; // The name of the inventory item
  final int itemQuantity; // The quantity of the inventory item
  final double itemPrice; // The price of the inventory item
  final DateTime itemExpiryDate; // The expiry date of the inventory item

  // Create a constructor for the class that takes named parameters and assigns them to the properties
  InventoryItem({
    required this.id,
    required this.itemName,
    required this.itemQuantity,
    required this.itemPrice,
    required this.itemExpiryDate,
  });

  // Create a method to convert the class instance into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': itemName,
      'quantity': itemQuantity,
      'price': itemPrice,
      'expiryDate': itemExpiryDate,
    };
  }

  // Create a method to convert a map into a class instance
  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'],
      itemName: map['name'],
      itemQuantity: map['quantity'],
      itemPrice: map['price'],
      itemExpiryDate: map['expiryDate']
          .toDate(), // Use the toDate method to convert the Timestamp object into a DateTime object
    );
  }
}
