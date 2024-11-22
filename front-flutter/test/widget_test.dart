import 'package:flutter_test/flutter_test.dart';
import 'package:adopet/DogListScreen.dart'; // Adjust this import to your actual path
import 'package:adopet/main.dart'; // Import MyApp for testing

void main() {
  testWidgets('DogListScreen widget test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp());

    // Verify if DogListScreen is displayed correctly
    expect(find.byType(DogListScreen), findsOneWidget);

    // Here you can add additional tests like tapping on a dog, etc.
  });
}
