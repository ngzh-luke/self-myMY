// ignore_for_file: use_build_context_synchronously
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mymy_m1/helpers/templates/widget_templates.dart';
import 'package:mymy_m1/services/authentication/auth_service.dart';
import 'package:mymy_m1/services/notifications/notification_factory.dart';
import 'package:mymy_m1/services/notifications/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:mymy_m1/services/settings/settings_service.dart';
import 'package:mymy_m1/services/notifications/notification_manager.dart';
import 'package:mymy_m1/helpers/templates/main_view_template.dart';

class Settings extends StatelessWidget {
  Settings({super.key});
  final AuthService _auth = AuthService();
  final NotificationStyle _notificationStyle = NotificationStyle.snackBar;

  NotificationStyle get notificationStyle => _notificationStyle;

  @override
  Widget build(BuildContext context) {
    return mainView(
      context,
      appBarTitle: AppLocalizations.of(context)!.heading_settings,
      appbarActions: [
        IconButton(
            onPressed: () async => await _auth.signOut(),
            icon: const Icon(Icons.logout_outlined))
      ],
      body: Consumer<SettingsService>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              SettingDropdown<ThemeMode>(
                title: AppLocalizations.of(context)!.themeMode,
                value: settings.themeMode,
                items: ThemeMode.values,
                onChanged: (newValue) => _updateSetting(
                  context,
                  () => settings.setThemeMode(newValue),
                ),
                itemBuilder: (mode) => CustomText(
                    text: mode.toString().split('.').last.capitalize),
              ),
              SettingDropdown<String>(
                title: AppLocalizations.of(context)!.theme,
                value: settings.currentThemeName,
                items: settings.availableThemes,
                onChanged: (newValue) => _updateSetting(
                  context,
                  () => settings.setTheme(newValue),
                ),
                itemBuilder: (name) => CustomText(text: name),
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
                    CustomText(text: settings.getLanguageName(locale, context)),
              ),
              SettingDropdown<NotificationStyle>(
                title: AppLocalizations.of(context)!.notificationStyle,
                value: settings.notificationStyle,
                items: NotificationStyle.values,
                onChanged: (newValue) => _updateSetting(
                  context,
                  () => settings.setNotificationStyle(newValue),
                ),
                itemBuilder: (style) => CustomText(
                    text: style.toString().split('.').last.capitalize),
              ),
              ElevatedButton(
                onPressed: () => _showPreviewNotification(context),
                child: Text(AppLocalizations.of(context)!.previewNotification),
              ),
            ],
          );
        },
      ),
    );
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
}

class SettingDropdown<T> extends StatefulWidget {
  final String title;
  final T value;
  final List<T> items;
  final Future<void> Function(T) onChanged;
  final Widget Function(T) itemBuilder;

  const SettingDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemBuilder,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SettingDropdownState<T> createState() => _SettingDropdownState<T>();
}

class _SettingDropdownState<T> extends State<SettingDropdown<T>> {
  bool _isChanging = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: CustomText(text: widget.title),
      trailing: _isChanging
          ? const CircularProgressIndicator()
          : DropdownButton<T>(
              dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
              value: widget.value,
              onChanged: (T? newValue) async {
                if (newValue != null) {
                  setState(() => _isChanging = true);
                  await widget.onChanged(newValue);
                  setState(() => _isChanging = false);
                }
              },
              items: widget.items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: widget.itemBuilder(item),
                );
              }).toList(),
            ),
    );
  }
}
