import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordSecurityPage extends StatefulWidget {
  @override
  _PasswordSecurityPageState createState() => _PasswordSecurityPageState();
}

class _PasswordSecurityPageState extends State<PasswordSecurityPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  bool _isUpdating = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmation"),
        content: const Text(
          "Souhaitez-vous vraiment changer le mot de passe ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Confirmer"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isUpdating = true);

    try {
      await user?.updatePassword(_newPasswordController.text.trim());
      _showMessage("Mot de passe mis à jour avec succès.");
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      _showMessage("Erreur : ${e.message}");
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  void _sendResetEmail() async {
    if (user?.email == null) {
      _showMessage("Email introuvable.");
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
      _showMessage("Email envoyé à ${user!.email!}");
    } catch (e) {
      _showMessage("Erreur : ${e.toString()}");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mot de passe et sécurité")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.lock, size: 50, color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                "Email : ${user?.email ?? "Non connecté"}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: "Nouveau mot de passe",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(
                        () => _obscureNewPassword = !_obscureNewPassword,
                      );
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 6) {
                    return "Minimum 6 caractères requis.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: "Confirmer le mot de passe",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      );
                    },
                  ),
                ),
                validator: (value) {
                  if (value != _newPasswordController.text.trim()) {
                    return "Les mots de passe ne correspondent pas.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _isUpdating ? null : _updatePassword,
                icon: _isUpdating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.update),
                label: const Text("Mettre à jour"),
              ),

              TextButton(
                onPressed: _sendResetEmail,
                child: const Text("Réinitialiser via email"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
