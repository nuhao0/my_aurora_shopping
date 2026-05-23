import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:taqikrdnawa/backend/models/favorite_item.dart';
import 'package:taqikrdnawa/backend/services/favorite_service.dart';
import 'package:taqikrdnawa/backend/services/push_notification_service.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}
class FavoritesLoading extends FavoritesState {}
class FavoritesLoaded extends FavoritesState {
  final List<FavoriteItem> favorites;
  const FavoritesLoaded(this.favorites);
  
  bool isFavorite(String productId) => favorites.any((f) => f.productId == productId);

  @override
  List<Object?> get props => [favorites];
}
class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
  @override
  List<Object?> get props => [message];
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoriteService _favoriteService;
  final PushNotificationService _pushNotificationService;
  StreamSubscription? _subscription;

  FavoritesCubit({
    required FavoriteService favoriteService,
    required PushNotificationService pushNotificationService,
  })  : _favoriteService = favoriteService,
        _pushNotificationService = pushNotificationService,
        super(FavoritesInitial());

  void loadFavorites(String uid) {
    emit(FavoritesLoading());
    _subscription?.cancel();
    _subscription = _favoriteService.streamFavorites(uid).listen(
      (favorites) => emit(FavoritesLoaded(favorites)),
      onError: (e) => emit(FavoritesError(e.toString())),
    );
  }

  Future<void> toggleFavorite(String uid, FavoriteItem item) async {
    try {
      final isCurrentlyFav = state is FavoritesLoaded && (state as FavoritesLoaded).isFavorite(item.productId);
      await _favoriteService.toggleFavorite(uid, item);
      
      // If we just added it, show a notification
      if (!isCurrentlyFav) {
        await _pushNotificationService.showLocalNotification(
          title: 'Saved to Favorites',
          body: '${item.title} added to your wishlist.',
          uid: uid,
          showSystemNotification: false,
        );
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
