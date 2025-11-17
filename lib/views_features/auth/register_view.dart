import 'package:betweener_app/core/helpers/context_extenssion.dart';
import 'package:betweener_app/core/util/assets.dart';
import 'package:betweener_app/views_features/auth/login_view.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../core/helpers/api_response.dart';
import '../../models/user.dart';
import '../../view_models/auth_provider.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/secondary_button_widget.dart';

class RegisterView extends StatefulWidget {
  static String id = '/registerView';

  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height -
                AppBar().preferredSize.height,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                    child: Hero(
                      tag: 'authImage',
                      child: SvgPicture.asset(AssetsData.authImage),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextFormField(
                    controller: nameController,
                    hint: 'John Doe',
                    label: 'Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  CustomTextFormField(
                    controller: emailController,
                    hint: 'example@gmail.com',
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
                           _register();
                      }
                    },
                    text: 'REGISTER',
                  ),

                  const SizedBox(height: 12),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    UserClass newUser = UserClass();
    newUser.name = nameController.text;
    newUser.email = emailController.text;
    newUser.password = passwordController.text;
    newUser.confirmationPassword = passwordController.text;

    await Provider.of<AuthProvider>(context, listen: false).register(newUser);

    final response =
        Provider.of<AuthProvider>(context, listen: false).userResponse;

    if (response?.status == Status.COMPLETED) {
      context.showSnackBar(message: "Registration successful!",error: false);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, LoginView.id);
      });

    } else if (response?.status == Status.ERROR) {
      context.showSnackBar(
        message: response!.message ?? "Error",
        error: true,
      );

  }

  }


}
