import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../navigation/app_router.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../components/floating_nav_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Profile Settings',
                          style: AppTypography.headingLarge.copyWith(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildProfileCard(authVm),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildSectionHeader('REPORTS & ACTIVITY'),
                      _buildSettingItem(
                        icon: Icons.bar_chart_rounded,
                        title: 'Analytics & Trends',
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.analytics);
                        },
                      ),
                      _buildSettingItem(
                        icon: Icons.history_rounded,
                        title: 'Transaction History',
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.expenseList);
                        },
                      ),
                      _buildSettingItem(
                        icon: Icons.account_balance_wallet_rounded,
                        title: 'Manage Budgets',
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.manageBudget);
                        },
                      ),
                      _buildSettingHeader('PREFERENCES'),
                      _buildSettingItem(
                        icon: Icons.dark_mode_rounded,
                        title: 'Theme Mode',
                        trailing: Text('Dark', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        onTap: () {},
                      ),
                      _buildSettingItem(
                        icon: Icons.currency_exchange_rounded,
                        title: 'Currency',
                        trailing: const Text('USD (\$)', style: TextStyle(color: Colors.white70)),
                        onTap: () {},
                      ),
                      _buildSettingHeader('ACCOUNT'),
                      _buildSettingItem(
                        icon: Icons.person_outline_rounded,
                        title: 'Edit Profile',
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.editProfile);
                        },
                      ),
                      _buildSettingItem(
                        icon: Icons.lock_outline_rounded,
                        title: 'Change Password',
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.changePassword);
                        },
                      ),
                      _buildSettingItem(
                        icon: Icons.logout_rounded,
                        title: 'Logout',
                        titleColor: AppColors.error,
                        iconColor: AppColors.error,
                        onTap: () {
                          authVm.logout();
                          Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false);
                        },
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          'Daily Expenses v1.0.0',
                          style: TextStyle(color: Colors.white30, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 120), // Space for nav bar
                    ]),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Navigation
          const FloatingNavBar(currentIndex: 3),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.addExpense),
        backgroundColor: AppColors.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildProfileCard(AuthViewModel vm) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=11'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                vm.userName ?? 'User',
                style: AppTypography.headingMedium.copyWith(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 4),
              const Text(
                'ahmed@example.com',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5),
      ),
    );
  }

  Widget _buildSettingHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 24),
      child: Text(
        title,
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? titleColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Icon(icon, color: iconColor ?? Colors.white70),
        title: Text(
          title,
          style: TextStyle(color: titleColor ?? Colors.white, fontWeight: FontWeight.w500),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white30, size: 16),
      ),
    );
  }
}
