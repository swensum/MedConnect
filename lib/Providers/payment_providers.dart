
import 'package:flutter_riverpod/legacy.dart';
import 'package:med_connect/models/payment_models.dart';

final selectedPaymentMethodProvider =
    StateProvider<PaymentMethod>((ref) => PaymentMethod.esewa);