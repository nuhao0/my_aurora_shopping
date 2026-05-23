import 'package:equatable/equatable.dart';
import '../../services/cart_service.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {
  final String uid;
  const LoadCart(this.uid);
  @override
  List<Object?> get props => [uid];
}

class AddItemToCart extends CartEvent {
  final String uid;
  final CartItem item;
  const AddItemToCart(this.uid, this.item);
  @override
  List<Object?> get props => [uid, item];
}

class RemoveItemFromCart extends CartEvent {
  final String uid;
  final String productId;
  const RemoveItemFromCart(this.uid, this.productId);
  @override
  List<Object?> get props => [uid, productId];
}

class UpdateCartQuantity extends CartEvent {
  final String uid;
  final String productId;
  final int quantity;
  const UpdateCartQuantity(this.uid, this.productId, this.quantity);
  @override
  List<Object?> get props => [uid, productId, quantity];
}

class ClearCartItems extends CartEvent {
  final String uid;
  const ClearCartItems(this.uid);
  @override
  List<Object?> get props => [uid];
}
