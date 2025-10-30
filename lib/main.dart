import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _iconController = TextEditingController();
  IconLabel? _selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Us Today for the Cash Money!'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Welcome Message
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_confirmPasswordController.text != value) {
                    return 'Passwords do not match';
                  }
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_passwordController.text != value) {
                    return 'Passwords do not match';
                  }
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Avatar Field
              DropdownMenu<IconLabel>(
                controller: _iconController,
                enableFilter: false,
                requestFocusOnTap: true,
                leadingIcon: Icon(_selectedIcon?.icon),
                label: const Text('Avatar'),
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                ),
                onSelected: (IconLabel? icon) {
                  setState(() {
                    _selectedIcon = icon;
                  });
                },
                dropdownMenuEntries: IconLabel.entries,
              ),
              const SizedBox(height: 16),

              // Sign Up Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ConfirmAnimation().confirmAnimation(
                      context,
                      ConfirmScreen(
                        username: _nameController.text,
                        selectedIcon: _selectedIcon,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmScreen extends StatelessWidget {
  final String username;
  final IconLabel? selectedIcon;

  const ConfirmScreen({
    super.key,
    required this.username,
    required this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = Container();
    Widget avatarSpacing = Container();
    Widget avatarSpacingTemplate = const SizedBox(height: 24);

    if (selectedIcon?.label == 'Smiley Face') {
      avatar = Icon(Icons.sentiment_satisfied_outlined, size: 128);
      avatarSpacing = avatarSpacingTemplate;
    } else if (selectedIcon?.label == 'Rocket') {
      avatar = Icon(Icons.rocket, size: 128);
      avatarSpacing = avatarSpacingTemplate;
    } else if (selectedIcon?.label == 'Paw Print') {
      avatar = Icon(Icons.pets, size: 128);
      avatarSpacing = avatarSpacingTemplate;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account created!'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            avatar,
            avatarSpacing,
            Text(
              'Welcome, $username!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

// Define dropdown menu for avatar selection
typedef IconEntry = DropdownMenuEntry<IconLabel>;

enum IconLabel {
  smiley('Smiley Face', Icons.sentiment_satisfied_outlined),
  rocket('Rocket', Icons.rocket),
  pawprint('Paw Print', Icons.pets);

  const IconLabel(this.label, this.icon);
  final String label;
  final IconData icon;

  static final List<IconEntry> entries = UnmodifiableListView<IconEntry>(
    values.map<IconEntry>(
      (IconLabel icon) => IconEntry(
        value: icon,
        label: icon.label,
        leadingIcon: Icon(icon.icon),
      ),
    ),
  );
}

// Animation for confirm screen transition
class ConfirmAnimation {
  void confirmAnimation(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );

          return ScaleTransition(
            scale: tween.animate(curvedAnimation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }
}
