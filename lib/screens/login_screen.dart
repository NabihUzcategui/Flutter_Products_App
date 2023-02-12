import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/providers/login_form_provider.dart';
import '../services/servicies.dart';
import '../ui/input_decorations.dart';
import 'package:productos_app/widgtes/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 250),

              CardContainer(
                child: Column(
                  children: [

                    const SizedBox(height: 10),
                    Text('Login', style: Theme.of(context).textTheme.headlineMedium),                  
                    const SizedBox(height: 10),

                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),
                  
                  ]
                ),
              ),

              const SizedBox(height: 50,),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all( Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all( const StadiumBorder())
                ),
                child: const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, color: Colors.indigo),),
              ),
              const SizedBox(height: 50,),
            ],
          ),
        )
      ),
    );
  }
}



//Formulario de la card
class _LoginForm extends StatelessWidget {


  @override
  Widget build(BuildContext context) { 


    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      child: Column(
        children: [

          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'escriba su dirección de correo', 
              labelText: 'Correo electónico',
              prefixIcon: Icons.alternate_email_rounded,
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp  = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
              ? null
              : 'El correo no es valido';
            },
          ),

          const SizedBox(height: 30),

          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: '********', 
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_clock_outlined
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              
              return ( value != null && value.length >= 6) 
              ? null
              : 'La contraseña debe tener al mneos seis carateres';
              
            },
          ),

          const SizedBox(height: 30),


          MaterialButton(
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
            onPressed: loginForm.isLoading ? null : () async {

              FocusScope.of(context).unfocus();
              final authService = Provider.of<AuthService>(context, listen: false);

              if( !loginForm.isValidForm() ) return;

              loginForm.isLoading = true;

              final String? errorMessage = await authService.login(loginForm.email, loginForm.password);

              if( errorMessage == null) {
                Navigator.pushReplacementNamed(context, 'home');
              } else {
                // print(errorMessage);
                NotificationsService.showSnackbar(errorMessage);
                loginForm.isLoading = false;
              }

              
            },
              child: Container(
                padding: const  EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading
                  ? 'Espere...'
                  : 'Ingresar',
                  style: const  TextStyle(color: Colors.white)
                ),
              ),
          )

        ],

      )
    );
  }
}