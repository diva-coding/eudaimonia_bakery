import 'package:eudaimonia_bakery/services/data_services.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  late Color myColor;
  late Size mediaSize;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US');

  @override
  void initState() {
    super.initState();

    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (visible) {
        // Scroll to the top when the keyboard is visible
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });

    // Add listeners to focus nodes for validation
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        setState(() {});
      }
    });

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        setState(() {});
      }
    });

    _phoneFocusNode.addListener(() {
      if (!_phoneFocusNode.hasFocus) {
        setState(() {});
      }
    });

    _addressFocusNode.addListener(() {
      if (!_addressFocusNode.hasFocus) {
        setState(() {});
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        setState(() {});
      }
    });

    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _addressFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Constants.secondaryColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(myColor.withOpacity(0.2), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Constants.primaryColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                controller: _scrollController,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        _buildTop(),
                        Expanded(child: _buildBottom()),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/logo.png", width: 100, height: 100),
          const Text(
            "Eudaimonia Bakery",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sign Up",
          style: TextStyle(
            color: Constants.secondaryColor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildGreyText("Please create an account with your information"),
        const SizedBox(height: 30),
        _buildGreyText("Email address"),
        _buildInputField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email cannot be blank';
            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildGreyText("Name"),
        _buildInputField(
          controller: _nameController,
          focusNode: _nameFocusNode,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name cannot be blank';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildGreyText("Phone Number"),
        _buildPhoneNumberField(),
        const SizedBox(height: 20),
        _buildGreyText("Address"),
        _buildInputField(
          controller: _addressController,
          focusNode: _addressFocusNode,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Address cannot be blank';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildGreyText("Password"),
        _buildInputField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password cannot be blank';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildGreyText("Confirm Password"),
        _buildInputField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Confirm Password cannot be blank';
            } else if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildCreateAccountButton(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  controller == _passwordController
                      ? (_isPasswordVisible ? Icons.visibility : Icons.visibility_off)
                      : (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  color: Constants.secondaryColor,
                ),
                onPressed: () {
                  setState(() {
                    if (controller == _passwordController) {
                      _isPasswordVisible = !_isPasswordVisible;
                    } else {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    }
                  });
                },
              )
            : null,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Constants.secondaryColor),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      obscureText: isPassword
          ? (controller == _passwordController ? !_isPasswordVisible : !_isConfirmPasswordVisible)
          : false,
      cursorColor: Constants.secondaryColor,
    );
  }

Widget _buildPhoneNumberField() {
  return InternationalPhoneNumberInput(
    onInputChanged: (PhoneNumber number) {
      _phoneNumber = number;
    },
    onInputValidated: (bool value) {
        setState(() {});
    },
    selectorConfig: const SelectorConfig(
      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
    ),
    ignoreBlank: false,
    autoValidateMode: AutovalidateMode.onUserInteraction,
    selectorTextStyle: const TextStyle(color: Colors.black),
    initialValue: _phoneNumber,
    textFieldController: _phoneController,
    formatInput: true,
    inputDecoration: const InputDecoration(
      hintText: 'Phone Number',
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
    ),
    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
  );
}

  Widget _buildCreateAccountButton() {
    return ElevatedButton(
      onPressed: () => _sendRegister(context),
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: Constants.secondaryColor,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("CREATE ACCOUNT",
          style: TextStyle(fontSize: 18, color: Constants.secondaryColor)),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green),
              SizedBox(width: 10),
              Text("Success"),
            ],
          ),
          content: const Text(
              "Your account was successfully created. Go back to login to sign in."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Row(
            children: [
              Icon(Icons.error_outline_outlined, color: Colors.red),
              SizedBox(width: 10),
              Text("Failed"),
            ],
          ),
          content: const Text(
              "Account creation failed. Please check all the fields and try again"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _sendRegister(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final name = _nameController.text;
      final phone = _phoneNumber.phoneNumber;
      final address = _addressController.text;
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match"),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      final response = await DataService.sendRegisterData(
          email, name, phone!, address, password);
      if (response.statusCode == 201) {
        _showSuccessDialog(); // Call the success dialog
      } else {
        _showErrorDialog();
        debugPrint("failed");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Register Failed"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}