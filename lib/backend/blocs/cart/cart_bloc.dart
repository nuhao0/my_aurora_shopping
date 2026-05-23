import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taqikrdnawa/backend/services/cart_service.dart';
import 'package:taqikrdnawa/backend/services/push_notification_service.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService;
  final PushNotificationService _pushNotificationService;
  StreamSubscription? _cartSubscription;

  CartBloc({
    required CartService cartService,
    required PushNotificationService pushNotificationService,
  })  : _cartService = cartService,
        _pushNotificationService = pushNotificationService,
        super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItem);
    on<RemoveItemFromCart>(_onRemoveItem);
    on<UpdateCartQuantity>(_onUpdateQuantity);
    on<ClearCartItems>(_onClearCart);
    on<_UpdateCartState>((event, emit) => emit(CartLoaded(event.items)));
    on<_CartErrorOccurred>((event, emit) => emit(CartError(event.message)));
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    await _cartSubscription?.cancel();
    _cartSubscription = _cartService.getUserCart(event.uid).listen(
      (items) => add(_UpdateCartState(items)),
      onError: (e) => add(_CartErrorOccurred(e.toString())),
    );
  }

  Future<void> _onAddItem(AddItemToCart event, Emitter<CartState> emit) async {
    try {
      await _cartService.addToCart(event.uid, event.item);
      // Trigger Branded In-App Notification
      await _pushNotificationService.showLocalNotification(
        title: 'Added to Cart',
        body: '${event.item.title} has been added to your Aurora bag.',
        uid: event.uid,
        showSystemNotification: false,
      );
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveItem(RemoveItemFromCart event, Emitter<CartState> emit) async {
    try {
      await _cartService.removeFromCart(event.uid, event.productId);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(UpdateCartQuantity event, Emitter<CartState> emit) async {
    try {
      await _cartService.updateQuantity(event.uid, event.productId, event.quantity);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onClearCart(ClearCartItems event, Emitter<CartState> emit) async {
    try {
      await _cartService.clearCart(event.uid);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _cartSubscription?.cancel();
    return super.close();
  }
}

// Private helper events
class _UpdateCartState extends CartEvent {
  final List<CartItem> items;
  const _UpdateCartState(this.items);
  @override
  List<Object?> get props => [items];
}

class _CartErrorOccurred extends CartEvent {
  final String message;
  const _CartErrorOccurred(this.message);
  @override
  List<Object?> get props => [message];
}
