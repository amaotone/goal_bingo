import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_bingo/widgets/bingo_cell.dart';

void main() {
  group('BingoCell', () {
    test('fromJson creates a valid BingoCell', () {
      final json = {'goal': 'Test Goal', 'isChecked': true};
      final cell = BingoCell.fromJson(json);

      expect(cell.goal, 'Test Goal');
      expect(cell.isChecked, true);
    });
  });

  group('BingoCellWidget', () {
    testWidgets('displays goal text', (WidgetTester tester) async {
      final cell = BingoCell(goal: 'Test Goal', isChecked: false);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BingoCellWidget(
            cell: cell,
            onTap: () {},
            onLongPress: () {},
          ),
        ),
      ));

      expect(find.text('Test Goal'), findsOneWidget);
    });

    testWidgets('changes color when checked', (WidgetTester tester) async {
      final cell = BingoCell(goal: 'Test Goal', isChecked: true);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BingoCellWidget(
            cell: cell,
            onTap: () {},
            onLongPress: () {},
          ),
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, Colors.green[200]);
    });

    testWidgets('calls onTap callback', (WidgetTester tester) async {
      bool tapped = false;
      final cell = BingoCell(goal: 'Test Goal', isChecked: false);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BingoCellWidget(
            cell: cell,
            onTap: () {
              tapped = true;
            },
            onLongPress: () {},
          ),
        ),
      ));

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, true);
    });

    testWidgets('calls onLongPress callback', (WidgetTester tester) async {
      bool longPressed = false;
      final cell = BingoCell(goal: 'Test Goal', isChecked: false);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BingoCellWidget(
            cell: cell,
            onTap: () {},
            onLongPress: () {
              longPressed = true;
            },
          ),
        ),
      ));

      await tester.longPress(find.byType(GestureDetector));
      expect(longPressed, true);
    });
  });
}
