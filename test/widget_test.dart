import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utp_capcut/main.dart';

void main() {
  testWidgets('Verifikasi 4 Navigasi Utama CapCut dan Tanpa Lab AI', (WidgetTester tester) async {
    await tester.pumpWidget(const CapCutApp());

    expect(find.text('Edit'), findsWidgets);
    expect(find.text('Template'), findsWidgets);
    expect(find.text('Proyek'), findsWidgets);
    expect(find.text('Saya'), findsWidgets);

    expect(find.text('Lab AI'), findsNothing);

    expect(find.text('Video baru'), findsOneWidget);
    expect(find.text('Edit foto'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.crop_portrait_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Cari CapCut'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.folder_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Buat karakter AI'), findsOneWidget);
    expect(find.text('Ruang'), findsWidgets);

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.text('Trcy819'), findsOneWidget);
  });
}
