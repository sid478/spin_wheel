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
  final List<SpinItem<String>> items = [
     SpinItem<String>(
      id: 1,
      label: '400 Points',
      image: 'https://cdn-icons-png.flaticon.com/512/4213/4213654.png',
    ),
     SpinItem<String>(
      id: 2,
      label: 'INR 100 Amazon Pay Gift Card',
      image: 'https://cdn-icons-png.flaticon.com/512/4228/4228674.png',
    ),
    //
     SpinItem<String>(id: 3, label: 'Better Luck Next Time',
      // image: 'https://cdn-icons-png.flaticon.com/512/4213/4213650.png',
    ),
     SpinItem<String>(
      id: 4,
      label: '100 Points',
      image: 'https://cdn-icons-png.flaticon.com/512/4228/4228674.png',
    ),

     SpinItem<String>(
      id: 5,
      label: '200 Amazon Gift Card',
      image: 'https://cdn-icons-png.flaticon.com/512/4228/4228674.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title:  Text('Spin Wheel')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinWheel<String>(
              showSpinButton: false,
              // showSpinCount: false,
              controller: controller,
              showDividers: false,
              giftImageSize: 40.0,
              markerSize: 70,
              spinButtonColor: Colors.red,
              maxSpinCount: 5,
              wheelSize: 390,
              items: items,
              outerBlinkerCount: 30,
              showBlinkDecoration: true,
              outerRingDecoration: SpinWheelOuterRingDecoration.star,
              // marker: SpinWheelMarker(
              //   type: SpinMarkerType.ribbon,
              //   color: Colors.red,
              //   borderColor: Colors.yellow,
              //   size: 50,
              // ),
              // marker:  Image.asset(),
              // marker: Icon(Icons.arrow_downward_sharp, size: 60, color: Colors.blueAccent)
              theme:  SpinWheelTheme(
                segmentGradients:  [
                  RadialGradient(
                    colors: [
                      Color(0xFFFFF9C4),
                      Color(0xFFFFE082),
                    ],
                  ),

                  RadialGradient(
                    colors: [
                      Color(0xFFE1F5FE),
                      Color(0xFF81D4FA),
                    ],
                  ),

                  RadialGradient(
                    colors: [
                      Color(0xFFFCE4EC),
                      Color(0xFFF8BBD0),
                    ],
                  ),

                  RadialGradient(
                    colors: [
                      Color(0xFFE3F2FD),
                      Color(0xFF90CAF9),
                    ],
                  ),

                  RadialGradient(
                    colors: [
                      Color(0xFFF3E5F5),
                      Color(0xFFCE93D8),
                    ],
                  ),

                  RadialGradient(
                    colors: [
                      Color(0xFFFFEBEE),
                      Color(0xFFFFAB91),
                    ],
                  ),
                  // RadialGradient(colors: [Color(0xFFFFD54F), Color(0xFFFF8F00)]), // Yellow 3D
                  // RadialGradient(colors: [Color(0xFF81D4FA), Color(0xFF0277BD)]), // Light Blue 3D
                  // RadialGradient(colors: [Color(0xFFF48FB1), Color(0xFFC2185B)]), // Pink 3D
                  // RadialGradient(colors: [Color(0xFF4FC3F7), Color(0xFF01579B)]), // Dark Blue 3D
                  // RadialGradient(colors: [Color(0xFFF8BBD0), Color(0xFFD81B60)]), // Light Pink 3D
                  // RadialGradient(colors: [Color(0xFFE57373), Color(0xFFC62828)]), // Red 3D
                ],
                outerRingGradient: SweepGradient(
                  colors: [
                    Colors.deepPurpleAccent,
                    Colors.deepPurple,
                  ],
                ),
                // outerRingWidth: 24, // Increased width
              ),
              showConfetti: true,
              showOuterBorder:false,
              showWinnerPopup: false,
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
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding:  EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header
                            Container(
                              width: double.infinity,
                              padding:  EdgeInsets.fromLTRB(20, 28, 20, 28),
                              decoration:  BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF4B2BA7),
                                    Color(0xFFB51ED0),
                                    Color(0xFFFF3672),
                                    Color(0xFFFF9D32),
                                  ],
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Check icon
                                  Container(
                                    width: 86,
                                    height: 86,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha: 0.10),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.35),
                                        width: 2,
                                      ),
                                    ),
                                    child:  Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 55,
                                    ),
                                  ),

                                   SizedBox(height: 20),

                                   Text(
                                    'Congratulations!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                   SizedBox(height: 8),

                                  Text(
                                    item.label,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Reward section
                            Padding(
                              padding:  EdgeInsets.fromLTRB(28, 30, 28, 20),
                              child: Column(
                                children: [
                                   Text(
                                    'REWARD POINTS',
                                    style: TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),

                                   SizedBox(height: 8),



                                  // Info box
                                  Container(
                                    width: double.infinity,
                                    padding:  EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color:  Color(0xFFFFF9ED),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color:  Color(0xFFFFE1A8),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         Icon(
                                          Icons.info_outline,
                                          color: Color(0xFFE5A33A),
                                          size: 24,
                                        ),
                                         SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Your reward points will be credited to your '
                                                'account after approval.',
                                            style:  TextStyle(
                                              color: Color(0xFFE5A33A),
                                              fontSize: 15,
                                              height: 1.4,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                   SizedBox(height: 28),

                                  // Home button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // Navigate to home here
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child:  Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
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
