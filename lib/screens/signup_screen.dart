import 'package:flutter/material.dart';
import 'package:signup_app/models/icon_enum.dart';
import 'success_screen.dart';
import 'package:confetti/confetti.dart';

// Signup Screen w/ Interactive Form
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final TextEditingController _iconController = TextEditingController();
  IconLabel? _selectedIcon;
  late AnimationController _progressController;
  double _progressValue = 0.0;
  late AnimationController _passwordStrengthController;
  double _passwordStrengthValue = 0.1;
  Color _passwordStrengthColor = Colors.red;
  bool _milestone1Reached = false;
  bool _milestone2Reached = false;
  bool _milestone3Reached = false;
  bool _milestone4Reached = false;
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _progressController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() {
            setState(() {});
          })
          ..repeat(reverse: true);
    _passwordStrengthController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5))
          ..addListener(() {
            setState(() {});
          })
          ..repeat(reverse: true);
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 10),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _progressController.dispose();
    _passwordStrengthController.dispose();
    super.dispose();
  }

  // Date Picker Function
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return; // Check if the widget is still in the tree
        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              userName: _nameController.text,
              selectedIcon: _selectedIcon,
              finalProfileCompletion: _progressValue,
              finalPasswordStrength: _passwordStrengthValue,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Account 🎉'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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

                // Animated Form Header
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tips_and_updates,
                        color: Colors.deepPurple[800],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Complete your adventure profile!',
                          style: TextStyle(
                            color: Colors.deepPurple[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Name Field
                _buildTextField(
                  controller: _nameController,
                  label: 'Adventure Name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'What should we call you on this adventure?';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'We need your email for adventure updates!';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Oops! That doesn\'t look like a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // DOB w/Calendar
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.deepPurple,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: _selectDate,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'When did your adventure begin?';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Pswd Field w/ Toggle
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  onEditingComplete: _textFieldCallback,
                  onChanged: _textFieldCallbackString,
                  decoration: InputDecoration(
                    labelText: 'Secret Password',
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.deepPurple,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Every adventurer needs a secret password!';
                    }
                    if (value.length < 6) {
                      return 'Make it stronger! At least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Sign-up Progress Bar
                const Text('Password strength:'),
                const Text(
                  '(Password should be longer than eight characters)',
                  style: TextStyle(fontSize: 10),
                ),
                const Text(
                  '(Password should include a mixture of upper and lower case letters, numbers, and symbols)',
                  style: TextStyle(fontSize: 10),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _passwordStrengthValue,
                  color: _passwordStrengthColor,
                  semanticsLabel: 'Password strength',
                ),
                const SizedBox(height: 30),

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
                const SizedBox(height: 20),

                // Sign-up Progress Bar
                const Text('Sign-up progress', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _progressValue,
                  semanticsLabel: 'Sign-up progress',
                ),
                const SizedBox(height: 30),

                // Submit Button w/ Loading Animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.deepPurple,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 5,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start My Adventure',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.rocket_launch, color: Colors.white),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updatePasswordStrength() {
    setState(() {
      _passwordStrengthValue = 0.1;

      var condition1 = 0.0;
      var condition2 = 0.0;
      var condition3 = 0.0;
      var condition4 = 0.0;
      var password = _passwordController.text;

      // Longer than eight characters
      if (password.length > 8) {
        condition1 = 0.25;
      }
      // Contains uppercase and lowercase letters
      if (password.contains(RegExp(r'.*([A-Z]).*')) &&
          password.contains(RegExp(r'.*([a-z]).*'))) {
        condition2 = 0.25;
      }
      // Contains numbers
      if (password.contains(RegExp(r'.*([0-9]).*'))) {
        condition3 = 0.25;
      }
      // Contains symbols (check against each sequence of ASCII symbols)
      if (password.contains(RegExp(r'.*([!-/]).*')) ||
          password.contains(RegExp(r'.*([:-@]).*')) ||
          password.contains(RegExp(r'.*([\[-`]).*')) ||
          password.contains(RegExp(r'.*([{-~]).*'))) {
        condition4 = 0.25;
      }

      _passwordStrengthValue =
          condition1 + condition2 + condition3 + condition4;

      if (_passwordStrengthValue == 0.0) {
        _passwordStrengthValue = 0.1;
      }

      if (_passwordStrengthValue == 1.0) {
        _passwordStrengthColor = Colors.green;
      } else {
        _passwordStrengthColor = Colors.red;
      }
    });
  }

  void _updateProgressBar() {
    setState(() {
      var condition1 = 0.0;
      var condition2 = 0.0;
      var condition3 = 0.0;
      var condition4 = 0.0;
      if (_nameController.text != '') {
        condition1 = 0.25;
      }
      if (_emailController.text != '') {
        condition2 = 0.25;
      }
      if (_dobController.text != '') {
        condition3 = 0.25;
      }
      if (_passwordController.text != '') {
        condition4 = 0.25;
      }
      _progressValue = condition1 + condition2 + condition3 + condition4;
    });
  }

  void _updateMilestones() {
    setState(() {
      // These are controlled by booleans to ensure that milestones are only hit once
      if (!_milestone1Reached && _progressValue >= 0.25) {
        _milestone1Reached = true;
        final snackBar = const SnackBar(content: Text('Great start!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _confettiController.play();
      }
      if (!_milestone2Reached && _progressValue >= 0.50) {
        _milestone2Reached = true;
        final snackBar = const SnackBar(content: Text('Halfway there!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _confettiController.play();
      }
      if (!_milestone3Reached && _progressValue >= 0.75) {
        _milestone3Reached = true;
        final snackBar = const SnackBar(content: Text('Almost done!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _confettiController.play();
      }
      if (!_milestone4Reached && _progressValue >= 1.0) {
        _milestone4Reached = true;
        final snackBar = const SnackBar(content: Text('Ready for adventure!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _confettiController.play();
      }
    });
  }

  void _textFieldCallback() {
    setState(() {
      _updateProgressBar();
      _updatePasswordStrength();
      _updateMilestones();
    });
  }

  void _textFieldCallbackString(String unused) {
    setState(() {
      _updateProgressBar();
      _updatePasswordStrength();
      _updateMilestones();
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
      onEditingComplete: _textFieldCallback,
      onChanged: _textFieldCallbackString,
    );
  }
}
