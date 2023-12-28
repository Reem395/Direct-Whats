import 'package:country_code_picker/country_code_picker.dart';
import 'package:direct_whats/view/styles/app_color.dart';
import 'package:direct_whats/view/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  String _phone = "";

  String _countryCode = "";

  final TextEditingController _phoneController = TextEditingController();

  Uri whatsappUrl = Uri();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.offWhite,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: [
                        CountryCodePicker(
                            onChanged: (countryCode) {
                              print;
                              _countryCode = countryCode.toString();
                              _phoneController.clear();
                            },
                            initialSelection: '+20',
                            favorite: const ['+20', '+966'],
                            showFlagDialog: true,
                            onInit: (code) {
                              _countryCode = code!.dialCode.toString();
                            }),
                        SizedBox(
                          width: 60.w,
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: _phoneController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number is required.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _phone = value ?? '';
                              // print("_phone $_phone");
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter phone number',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  RoundedButtton(
                      buttonTitle: "Start Chat!",
                      buttonRaduis: 5,
                      buttonFunction: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          try {
                            whatsappUrl = Uri.parse(
                                "whatsapp://send?phone=$_countryCode$_phone");
                            if (await canLaunchUrl(whatsappUrl)) {
                              await launchUrl(whatsappUrl);
                              _phoneController.clear();
                            } else {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "WhatsApp is not installed on this device."),
                                ),
                              );
                            }
                          } catch (e) {
                            print("error : $e");
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
