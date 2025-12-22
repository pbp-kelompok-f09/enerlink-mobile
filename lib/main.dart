import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'routes.dart'; // Custom Router
import 'providers/admin_dashboard_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  runApp(const EnerlinkApp());
}

class EnerlinkApp extends StatelessWidget {
  const EnerlinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider for Auth (PBP Django Auth)
        Provider(
          create: (_) {
            CookieRequest request = CookieRequest();
            return request;
          },
        ),
        // Provider for Admin Dashboard State
        ChangeNotifierProvider(create: (_) => AdminDashboardProvider()),
      ],
      child: MaterialApp(
        title: 'Enerlink',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB), // primaryBlue
            secondary: const Color(0xFFFACC15), // yellow
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          textTheme: GoogleFonts.interTextTheme(),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2563EB),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: EnerlinkMobileRouter.onGenerateRoute,
      ),
    );
  }
}
