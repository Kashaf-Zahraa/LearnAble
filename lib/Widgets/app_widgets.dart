import 'package:flutter/material.dart';

import 'app_sizes.dart';

class AppColors {
  static const primary = Color(0xFF4B5FD8);
  static const background = Color(0xFFEFF6FF);
  static const dark = Color(0xFF14213D);
  static const muted = Color(0xFF64748B);
  static const green = Color(0xFF15803D);
  static const greenBg = Color(0xFFDCFCE7);
  static const line = Color(0xFFE2E8F0);
}

/// Lumi mascot placeholder (baad mein Image.asset se replace kar lena)
class LumiMascot extends StatelessWidget {
  final double size;
  const LumiMascot({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB8E1FF), Color(0xFF7FD6D0), Color(0xFF35B8C9)],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, 10)),
        ],
      ),
      child: Icon(Icons.star_rounded,
          size: size * 0.55, color: const Color(0xFFFFD84D)),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSize.button,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button)),
        ),
        child: loading
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
              strokeWidth: 2.5, color: Colors.white),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSize.icon),
              SizedBox(width: AppSpace.s8),
            ],
            Text(label, style: AppText.button),
          ],
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  const SecondaryButton(
      {super.key, required this.label, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSize.button,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.line),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.button)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSize.icon),
              SizedBox(width: AppSpace.s8),
            ],
            Text(label, style: AppText.button),
          ],
        ),
      ),
    );
  }
}

class ToolsChip extends StatelessWidget {
  const ToolsChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.card),
      elevation: 1,
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Accessibility tools jald aa rahe hain')),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppSpace.s14, vertical: AppSpace.s10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.accessibility_new_rounded,
                  size: AppSize.icon, color: AppColors.primary),
              SizedBox(width: AppSpace.s6),
              Text('Tools',
                  style: AppText.body
                      .copyWith(fontWeight: FontWeight.w700)
                      .c(AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}

class AppTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.validator,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  OutlineInputBorder _border(Color c, [double width = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.card),
    borderSide: BorderSide(color: c, width: width),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _hidden,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.icon, color: AppColors.primary),
        suffixIcon: widget.obscure
            ? IconButton(
          icon: Icon(_hidden ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _hidden = !_hidden),
        )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: _border(AppColors.line),
        enabledBorder: _border(AppColors.line),
        focusedBorder: _border(AppColors.primary, 2),
      ),
    );
  }
}
