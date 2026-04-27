import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../navigation/app_router.dart';

class FloatingNavBar extends StatelessWidget {
  final int currentIndex;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 24,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, Icons.home_rounded, 'Home', currentIndex == 0, 0),
                _buildNavItem(context, Icons.bar_chart_rounded, 'Analytics', currentIndex == 1, 1),
                const SizedBox(width: 40), // Space for FAB
                _buildNavItem(context, Icons.account_balance_wallet_rounded, 'Wallet', currentIndex == 2, 2),
                _buildNavItem(context, Icons.person_rounded, 'Profile', currentIndex == 3, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive, int index) {
    return GestureDetector(
      onTap: () {
        if (isActive) return;
        
        String route = AppRouter.dashboard;
        switch (index) {
          case 0: route = AppRouter.dashboard; break;
          case 1: route = AppRouter.analytics; break;
          case 2: route = AppRouter.wallet; break;
          case 3: route = AppRouter.settings; break;
        }
        
        Navigator.pushReplacementNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : Colors.white60,
            size: 28,
          ),
          const SizedBox(height: 4),
          if (isActive)
            Container(
              height: 4,
              width: 4,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
