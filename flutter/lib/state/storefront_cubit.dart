/// The shop landing page and the product detail screen.
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/api_exception.dart';
import '../api/peo_api.dart';
import '../models/site.dart';
import 'async_value.dart';

/// Holds the three billing buckets of the storefront.
class StorefrontCubit extends Cubit<AsyncValue<Storefront>> {
  StorefrontCubit(this.api) : super(const AsyncValue<Storefront>.idle());

  final PeoApi api;

  Storefront get storefront => state.value ?? const Storefront();

  Future<void> load() async {
    emit(
      state.hasValue
          ? state.refreshing()
          : const AsyncValue<Storefront>.loading(),
    );
    try {
      final data = await api.storefront();
      if (isClosed) return;
      emit(AsyncValue<Storefront>.ready(data));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(AsyncValue<Storefront>.failure(e));
    }
  }

  /// The products of one bucket, in the order the server sent them.
  List<ProductCard> bucket(String cycle) => switch (cycle) {
    'quarterly' => storefront.quarterly,
    'yearly' => storefront.yearly,
    _ => storefront.monthly,
  };
}

/// Holds one product, its live pricing and the eggs of its node.
class ProductDetailCubit extends Cubit<AsyncValue<ProductDetail>> {
  ProductDetailCubit(this.api, this.specId)
    : super(const AsyncValue<ProductDetail>.idle());

  final PeoApi api;
  final String specId;

  Future<void> load() async {
    emit(
      state.hasValue
          ? state.refreshing()
          : const AsyncValue<ProductDetail>.loading(),
    );
    try {
      final detail = await api.product(specId);
      if (isClosed) return;
      emit(AsyncValue<ProductDetail>.ready(detail));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(AsyncValue<ProductDetail>.failure(e));
    }
  }
}
