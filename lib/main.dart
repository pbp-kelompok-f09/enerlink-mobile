import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart'; // 1. Import Provider
import 'package:pbp_django_auth/pbp_django_auth.dart'; // 2. Import CookieRequest

// Import screen dan provider dashboard kamu
// ⚠️ Pastikan path import ini sesuai dengan folder kamu
import 'package:enerlink_mobile/modules/admin_dashboard/screens/admin_dashboard_screen.dart'; 
import 'package:enerlink_mobile/modules/admin_dashboard/providers/admin_dashboard_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Bungkus MaterialApp dengan MultiProvider
    return MultiProvider(
      providers: [
        // Provider A: Untuk menangani sesi Login & Cookie (Wajib di PBP)
        Provider(
          create: (_) {
            CookieRequest request = CookieRequest();
            return request;
          },
        ),

        // Provider B: "Pelayan" untuk Admin Dashboard
        // Ini biar state dashboard (loading/data) tersimpan meski pindah halaman
        ChangeNotifierProvider(
          create: (_) => AdminDashboardProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Enerlink Admin',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(title: 'Enerlink Home'),
          
          // 4. Arahkan rute '/admin' langsung ke Screen Dashboard yang sudah kita buat
          '/admin': (context) => const AdminDashboardScreen(), 
        },
      ),
    );
  }
}

// --- Di bawah ini kode template bawaan Flutter (Home Page Counter) ---
// --- Biarkan saja dulu sebagai halaman awal ---

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            
            // Tombol pintas ke Admin Dashboard (Buat Testing)
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin');
              },
              child: const Text("Go to Admin Dashboard"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}