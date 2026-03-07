import 'package:flutter/material.dart';

/// Shared model for a single IOP (intraocular pressure) measurement.
class IopRecord {
  final String date; // 'dd/MM' used as chart label
  final int right;
  final int left;
  const IopRecord(
      {required this.date, required this.right, required this.left});
}

/// ChangeNotifier that holds all IOP records.
/// Both the Eye Pressure screen (write) and Dashboard (read) use this.
class IopProvider extends ChangeNotifier {
  final List<IopRecord> _records = [
    const IopRecord(date: '01/01', right: 19, left: 18),
    const IopRecord(date: '10/01', right: 18, left: 17),
    const IopRecord(date: '20/01', right: 20, left: 19),
    const IopRecord(date: '01/02', right: 17, left: 16),
    const IopRecord(date: '10/02', right: 18, left: 17),
    const IopRecord(date: '20/02', right: 17, left: 16),
    const IopRecord(date: '07/03', right: 17, left: 16),
  ];

  /// All records, oldest first.
  List<IopRecord> get records => List.unmodifiable(_records);

  /// The most recent record.
  IopRecord get latest => _records.last;

  /// Last 7 records (or fewer if not enough data yet), oldest first.
  List<IopRecord> get last7 {
    final n = _records.length;
    return List.unmodifiable(n <= 7 ? _records : _records.sublist(n - 7));
  }

  void addRecord(IopRecord record) {
    _records.add(record);
    notifyListeners();
  }
}
