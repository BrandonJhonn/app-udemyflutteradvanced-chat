import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/toast_alert.dart';
import '../services/auth_service.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_input_widget.dart';
import '../widgets/label_widget.dart';
import '../widgets/logo_widget.dart';


class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                LogoWidget(
                  uriAsset: 'assets/img-logo.png', 
                  title: 'Registro'
                ),
                _FormLoginWidget(),
                LabelWidget(
                  textTitle: '¿Ya tienes una cuenta?', 
                  textSubTitle: 'Iniciar Sesion',
                  route: 'login',
                ),
                Text(
                  'Terminos y Condiciones de Uso', 
                  style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
      ),
   );
  }
}

class _FormLoginWidget extends StatefulWidget {
  const _FormLoginWidget({ Key? key }) : super(key: key);

  @override
  State<_FormLoginWidget> createState() => __FormLoginWidgetState();
}

class __FormLoginWidgetState extends State<_FormLoginWidget> {

  final ctrNameInput = TextEditingController();
  final ctrEmailInput = TextEditingController();
  final ctrPasswordInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInputWidget(
            icon: Icons.person_outline,
            placeholder: 'Nombre',
            ctrTextInput: ctrNameInput,
            keyBoardType: TextInputType.text,
          ),
          CustomInputWidget(
            icon: Icons.email_outlined,
            placeholder: 'Correo',
            ctrTextInput: ctrEmailInput,
            keyBoardType: TextInputType.emailAddress,
          ),
          CustomInputWidget(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            ctrTextInput: ctrPasswordInput,
            keyBoardType: TextInputType.text,
            isPassword: true,
          ),

          ButtonWidget(
            color: Colors.green, 
            text: 'Registrar', 
            onPreseed: (authService.procesando) ? null : () async {
              FocusScope.of(context).unfocus();
              final isRegister = await authService.register(ctrNameInput.text.trim(), ctrEmailInput.text.trim(), ctrPasswordInput.text.trim());

              if (isRegister) {
                // TODO: Conectar al socket y loguear
                Navigator.pushReplacementNamed(context, 'users');
              } else {
                mostrarAlerta(context, 'Registro Incorrecto', authService.sms);
              }
            }
          )
        ],
      ),
    );
  }
}