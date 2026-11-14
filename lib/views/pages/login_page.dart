import 'package:flutter/material.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../widgets/auth/auth_button.dart';
import '../widgets/auth/auth_header.dart';
import '../widgets/auth/auth_text_field.dart';
import 'main_navigation_page.dart';

enum AuthStep { login, forgotPassword, resetPassword }

class LoginPage extends StatefulWidget {
  final String? initialToken;
  const LoginPage({super.key, this.initialToken});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthViewModel _authViewModel = AuthViewModel();

  AuthStep _currentStep = AuthStep.login;

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();

  final TextEditingController _forgotEmailController = TextEditingController();

  final TextEditingController _resetNewPasswordController = TextEditingController();
  final TextEditingController _resetConfirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _forgotEmailController.dispose();
    _resetNewPasswordController.dispose();
    _resetConfirmPasswordController.dispose();
    _authViewModel.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Preencha seu e-mail e senha.');
      return;
    }

    final success = await _authViewModel.login(email: email, password: password);
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationPage()),
      );
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _forgotEmailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Informe o e-mail cadastrado.');
      return;
    }

    final success = await _authViewModel.forgotPassword(email);
    if (success && mounted) {
      _showMessage('Link enviado para seu e-mail!');
      setState(() => _currentStep = AuthStep.resetPassword);
    }
  }

  Future<void> _handleResetPassword() async {
    final newPassword = _resetNewPasswordController.text;
    final confirmPassword = _resetConfirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Preencha todos os campos.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('As senhas não coincidem.');
      return;
    }

    final success = await _authViewModel.resetPassword(
      token: widget.initialToken ?? '',
      newPassword: newPassword,
    );

    if (success && mounted) {
      _showMessage('Senha alterada com sucesso! Faça login.');
      setState(() => _currentStep = AuthStep.login);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: const Color(0xFFFF7A00), content: Text(text)),
    );
  }

  Widget _buildTitle(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        children: const [
          TextSpan(
            text: '.',
            style: TextStyle(
              color: Color(0xFFFF7A00),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 28),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('Realize seu login'),
        _buildSubtitle(
          'Acesse sua conta para visualizar ou realizar novos agendamentos, acessar serviços, dentre outros recursos.',
        ),
        AuthTextField(
          label: 'Email',
          hint: 'colaborador@tuaregue.com',
          icon: Icons.mail_rounded,
          controller: _loginEmailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        AuthTextField(
          label: 'Senha',
          hint: '************',
          icon: Icons.lock_rounded,
          isPassword: true,
          controller: _loginPasswordController,
        ),
        const SizedBox(height: 24),
        AuthButton(
          text: 'Realizar Login',
          isLoading: _authViewModel.isLoading,
          onPressed: _handleLogin,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => setState(() => _currentStep = AuthStep.forgotPassword),
            child: const Text(
              'Esqueceu sua senha?',
              style: TextStyle(
                color: Color(0xFFFF7A00),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('Recupere sua senha'),
        _buildSubtitle(
          'Esqueceu sua senha? Informe seu e-mail de acesso que enviaremos um link para resetar sua senha.',
        ),
        AuthTextField(
          label: 'Email',
          hint: 'colaborador@tuaregue.com',
          icon: Icons.mail_rounded,
          controller: _forgotEmailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        AuthButton(
          text: 'Enviar',
          isLoading: _authViewModel.isLoading,
          onPressed: _handleForgotPassword,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => setState(() => _currentStep = AuthStep.login),
            child: const Text(
              'Voltar para tela de login?',
              style: TextStyle(
                color: Color(0xFFFF7A00),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle('Inserir nova senha'),
        _buildSubtitle('Insira a nova senha para acessar sua conta novamente.'),
        AuthTextField(
          label: 'Nova senha',
          hint: '************',
          icon: Icons.lock_rounded,
          isPassword: true,
          controller: _resetNewPasswordController,
        ),
        const SizedBox(height: 20),
        AuthTextField(
          label: 'Repetir nova senha',
          hint: '************',
          icon: Icons.lock_rounded,
          isPassword: true,
          controller: _resetConfirmPasswordController,
        ),
        const SizedBox(height: 24),
        AuthButton(
          text: 'Resetar Senha',
          isLoading: _authViewModel.isLoading,
          onPressed: _handleResetPassword,
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => setState(() => _currentStep = AuthStep.login),
            child: const Text(
              'Voltar para tela de login?',
              style: TextStyle(
                color: Color(0xFFFF7A00),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: ListenableBuilder(
        listenable: _authViewModel,
        builder: (context, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthHeader(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_authViewModel.errorMessage != null) ...[
                        Text(
                          _authViewModel.errorMessage!,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                      ],
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: KeyedSubtree(
                          key: ValueKey(_currentStep),
                          child: switch (_currentStep) {
                            AuthStep.login => _buildLoginForm(),
                            AuthStep.forgotPassword => _buildForgotPasswordForm(),
                            AuthStep.resetPassword => _buildResetPasswordForm(),
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}