import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:enerlink_mobile/services/api_client.dart';

import 'package:shared_preferences/shared_preferences.dart';

// Import the generated mocks
import 'api_client_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('ApiClient Registration', () {
    late MockClient mockClient;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      mockClient = MockClient();
      ApiClient.client = mockClient;
      await dotenv.load(fileName: ".env");
    });

    test('register returns response on success', () async {
      // Arrange
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
            jsonEncode({'token': 'fake_token', 'success': true}), 
            200,
          ));

      // Act
      final response = await ApiClient.register(
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
        firstName: 'Test',
      );

      // Assert
      expect(response.statusCode, 200);
      verify(mockClient.post(
        Uri.parse('http://localhost:8000/api/auth/register/'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).called(1);
    });
  });
}