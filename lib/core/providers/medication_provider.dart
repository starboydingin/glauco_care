import 'package:flutter/material.dart';

class MedItem {
  String name;
  String time; // "HH:mm"
  String note;
  bool taken;

  MedItem({
    required this.name,
    required this.time,
    this.note = '',
    this.taken = false,
  });
}

class MedicationProvider extends ChangeNotifier {
  final List<MedItem> _medications = [
    MedItem(name: 'Timolol 0.5%', time: '08:00', note: 'Mata kiri & kanan'),
    MedItem(name: 'Latanoprost 0.005%', time: '14:00', note: 'Mata kiri'),
    MedItem(name: 'Timolol 0.5%', time: '20:00', note: 'Mata kiri & kanan'),
  ];

  List<MedItem> get medications => List.unmodifiable(_medications);

  int get takenCount => _medications.where((m) => m.taken).length;
  int get totalCount => _medications.length;
  int get percentage =>
      totalCount == 0 ? 0 : ((takenCount / totalCount) * 100).round();

  void toggleTaken(int index) {
    _medications[index].taken = !_medications[index].taken;
    notifyListeners();
  }

  void addMed(MedItem item) {
    _medications.add(item);
    _medications.sort((a, b) => a.time.compareTo(b.time));
    notifyListeners();
  }

  void deleteMed(int index) {
    _medications.removeAt(index);
    notifyListeners();
  }
}
