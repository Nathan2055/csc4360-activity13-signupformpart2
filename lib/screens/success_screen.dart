import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
import 'package:signup_app/models/icon_enum.dart';

// Tha Big Confetti Celebration
class SuccessScreen extends StatefulWidget {
  final String userName;
  final IconLabel? selectedIcon;
  final double finalProfileCompletion;
  final double finalPasswordStrength;

  const SuccessScreen({
    super.key,
    required this.userName,
    required this.selectedIcon,
    required this.finalProfileCompletion,
    required this.finalPasswordStrength,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 10),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Widget buildAchivementCards() {
    List<Card> cards = List.empty(growable: true);

    /*
    Widget card1 = Container();
    Widget card2 = Container();
    Widget card3 = Container();

    if (widget.finalPasswordStrength == 1.0) {
      card1 = Card(
        child: ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Strong Password Master'),
          subtitle: const Text('Created a strong password'),
        ),
      );
    }

    if (DateTime.now().hour < 12) {
      card2 = Card(
        child: ListTile(
          leading: const Icon(Icons.timer),
          title: const Text('Early Bird Special'),
          subtitle: const Text('Signed up before 12 PM'),
        ),
      );
    }

    if (widget.finalProfileCompletion == 1.0) {
      card3 = Card(
        child: ListTile(
          leading: const Icon(Icons.edit_document),
          title: Text('Profile Completer'),
          subtitle: Text('Filled in all profile fields'),
        ),
      );
    }

    return ListView(children: [card1, card2, card3]);
    */

    if (widget.finalPasswordStrength == 1.0) {
      cards.add(
        Card(
          child: ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Strong Password Master'),
            subtitle: const Text('Created a strong password'),
          ),
        ),
      );
    }

    if (DateTime.now().hour < 12) {
      cards.add(
        Card(
          child: ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Early Bird Special'),
            subtitle: const Text('Signed up before 12 PM'),
          ),
        ),
      );
    }

    if (widget.finalProfileCompletion == 1.0) {
      cards.add(
        Card(
          child: ListTile(
            leading: const Icon(Icons.edit_document),
            title: Text('Profile Completer'),
            subtitle: Text('Filled in all profile fields'),
          ),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return cards[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container();
    Widget avatarSpacing = Container();
    Widget avatarSpacingTemplate = const SizedBox(height: 24);

    if (widget.selectedIcon?.label == 'Smiley Face') {
      avatar = Icon(Icons.sentiment_satisfied_outlined, size: 64);
      avatarSpacing = avatarSpacingTemplate;
    } else if (widget.selectedIcon?.label == 'Rocket') {
      avatar = Icon(Icons.rocket, size: 64);
      avatarSpacing = avatarSpacingTemplate;
    } else if (widget.selectedIcon?.label == 'Paw Print') {
      avatar = Icon(Icons.pets, size: 64);
      avatarSpacing = avatarSpacingTemplate;
    }

    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Stack(
        children: [
          // Confetti Aniiiii
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.deepPurple,
                Colors.purple,
                Colors.blue,
                Colors.green,
                Colors.orange,
              ],
            ),
          ),

          // Tha Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Celebration it is  Icon
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.elasticOut,
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.celebration,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Personalized Welcome Message
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Welcome, ${widget.userName}! 🎉',
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 1,
                  ),

                  const SizedBox(height: 20),

                  avatar,
                  avatarSpacing,

                  const Text(
                    'Your adventure begins now!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  buildAchivementCards(),

                  const SizedBox(height: 20),

                  // Daaa... Continue Button
                  ElevatedButton(
                    onPressed: () {
                      _confettiController.play();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'More Celebration!',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
