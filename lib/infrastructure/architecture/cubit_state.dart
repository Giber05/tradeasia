import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_asia/infrastructure/types/exception/exception.dart';
import 'package:trade_asia/infrastructure/types/resource.dart';

sealed class CubitState<T> extends Equatable {
  const CubitState();

  const factory CubitState.error({required BaseException exception, required void Function() onRetry}) =
      CubitErrorState;
  const factory CubitState.loading() = CubitLoadingState;
  const factory CubitState.success({required T data, bool isRefreshing}) = CubitSuccessState;

  @override
  List<Object?> get props => [];
}

class CubitErrorState<T> extends CubitState<T> {
  final BaseException exception;
  final void Function() onRetry;

  const CubitErrorState({required this.exception, required this.onRetry});

  @override
  List<Object> get props => [exception, onRetry];
}

class CubitLoadingState<T> extends CubitState<T> {
  const CubitLoadingState();
}

class CubitSuccessState<T> extends CubitState<T> {
  final T data;
  final bool isRefreshing;

  const CubitSuccessState({required this.data, this.isRefreshing = false});

  @override
  List<Object?> get props => [data, isRefreshing];

  CubitSuccessState<T> toggleRefresh(bool isRefreshing) => CubitSuccessState<T>(data: data, isRefreshing: isRefreshing);
}

abstract class LoadDataBaseCubit<T> extends ExtendableLoadDataBaseCubit<CubitState<T>, T> {
  LoadDataBaseCubit({CubitState<T> initialState = const CubitState.loading()}) : super(initialState);
}

abstract class ExtendableLoadDataBaseCubit<T extends CubitState<Data>, Data> extends Cubit<CubitState<Data>> {
  ExtendableLoadDataBaseCubit(super.initialState);

  Future<Resource<Data>> usecaseCall();

  void loadData() async {
    emit(const CubitState.loading());
    final result = await usecaseCall();
    switch (result) {
      case Success():
        emit(CubitState.success(data: result.data, isRefreshing: false));
      case Error():
        emit(CubitState.error(exception: result.exception, onRetry: loadData));
    }
  }

  void refresh({bool isSilent = false}) async {
    final state = this.state;
    if (state is! CubitSuccessState<Data>) return;
    if (isSilent) emit(CubitSuccessState(data: state.data, isRefreshing: true));
    final result = await usecaseCall();
    switch (result) {
      case Success():
        emit(CubitState.success(data: result.data, isRefreshing: false));
      case Error():
        if (isSilent) return;
        emit(CubitState.error(exception: result.exception, onRetry: loadData));
    }
  }

  @override
  void emit(CubitState<Data> state) {
    super.emit(state);
    onLoading(state is CubitLoadingState<Data>);
    onRefresh(state is CubitSuccessState<Data> && state.isRefreshing);
  }

  void onRefresh(bool isRefreshing) {}

  void onLoading(bool isLoading) {}
}

abstract class LoadDataBaseCubitWithParams<T, Params> extends Cubit<CubitState<T>> {
  LoadDataBaseCubitWithParams({CubitState<T> initialState = const CubitState.loading()}) : super(initialState);

  Future<Resource<T>> usecaseCall(Params params);

  void loadData(Params params) async {
    emit(const CubitState.loading());
    final result = await usecaseCall(params);
    switch (result) {
      case Success():
        emit(CubitState.success(data: result.data));
      case Error():
        emit(CubitState.error(exception: result.exception, onRetry: () => loadData(params)));
    }
  }
}
