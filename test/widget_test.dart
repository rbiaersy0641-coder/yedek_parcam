import 'package:flutter_test/flutter_test.dart';
import 'package:yedek_parcam/main.dart';

void main() {
  testWidgets('YedekParçam katalog ekranı açılır', (tester) async {
    await tester.pumpWidget(const YedekParcamApp());

    expect(find.text('YedekParçam'), findsOneWidget);
    expect(find.text('Sana uygun parçalar'), findsOneWidget);
  });
}