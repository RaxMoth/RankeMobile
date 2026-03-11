import 'package:flutter/material.dart';
import 'app_footer.dart';
import 'app_header.dart';

/// Base Layout with Header and Footer
/// Provides a scaffold with customizable header and footer
class BaseLayout extends StatelessWidget {
  final String? headerTitle;
  final Widget? headerLeading;
  final List<Widget>? headerActions;
  final Widget body;
  final List<FooterItem>? footerItems;
  final int? selectedFooterIndex;
  final Function(int)? onFooterItemTapped;
  final bool showFooter;
  final bool showHeader;
  final Color? backgroundColor;
  final FloatingActionButton? floatingActionButton;
  final VoidCallback? onHeaderLeadingPressed;

  const BaseLayout({
    Key? key,
    this.headerTitle,
    this.headerLeading,
    this.headerActions,
    required this.body,
    this.footerItems,
    this.selectedFooterIndex,
    this.onFooterItemTapped,
    this.showFooter = false,
    this.showHeader = true,
    this.backgroundColor,
    this.floatingActionButton,
    this.onHeaderLeadingPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showHeader
          ? AppHeader(
              title: headerTitle,
              leading: headerLeading,
              actions: headerActions,
              onLeadingPressed: onHeaderLeadingPressed,
            )
          : null,
      body: body,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showFooter && footerItems != null
          ? AppFooter(
              items: footerItems!,
              selectedIndex: selectedFooterIndex ?? 0,
              onItemTapped: onFooterItemTapped,
            )
          : null,
    );
  }
}

/// Safe Area Layout with Header and Footer
/// Adds safe area padding
class SafeBaseLayout extends StatelessWidget {
  final String? headerTitle;
  final Widget? headerLeading;
  final List<Widget>? headerActions;
  final Widget body;
  final List<FooterItem>? footerItems;
  final int? selectedFooterIndex;
  final Function(int)? onFooterItemTapped;
  final bool showFooter;
  final bool showHeader;
  final Color? backgroundColor;
  final FloatingActionButton? floatingActionButton;
  final EdgeInsets padding;

  const SafeBaseLayout({
    Key? key,
    this.headerTitle,
    this.headerLeading,
    this.headerActions,
    required this.body,
    this.footerItems,
    this.selectedFooterIndex,
    this.onFooterItemTapped,
    this.showFooter = false,
    this.showHeader = true,
    this.backgroundColor,
    this.floatingActionButton,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showHeader
          ? AppHeader(
              title: headerTitle,
              leading: headerLeading,
              actions: headerActions,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: body,
        ),
      ),
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showFooter && footerItems != null
          ? AppFooter(
              items: footerItems!,
              selectedIndex: selectedFooterIndex ?? 0,
              onItemTapped: onFooterItemTapped,
            )
          : null,
    );
  }
}
