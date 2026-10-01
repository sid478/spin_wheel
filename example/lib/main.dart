import 'package:flutter/material.dart';
import 'package:fortune_spin_wheel/fortune_spin_wheel.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SpinDemoPage(),
    );
  }
}

class SpinDemoPage extends StatefulWidget {
  const SpinDemoPage({super.key});

  @override
  State<SpinDemoPage> createState() => _SpinDemoPageState();
}

class _SpinDemoPageState extends State<SpinDemoPage> {
  final controller = SpinWheelController();
  final List<SpinItem<String>> items = const [
    SpinItem<String>(id: 1, label: '400\nPoints'),
    SpinItem<String>(id: 2, label: 'INR 100\nAmazon Pay\nGift Card'),
    SpinItem<String>(id: 3, label: 'Better Luck Next Time'),
    SpinItem<String>(id: 4, label: '100\nPoints'),
    SpinItem<String>(id: 5, label: '200\nAmazon Gift Card'),

    // SpinItem<String>(id: 6, label: 'Better Luck\nNext Time'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Spin Wheel')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinWheel<String>(
              controller: controller,
              // marker: SpinWheelMarker(
              //   type: SpinMarkerType.pin,
              //   color: Colors.red,
              //   borderColor: Colors.yellow,
              //   size: 40,
              // ),
              // marker:  Image.asset(),
              // marker: Icon(Icons.arrow_downward_sharp, size: 60, color: Colors.blueAccent)
              markerSize: 70,
              spinButtonColor: Colors.red,
              maxSpinCount: 1,
              wheelSize: 360,
              items: items,
              outerSemiCircleCount: 20,
              showOuterSemiCircle: true,
              outerRingDecoration: SpinWheelOuterRingDecoration.star,
              theme: const SpinWheelTheme(
                // segmentGradients: const [
                //   // RadialGradient(colors: [Color(0xFFFFD54F), Color(0xFFFF8F00)]), // Yellow 3D
                //   // RadialGradient(colors: [Color(0xFF81D4FA), Color(0xFF0277BD)]), // Light Blue 3D
                //   // RadialGradient(colors: [Color(0xFFF48FB1), Color(0xFFC2185B)]), // Pink 3D
                //   // RadialGradient(colors: [Color(0xFF4FC3F7), Color(0xFF01579B)]), // Dark Blue 3D
                //   // RadialGradient(colors: [Color(0xFFF8BBD0), Color(0xFFD81B60)]), // Light Pink 3D
                //   // RadialGradient(colors: [Color(0xFFE57373), Color(0xFFC62828)]), // Red 3D
                // ],
                // outerRingGradient: SweepGradient(
                //   colors: [
                //     // Colors.purple,
                //     // Colors.deepPurple,
                //   ],
                // ),
                // outerRingWidth: 24, // Increased width
              ),

              showConfetti: true,
              showWinnerPopup: true,
              spinButtonText: 'SPIN',
              spinButtonWidth: 160,
              // spinButtonStyle: ButtonStyle(
              //   backgroundColor: WidgetStateProperty.all(Colors.cyan),
              // ),
              onWinnerPopupButtonTap: (item, index) {
                if (item.label.contains('Better')) {
                  // Do nothing or navigate somewhere else
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }

                controller.resetWheel();
              },
              onSpinButtonTap: () async {
                // Here you can make an API call or logic to determine the prize.
                // Return the `id`,id (or `index`) of the item you want the wheel to stop on.
                // For example, 'prize_amazon' is the INR 100 Amazon Pay Gift Card.
                // For example, '1',1 is the INR 100 Amazon Pay Gift Card.
                return 2;
              },

              onWinner: (item, index) {
                // showDialog(
                //     context: context,
                //     builder: (context) {
                //       return AlertDialog(
                //           title: const Text('You Won!'),
                //           content: Text('Your prize is: ${item.label}'),
                //           actions: [
                //             TextButton(
                //               onPressed: () => Navigator.pop(context),
                //               child: const Text('Awesome'),
                //             )
                //           ]
                //       );
                //     }
                // );
                debugPrint('Winner: ${item.label}');
              },
              playSpinSound: () {},
              playWinSound: () {},
            ),
          ],
        ),
      ),
    );
  }
}
