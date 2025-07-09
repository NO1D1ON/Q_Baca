import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:q_baca/pages/halamanUtama/beranda/home_controller.dart';
import 'package:q_baca/pages/onBoarding/splashScreen.dart';

void main() async {
  // Pastikan binding Flutter sudah siap sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi data lokal untuk bahasa Indonesia ('id_ID')
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan MultiProvider agar controller bisa diakses di seluruh aplikasi
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
        // Tambahkan provider lain di sini jika diperlukan di masa depan
      ],
      // [PERBAIKAN] Hapus 'const' dari MaterialApp karena delegates bukan nilai konstan
      child: MaterialApp(
        title: 'Q-Baca',
        theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Figtree'),
        debugShowCheckedModeBanner: false,

        // Daftarkan lokal yang didukung oleh aplikasi Anda
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // Sekarang akan dikenali
        ],
        supportedLocales: const [
          Locale('id', 'ID'), // Mendukung Bahasa Indonesia
        ],

        home: const SplashScreen(), // Halaman awal aplikasi Anda
      ),
    );
  }
}
