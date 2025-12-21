import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enerlink_mobile/screens/main_screen.dart';
import 'package:enerlink_mobile/widgets/bottom_navbar.dart';
import 'package:enerlink_mobile/screens/dashboard/user_dashboard_screen.dart';
import 'package:enerlink_mobile/screens/community_list.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:enerlink_mobile/services/api_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'api_client_test.mocks.dart';
import 'package:enerlink_mobile/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([http.Client])
void main() {
  setUp(() async {
    await dotenv.load(fileName: ".env");
    SharedPreferences.setMockInitialValues({'auth_token': 'test_token'});
    
    // Mock API Client
    final mockClient = MockClient();
    ApiClient.client = mockClient;
    
    when(mockClient.get(
      Uri.parse('https://vazha-khayri-enerlink.pbp.cs.ui.ac.id/api/dashboard/'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode({
      'username': 'testuser',
      'wallet_balance': 50000,
      'recent_activities': [],
      'user_events': [],
      'communities': []
    }), 200));
  });

  testWidgets('MainScreenMobile navigation test', (WidgetTester tester) async {
    // Build the MainScreenMobile widget
    await tester.pumpWidget(MaterialApp(
      home: const MainScreenMobile(),
      onGenerateRoute: EnerlinkMobileRouter.onGenerateRoute,
    ));

    // Verify that the initial page is HomeContent
    expect(find.text('Explore'), findsOneWidget); // Part of HomeContent
    expect(find.byType(BottomNavbar), findsOneWidget);

    // Tap on the 'Account' icon (index 3)
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    // Verify that UserDashboardScreenMobile is displayed
    // Note: UserDashboardScreenMobile might show loading or login redirect if not mocked properly,
    // but we can check for its presence or loading indicator.
    // Given the lack of API mocks here, it will likely show loading or redirect.
    // However, finding the widget type confirms navigation happened.
    expect(find.byType(UserDashboardScreenMobile), findsOneWidget);
  });
}
