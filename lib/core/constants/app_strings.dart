class AppStrings {
  AppStrings._();

  static const String appName = 'GlaucoCare';
  static const String appTagline = 'Pantau Kesehatan Mata Anda';

  // ── Bottom Nav ──────────────────────────────────────────────────────────
  static const String navDashboard = 'Dashboard';
  static const String navMedication = 'Obat';
  static const String navAssessment = 'Asesmen';
  static const String navPressure = 'Tekanan';
  static const String navEducation = 'Edukasi';

  // ── Health Status ───────────────────────────────────────────────────────
  static const String statusHealthy = 'Kondisi Stabil';
  static const String statusMonitor = 'Perlu Dipantau';
  static const String statusDoctor = 'Konsultasi Dokter';

  // ── Dashboard ───────────────────────────────────────────────────────────
  static const String latestIOP = 'Tekanan Mata Terkini';
  static const String rightEye = 'Mata Kanan';
  static const String leftEye = 'Mata Kiri';
  static const String weeklyTrend = 'Tren 7 Hari Terakhir';
  static const String medicationAdherence = 'Kepatuhan Obat';
  static const String quickActions = 'Akses Cepat';
  static const String greeting = 'Selamat datang kembali';
  static const String normalRange = 'Normal: 10–21 mmHg';

  // ── Medication ──────────────────────────────────────────────────────────
  static const String medicationTitle = 'Log Obat Mata';
  static const String todayMeds = 'Obat Hari Ini';
  static const String morning = 'Pagi';
  static const String evening = 'Malam';
  static const String markUsed = 'Sudah Digunakan';
  static const String notTaken = 'Belum Digunakan';
  static const String weeklyAdherence = 'Kepatuhan Minggu Ini';
  static const String medHistory = 'Riwayat Penggunaan';

  // ── Assessment ──────────────────────────────────────────────────────────
  static const String assessmentTitle = 'Asesmen Gejala';
  static const String assessmentSubtitle = 'Jawab pertanyaan berikut dengan jujur';
  static const String nextQuestion = 'Selanjutnya';
  static const String seeResult = 'Lihat Hasil';
  static const String assessmentResult = 'Hasil Asesmen';
  static const String restartAssessment = 'Ulangi Asesmen';

  static const List<String> questions = [
    'Bagaimana kondisi penglihatanmu hari ini?',
    'Apakah matamu terasa sakit atau tidak nyaman?',
    'Apakah kamu mengalami sakit kepala di sekitar mata?',
    'Apakah kamu melihat halo di sekitar lampu?',
  ];

  static const List<String> answerOptions = [
    'Tidak sama sekali',
    'Sedikit',
    'Cukup mengganggu',
    'Sangat mengganggu',
  ];

  // ── Eye Pressure ────────────────────────────────────────────────────────
  static const String pressureTitle = 'Rekam Tekanan Mata';
  static const String addRecord = 'Tambah Rekaman';
  static const String examDate = 'Tanggal Pemeriksaan';
  static const String rightEyePressure = 'Tekanan Mata Kanan (mmHg)';
  static const String leftEyePressure = 'Tekanan Mata Kiri (mmHg)';
  static const String doctorNotes = 'Catatan Dokter';
  static const String saveRecord = 'Simpan Rekaman';
  static const String pressureTrend = 'Tren Tekanan Mata';

  // ── Education ───────────────────────────────────────────────────────────
  static const String educationTitle = 'Edukasi Kesehatan';
  static const String educationSubtitle = 'Pelajari lebih lanjut tentang glaukoma';
}
