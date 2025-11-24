// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:kidcol/app/utils/responsive_helper.dart';
import 'package:kidcol/i18n/translations.g.dart' as i18n;

import '../controllers/main_page_controller.dart';

class MainPageView extends GetView<MainPageController> {
  const MainPageView({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      if (!ResponsiveHelper.isContextValid(context)) {
        debugPrint(
            'Context is invalid in MainPageView build, returning fallback widget');
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final isDark = theme.brightness == Brightness.dark;

      // Set system UI overlay style based on theme
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: colorScheme.surface,
          systemNavigationBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
        ),
      );

      final navigationType =
          ResponsiveHelper.getAdaptiveNavigationType(context);
      debugPrint('Building MainPageView with navigation type: $navigationType');

      if (navigationType == 'navigationRail') {
        // Tablet and Desktop layout with NavigationRail
        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: Row(
            children: [
              // Navigation Rail
              _buildNavigationRail(context),
              // Vertical divider
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: theme.dividerColor,
              ),
              // Main content
              Expanded(
                child: _buildMainContent(context),
              ),
            ],
          ),
        );
      } else {
        // Mobile layout with BottomNavigationBar
        return Scaffold(
          backgroundColor: colorScheme.surface,
          body: _buildMainContent(context),
          bottomNavigationBar: _buildModernBottomNavBar(context),
        );
      }
    } catch (e) {
      debugPrint('Error in MainPageView build: $e');
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 48,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6)),
              const SizedBox(height: 16),
              Text(
                'Error loading interface',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Force rebuild
                  controller.update();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildMainContent(BuildContext context) {
    try {
      if (!ResponsiveHelper.isContextValid(context)) {
        debugPrint(
            'Context is invalid in _buildMainContent, returning fallback widget');
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;

      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: ConstrainedBox(
            constraints:
                ResponsiveHelper.getResponsiveContainerConstraints(context),
            child: Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
                        child: child,
                      );
                    },
                    child: Obx(() {
                      try {
                        final activeIndex = controller.activeIndex.value;
                        final contents = controller.mainContents;

                        if (activeIndex < 0 || activeIndex >= contents.length) {
                          debugPrint(
                              'Invalid active index: $activeIndex, contents length: ${contents.length}');
                          return const Center(
                            child: Text('Page not found'),
                          );
                        }

                        return contents[activeIndex];
                      } catch (e) {
                        debugPrint('Error in Obx callback: $e');
                        return const Center(
                          child: Text('Error loading page'),
                        );
                      }
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error in _buildMainContent: $e');
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: const Center(
          child: Text('Error loading content'),
        ),
      );
    }
  }

  Widget _buildNavigationRail(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = i18n.Translations.of(context);

    return NavigationRail(
      backgroundColor: colorScheme.surface,
      selectedIndex: controller.activeIndex.value,
      onDestinationSelected: (int index) => controller.navigateToPage(index),
      labelType: NavigationRailLabelType.all,
      leading: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          Icons.palette,
          color: colorScheme.primary,
          size: 32,
        ),
      ),
      destinations: [
        NavigationRailDestination(
          icon: Obx(() => Icon(
                Icons.home_outlined,
                color: controller.activeIndex.value == 0
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              )),
          selectedIcon: Icon(
            Icons.home,
            color: colorScheme.primary,
          ),
          label: Text(t.app.home),
        ),
        NavigationRailDestination(
          icon: Obx(() => Icon(
                Icons.featured_play_list_outlined,
                color: controller.activeIndex.value == 1
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              )),
          selectedIcon: Icon(
            Icons.featured_play_list,
            color: colorScheme.primary,
          ),
          label: Text(t.app.collections),
        ),
        NavigationRailDestination(
          icon: Obx(() => Icon(
                Icons.settings_outlined,
                color: controller.activeIndex.value == 2
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              )),
          selectedIcon: Icon(
            Icons.settings,
            color: colorScheme.primary,
          ),
          label: Text(t.app.settings),
        ),
      ],
    );
  }

  Widget _buildModernBottomNavBar(BuildContext context) {
    try {
      if (!ResponsiveHelper.isContextValid(context)) {
        debugPrint(
            'Context is invalid in _buildModernBottomNavBar, returning empty container');
        return const SizedBox.shrink();
      }

      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final t = i18n.Translations.of(context);

      return Container(
        margin: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 10.0,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Obx(
            () => BottomNavigationBar(
              currentIndex: controller.activeIndex.value,
              onTap: (int i) {
                try {
                  controller.navigateToPage(i);
                } catch (e) {
                  debugPrint('Error navigating to page $i: $e');
                }
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: colorScheme.primary,
              unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
              selectedFontSize: 12.0,
              unselectedFontSize: 12.0,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home),
                  label: t.app.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.featured_play_list_outlined),
                  activeIcon: const Icon(Icons.featured_play_list),
                  label: t.app.collections,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_outlined),
                  activeIcon: const Icon(Icons.settings),
                  label: t.app.settings,
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error in _buildModernBottomNavBar: $e');
      return const SizedBox.shrink();
    }
  }
}
