class TimeSlot{
  const TimeSlot(this.time, {this.isAvailable = true});
  final String time;
  final bool isAvailable;
}

Map<String, List<TimeSlot>> mockSlotsFor(DateTime date){
  return{
    'Morning' : const [
      TimeSlot('09:00 AM'),
      TimeSlot('09:30 AM'),
      TimeSlot('10:00 AM', ),
      TimeSlot('10:30 AM'),
      TimeSlot('11:30 AM'),
    ],
    'Afternoon': const [
      TimeSlot('01:00 PM'),
      TimeSlot('02:00 PM'),
      TimeSlot('02:30 PM', ),
      TimeSlot('03:30 PM'),
    ],
    'Evening' : const [
      TimeSlot('04:00 PM'),
      TimeSlot('05:30 PM'),
      TimeSlot('06:30 PM'),
    ],
  };
}
class BookingDraft{
  const BookingDraft({
    this.date,
    this.slot,
    this.consultationMode,
    this.note = '',
  });

  final DateTime? date;
  final String? slot;
  final String? consultationMode;
  final String note;

  bool get isComplete => date != null && slot != null && consultationMode != null;

  BookingDraft copyWith({
    DateTime? date,
    String? slot,
    String? consultationMode,
    String? note,
  }){
    return BookingDraft(
      date: date ?? this.date,
      slot: slot ?? this.slot,
      consultationMode: consultationMode ?? this.consultationMode,
      note: note ?? this.note,
    );
  }
}