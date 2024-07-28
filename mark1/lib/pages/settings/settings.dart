// ignore_for_file: use_build_context_synchronously
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mymy_m1/services/authentication/auth_service.dart';
import 'package:mymy_m1/helpers/getit/get_it.dart';
import 'package:mymy_m1/services/bottom_sheet/bottom_sheet_service.dart';
import 'package:mymy_m1/services/dialogs/dialog_service.dart';
import 'package:mymy_m1/services/notifications/notification_factory.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';
import 'package:mymy_m1/services/bottom_sheet/bottom_sheet_notifier.dart';
import 'package:mymy_m1/shared/ui_consts.dart';
import 'package:provider/provider.dart';
import 'package:mymy_m1/services/settings/settings_service.dart';
import 'package:mymy_m1/services/notifications/notification_manager.dart';
import 'package:mymy_m1/helpers/templates/main_view_template.dart';

class Settings extends StatelessWidget {
  Settings({super.key});

  final AuthService _auth = getIt<AuthService>();
  final NotificationStyle _notificationStyle = NotificationStyle.snackBar;

  NotificationStyle get notificationStyle => _notificationStyle;

  @override
  Widget build(BuildContext context) {
    return mainView(
      context,
      appBarTitle: AppLocalizations.of(context)!.heading_settings,
      appbarActions: [
        IconButton(
          onPressed: () async => _showLogoutConfirmation(context),
          icon: Icon(
            Icons.logout_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        )
      ],
      body: buildSettingsPageBody(),
    );
  }

  Column buildSettingsPageBody() {
    return Column(
      children: [
        Expanded(flex: 2, child: profileSection()),
        Expanded(flex: 6, child: settingsListSection()),
        Expanded(
            flex: 1,
            child: Container(
                color: Colors.amber,
                child: SizedBox.expand(child: Text("Version: ?"))))
      ],
    );
  }

  Column settingsListSection() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Consumer<SettingsService>(
            builder: (context, settings, child) {
              return ListView(
                children: [
                  Align(
                    child: Padding(
                      padding: UiConsts.paddingEdgeInsetsAll,
                      child: Text(
                        "Appearance",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                  SettingDropdown<ThemeMode>(
                    title: AppLocalizations.of(context)!.themeMode,
                    value: settings.themeMode,
                    items: ThemeMode.values,
                    onChanged: (newValue) => _updateSetting(
                      context,
                      () => settings.setThemeMode(newValue),
                    ),
                    itemBuilder: (mode) =>
                        Text(mode.toString().split('.').last.capitalize),
                  ),
                  SettingDropdown<String>(
                    title: AppLocalizations.of(context)!.theme,
                    value: settings.currentThemeName,
                    items: settings.availableThemes,
                    onChanged: (newValue) => _updateSetting(
                      context,
                      () => settings.setTheme(newValue),
                    ),
                    itemBuilder: (name) => Text(name),
                  ),
                  SettingDropdown<Locale?>(
                    title: AppLocalizations.of(context)!.heading_language,
                    value: settings.currentLocaleOrNull,
                    items: settings.supportedLocalesWithDefault,
                    onChanged: (newValue) => _updateSetting(
                      context,
                      () => settings.setLocale(newValue),
                    ),
                    itemBuilder: (locale) =>
                        Text(settings.getLanguageName(locale, context)),
                  ),
                  SettingDropdown<NotificationStyle>(
                    title: AppLocalizations.of(context)!.notificationStyle,
                    value: settings.notificationStyle,
                    items: NotificationStyle.values,
                    onChanged: (newValue) => _updateSetting(
                      context,
                      () => settings.setNotificationStyle(newValue),
                    ),
                    itemBuilder: (style) =>
                        Text(style.toString().split('.').last.capitalize),
                    previewButton: ElevatedButton(
                      onPressed: () => _showPreviewNotification(context),
                      child: Text(
                          AppLocalizations.of(context)!.previewNotification),
                    ),
                  )
                ],
              );
            },
          ),
        ),
        Expanded(flex: 2, child: SizedBox.expand(child: Text("About")))
      ],
    );
  }

  Widget profileSection() {
    return Container(
      color: Colors.amber,
      child: const SizedBox.expand(
        child: Text(" Profile section "),
      ),
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final bool? confirmed = await DialogService.showConfirmationDialog(
      context: context,
      title: AppLocalizations.of(context)!.logoutConfirmationTitle,
      message: AppLocalizations.of(context)!.logoutConfirmationMessage,
      confirmText: AppLocalizations.of(context)!.logout,
    );

    if (confirmed == true) {
      context.loaderOverlay.show();
      await _auth.signOut();
      context.goNamed('Start');
      context.loaderOverlay.hide();
    }
  }
}

Future<void> _updateSetting(
    BuildContext context, Future<bool> Function() updateFunction) async {
  try {
    bool success = await updateFunction();
    if (success) {
      context.read<NotificationManager>().showNotification(
            context,
            NotificationData(
              title: 'Success',
              message: AppLocalizations.of(context)!.noti_newChangeApplied,
              type: CustomNotificationType.success,
            ),
          );
    } else {
      throw Exception('Failed to update setting');
    }
  } catch (e) {
    context.read<NotificationManager>().showNotification(
          context,
          NotificationData(
              title: 'Error',
              message: AppLocalizations.of(context)!.noti_errorOccurred,
              type: CustomNotificationType.error),
        );
  }
}

void _showPreviewNotification(BuildContext context) {
  context.read<NotificationManager>().showNotification(
        context,
        NotificationData(
            title: 'Info',
            message: "Preview of the notification style",
            type: CustomNotificationType.info),
      );
}

class SettingDropdown<T> extends StatefulWidget {
  final String title;
  final T value;
  final List<T> items;
  final Future<void> Function(T) onChanged;
  final Widget Function(T) itemBuilder;
  final Widget? previewButton;

  const SettingDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemBuilder,
    this.previewButton,
  });

  @override
  _SettingDropdownState<T> createState() => _SettingDropdownState<T>();
}

class _SettingDropdownState<T> extends State<SettingDropdown<T>> {
  bool _isChanging = false;

  @override
  Widget build(BuildContext context) {
    final bottomSheetNotifier = BottomSheetNotifier.of(context);

    return ListTile(
      title: Text(widget.title),
      trailing: _isChanging
          ? LoadingAnimationWidget.twoRotatingArc(
              color: Theme.of(context).colorScheme.onSurface, size: 20)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.itemBuilder(widget.value),
                UiConsts.spaceForTextAndElement,
                const Icon(Icons.arrow_forward_ios,
                    size: UiConsts.smallIconSize),
              ],
            ),
      onTap: () {
        bottomSheetNotifier?.setBottomSheetState(true);
        BottomSheetService.showCustomBottomSheet(
          context: context,
          builder: (_, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                SettingBottomSheet<T>(
                  title: widget.title,
                  value: widget.value,
                  items: widget.items,
                  onChanged: (T newValue) async {
                    setState(() => _isChanging = true);
                    await widget.onChanged(newValue);
                    setState(() => _isChanging = false);
                  },
                  itemBuilder: widget.itemBuilder,
                ),
                if (widget.previewButton != null) widget.previewButton!,
              ],
            ),
          ),
        ).then((_) {
          bottomSheetNotifier?.setBottomSheetState(false);
        });
      },
    );
  }
}

class SettingBottomSheet<T> extends StatelessWidget {
  final String title;
  final T value;
  final List<T> items;
  final Future<void> Function(T) onChanged;
  final Widget Function(T) itemBuilder;

  const SettingBottomSheet({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: UiConsts.paddingEdgeInsetsAllLarge,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          ...items.map((item) => ListTile(
                title: itemBuilder(item),
                onTap: () async {
                  await onChanged(item);
                  Navigator.pop(context);
                },
                trailing: value == item ? const Icon(Icons.check) : null,
              )),
        ],
      ),
    );
  }
}
