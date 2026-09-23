enum PaymentMethod { esewa, khalti, cash }

extension PaymentMethodX on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.esewa:
        return 'eSewa';
      case PaymentMethod.khalti:
        return 'Khalti';
      case PaymentMethod.cash:
        return 'Pay at visit';
    }
  }

  String get sublabel {
    switch (this) {
      case PaymentMethod.esewa:
      case PaymentMethod.khalti:
        return 'Pay now online';
      case PaymentMethod.cash:
        return 'Pay in cash when you visit';
    }
  }

  /// True for methods that need to open an external payment flow before
  /// the booking can be confirmed.
  bool get requiresOnlineCheckout =>
      this == PaymentMethod.esewa || this == PaymentMethod.khalti;
}
