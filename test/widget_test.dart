import 'package:flutter_test/flutter_test.dart';

import 'package:yifan_app/main.dart';

void main() {
  testWidgets('PhotoGleam app shell loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Upload'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
