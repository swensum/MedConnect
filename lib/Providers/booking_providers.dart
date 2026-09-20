
import 'package:flutter_riverpod/legacy.dart';
import 'package:med_connect/models/booking_models.dart';

class BookingDraftNotifier extends StateNotifier<BookingDraft> {
  BookingDraftNotifier() : super(const BookingDraft());

  void selectDate(DateTime date) {
    // Changing the date invalidates whatever slot was picked for the
    // previous date.
    state = BookingDraft(
      date: date,
      slot: null,
      consultationMode: state.consultationMode,
      note: state.note,
    );
  }

  void selectSlot(String slot) => state = state.copyWith(slot: slot);
  void selectMode(String mode) => state = state.copyWith(consultationMode: mode);
  void setNote(String note) => state = state.copyWith(note: note);

  /// Wipes the draft completely — called before starting a new booking
  /// (from the doctor profile screen) so a finished/abandoned booking
  /// never leaks into the next one. Intentionally NOT called from the
  /// booking screen itself, so back-and-forth navigation within the
  /// SAME booking attempt doesn't lose your picks.
  void reset() => state = const BookingDraft();
}

final bookingDraftProvider =
    StateNotifierProvider<BookingDraftNotifier, BookingDraft>(
  (ref) => BookingDraftNotifier(),
);