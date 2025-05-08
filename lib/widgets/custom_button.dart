// lib/widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:indriya_academy/config/theme.dart';

enum ButtonType { primary, secondary, outline, text, white, small }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;  // Changed to nullable to support loading states
  final ButtonType type;
  final bool isFullWidth;
  final IconData? icon;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;  // Added loading state support

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isFullWidth = false,
    this.icon,
    this.height,
    this.padding,
    this.isLoading = false,  // Default to not loading
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonPadding = padding ??
        EdgeInsets.symmetric(
          horizontal: 24,
          vertical: type == ButtonType.small || type == ButtonType.text ? 8 : 12,
        );

    final buttonHeight = height ?? 
        (type == ButtonType.small ? 36 : 
         type == ButtonType.text ? 40 : 48);

    // Content with loading indicator support
    Widget content = isLoading 
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.outline || type == ButtonType.text
                    ? AppTheme.primaryColor
                    : Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null && !isLoading) ...[
                Icon(icon, size: type == ButtonType.small ? 16 : 20),
                SizedBox(width: type == ButtonType.small ? 4 : 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: type == ButtonType.small ? 13 : 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          );

    if (isFullWidth) {
      content = SizedBox(
        width: double.infinity,
        height: buttonHeight,
        child: Center(child: content),
      );
    }

    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: buttonPadding,
            minimumSize: Size(0, buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            shadowColor: AppTheme.primaryColor.withOpacity(0.3),
            disabledBackgroundColor: AppTheme.primaryColor.withOpacity(0.6),
            disabledForegroundColor: Colors.white70,
          ),
          child: content,
        );

      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.secondaryColor,
            foregroundColor: Colors.white,
            padding: buttonPadding,
            minimumSize: Size(0, buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            shadowColor: AppTheme.secondaryColor.withOpacity(0.3),
            disabledBackgroundColor: AppTheme.secondaryColor.withOpacity(0.6),
            disabledForegroundColor: Colors.white70,
          ),
          child: content,
        );

      case ButtonType.outline:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primaryColor,
            side: BorderSide(color: AppTheme.primaryColor, width: 1.5),
            padding: buttonPadding,
            minimumSize: Size(0, buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.white,
          ),
          child: content,
        );

      case ButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.primaryColor,
            padding: buttonPadding,
            minimumSize: Size(0, buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: content,
        );

      case ButtonType.white:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primaryColor,
            padding: buttonPadding,
            minimumSize: Size(0, buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.1),
          ),
          child: content,
        );

      case ButtonType.small:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: Size(0, 36),
            textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: content,
        );
    }
  }
}
