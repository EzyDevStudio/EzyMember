// custom_page_route.dart
import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final int duration;

  CustomPageRoute({
    required this.child,
    this.duration = 300,
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionDuration: Duration(milliseconds: duration),
    reverseTransitionDuration: Duration(milliseconds: duration),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Fade animation
      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      // Slide animation
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.05, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));

      // Scale animation
      final scaleAnimation = Tween<double>(
        begin: 0.97,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        ),
      );
    },
  );
}

// Helper extension to make navigation cleaner
extension NavigatorExtension on BuildContext {
  Future<T?> pushCustomRoute<T>({
    required Widget child,
    int duration = 300,
  }) {
    return Navigator.push<T>(
      this,
      CustomPageRoute<T>(
        child: child,
        duration: duration,
      ),
    );
  }
}