import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedCountryCode = '+1'; // Default country code

  final List<String> _countryCodes = [
    '+1',   // USA
    '+44',  // UK
    '+91',  // India
    '+81',  // Japan
    '+61',  // Australia
    '+49',  // Germany
    '+33',  // France
    '+39',  // Italy
    '+34',  // Spain
    '+7',   // Russia
    '+86',  // China
    '+27',  // South Africa
    '+55',  // Brazil
    '+52',  // Mexico
    '+66',  // Thailand
    '+82',  // South Korea
    '+60',  // Malaysia
    '+65',  // Singapore
    '+91',  // India
    '+20',  // Egypt
    '+233', // Ghana
    '+254', // Kenya
    '+256', // Uganda
    '+92',  // Pakistan
    '+970', // Palestine
    '+963', // Syria
    '+961', // Lebanon
    '+964', // Iraq
    '+965', // Kuwait
    '+971', // UAE
    '+974', // Qatar
    '+973', // Bahrain
    '+968', // Oman
    '+90',  // Turkey
    '+98',  // Iran
    '+94',  // Sri Lanka
    '+977', // Nepal
    '+960', // Maldives
    '+212', // Morocco
    '+230', // Mauritius
    '+265', // Malawi
    '+268', // Eswatini
    '+27',  // South Africa
    '+375', // Belarus
    '+380', // Ukraine
    '+372', // Estonia
    '+371', // Latvia
    '+370', // Lithuania
    '+373', // Moldova
    '+359', // Bulgaria
    '+387', // Bosnia and Herzegovina
    '+385', // Croatia
    '+386', // Slovenia
    '+421', // Slovakia
    '+420', // Czech Republic
    '+352', // Luxembourg
    '+354', // Iceland
    '+358', // Finland
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        hintText: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _companyNameController,
                        label: 'Company Name',
                        hintText: 'Enter the name of your company',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the company name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _addressController,
                        label: 'Address',
                        hintText: 'Enter your address',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _buildPhoneNumberField(),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: 'Enter your password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          // primary: Colors.white, // Button color
                          backgroundColor: Colors.deepPurple, // Text color
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text('Sign Up'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        fillColor: Colors.white,
        filled: true,
        labelStyle: TextStyle(color: Colors.deepPurple),
        hintStyle: TextStyle(color: Colors.deepPurple.withOpacity(0.6)),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }

  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: _selectedCountryCode,
            items: _countryCodes.map((code) {
              return DropdownMenuItem(
                value: code,
                child: Row(
                  children: [
                    // You can use a country flag package here for better visuals
                    Icon(Icons.flag, color: Colors.deepPurple), // Placeholder for flag icon
                    SizedBox(width: 8),
                    Text(code),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCountryCode = value ?? '+1';
              });
            },
            decoration: InputDecoration(
              labelText: 'Country Code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: _buildTextField(
            controller: _phoneNumberController,
            label: 'Phone Number',
            hintText: 'Enter your phone number',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Hash the password
      final hashedPassword = _hashPassword(_passwordController.text);

      // Handle form submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data')),
      );
      print('Email: ${_emailController.text}');
      print('Company Name: ${_companyNameController.text}');
      print('Address: ${_addressController.text}');
      print('Phone Number: $_selectedCountryCode${_phoneNumberController.text}');
      print('Password: $hashedPassword');
      // Here you can add your logic to handle the form submission, such as sending data to a server
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
