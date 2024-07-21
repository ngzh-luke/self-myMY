import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({
    required this.navigationShell,
    super.key,
  });
  final StatefulNavigationShell navigationShell;

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int selectedIndex = 0;

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: widget.navigationShell,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          tooltip: (AppLocalizations.of(context)!.tooltip_addNewTransaction),
          hoverElevation: 10,
          onPressed: () {
            setState(() {
              context.goNamed('NewTransaction');
            });
          },
          backgroundColor:
              Theme.of(context).colorScheme.errorContainer.darken(20),
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onErrorContainer,
          )), // Icons.playlist_add_outlined
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        onButtonPressed: (index) {
          setState(() {
            selectedIndex = index;
          });
          _goBranch(selectedIndex);
        },
        iconSize: 30,
        fontWeight: FontWeight.normal,
        activeColor:
            Theme.of(context).colorScheme.onPrimaryContainer.brighten(10),
        inactiveColor:
            Theme.of(context).colorScheme.onPrimaryContainer.darken(10),
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            icon: Icons.home,
            title: 'Home',
          ),
          BarItem(
              title: AppLocalizations.of(context)!.records,
              icon: Icons.receipt_rounded),
          BarItem(
            icon: Icons.analytics_outlined,
            title: AppLocalizations.of(context)!.analytics,
          ),
          BarItem(
            icon: Icons.settings,
            title: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
    );
  }
}
