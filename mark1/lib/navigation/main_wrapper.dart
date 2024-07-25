import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mymy_m1/services/bottom_sheet/bottom_sheet_notifier.dart';
import 'package:mymy_m1/services/bottom_sheet/bottom_sheet_service.dart';
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
  int _selectedIndex = 0;
  bool _isBottomSheetOpen = false;

  @override
  void didUpdateWidget(covariant MainWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = widget.navigationShell.currentIndex;
      });
      _handleNavigationChange();
    }
  }

  void _handleNavigationChange() {
    if (_isBottomSheetOpen) {
      context.pop();
      _setBottomSheetState(false);
    }
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _setBottomSheetState(bool isOpen) {
    setState(() {
      _isBottomSheetOpen = isOpen;
    });
  }

  // void _showNewTransactionBottomSheet() {
  //   BottomSheetService.showCustomBottomSheet(
  //     context: context,
  //     builder: (context, scrollController) {
  //       return NewTransactionFormSelection(scrollController: scrollController);
  //     },
  //   ).then((_) => _setBottomSheetState(false));

  //   _setBottomSheetState(true);
  // }

  @override
  Widget build(BuildContext context) {
    return BottomSheetNotifier(
      setBottomSheetState: _setBottomSheetState,
      child: Scaffold(
        body: SizedBox.expand(
          child: widget.navigationShell,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _buildFloatingActionButton(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_isBottomSheetOpen) return null;

    return FloatingActionButton(
      hoverElevation: 10,
      tooltip: AppLocalizations.of(context)!.heading_addNewTransaction,
      onPressed: () => context.pushNamed('NewTransaction'),
      backgroundColor: Theme.of(context).colorScheme.errorContainer.darken(20),
      child: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.onErrorContainer,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SlidingClippedNavBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onButtonPressed: (index) {
        setState(() {
          _selectedIndex = index;
        });
        _goBranch(_selectedIndex);
      },
      iconSize: 30,
      activeColor: Theme.of(context).colorScheme.onSecondary,
      inactiveColor: Theme.of(context).colorScheme.onSecondary.darken(10),
      selectedIndex: _selectedIndex,
      barItems: _getNavBarItems(),
    );
  }

  List<BarItem> _getNavBarItems() {
    return [
      BarItem(
        icon: Icons.home,
        title: AppLocalizations.of(context)!.heading_home,
      ),
      BarItem(
        icon: Icons.receipt_rounded,
        title: AppLocalizations.of(context)!.heading_records,
      ),
      BarItem(
        icon: Icons.analytics_outlined,
        title: AppLocalizations.of(context)!.heading_analytics,
      ),
      BarItem(
        icon: Icons.settings,
        title: AppLocalizations.of(context)!.heading_settings,
      ),
    ];
  }
}
