import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_asia/infrastructure/architecture/cubit_state.dart';

abstract class FormCubit<T> extends Cubit<CubitState<T>> {
  FormCubit({CubitState<T> initialState = const CubitState.loading()}) : super(initialState);

  void submitForm();

  void validateForm();

  void resetForm();

  void updateField(String fieldName, dynamic value);

  Map<String, dynamic> get formData;

  bool get isFormValid;

  void showMessage(String message) {
    // Simple message handling without messenger cubit
    // This can be implemented with SnackBar or other UI feedback
  }

  void showError(String error) {
    // Simple error handling without messenger cubit
    // This can be implemented with SnackBar or other UI feedback
  }

  void showSuccess(String message) {
    // Simple success handling without messenger cubit
    // This can be implemented with SnackBar or other UI feedback
  }
}
