import 'package:flutter/material.dart';
import 'package:login_screen/shared/components/components.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Login",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  defaultFormField(
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return "email must not be empty";
                      }
                      return null;
                    },
                    label: "Email",
                    prefix: Icons.email,
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  defaultFormField(
                      controller: passwordController,
                      type: TextInputType.visiblePassword,
                      validate: (String value) {
                        if (value.isEmpty) {
                          return "password must not be empty";
                        }
                        return null;
                      },
                      label: "Password",
                      isPassword: isPassword,
                      suffix:
                          isPassword ? Icons.visibility : Icons.visibility_off,
                      suffixPressed: () {
                        setState(() {
                          isPassword = !isPassword;
                        });
                      },
                      prefix: Icons.lock),
                  const SizedBox(
                    height: 40.0,
                  ),
                  defaultButton(
                    function: () {
                      if (formKey.currentState?.validate() ?? false) {
                        print(emailController.text);
                        print(passwordController.text);
                      }
                    },
                    text: "login",
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isPassword = !isPassword;
                            });
                          },
                          child: const Text("Forget Password"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
