import 'package:betweener_app/core/helpers/context_extenssion.dart';
import 'package:betweener_app/core/util/assets.dart';
import 'package:betweener_app/views_features/auth/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import '../../core/helpers/api_response.dart';
import '../../view_models/auth_provider.dart';
import '../main_app_view.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/primary_outlined_button_widget.dart';
import '../widgets/secondary_button_widget.dart';

class LoginView extends StatefulWidget {
  static String id = '/loginView';

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                    child: Hero(
                      tag: 'authImage',
                      child: SvgPicture.asset(AssetsData.authImage),
                    ),
                  ),
                  const Spacer(),
                  CustomTextFormField(
                    controller: emailController,
                    hint: 'example@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    label: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the email';
                      } else if (!EmailValidator.validate(value)) {
                        return 'please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomTextFormField(
                    controller: passwordController,
                    hint: 'Enter password',
                    label: 'password',
                    autofillHints: const [AutofillHints.password],
                    password: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SecondaryButtonWidget(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                      _login();
                      }
                    },
                    text: 'LOGIN',
                  ),
                  const SizedBox(height: 24),
                  PrimaryOutlinedButtonWidget(
                    onTap: () {
                      Navigator.pushNamed(context, RegisterView.id);
                    },
                    text: 'REGISTER',
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async{
   await Provider.of<AuthProvider>(context, listen: false).login(emailController.text,passwordController.text);

    final response =
        Provider.of<AuthProvider>(context, listen: false).userResponse;

    if (response?.status == Status.COMPLETED) {
      context.showSnackBar(message: "Login successful!", error: false);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, MainAppView.id);
      });
    } else if (response?.status == Status.ERROR) {
      context.showSnackBar(message: response!.message ?? "Error", error: true);
    }
  }
}
