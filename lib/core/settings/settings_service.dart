class AppSettings {
  bool protectionEnabled;
  bool notificationsEnabled;
  bool autoSyncEnabled;
  bool mongoAutoSyncEnabled;

  AppSettings({
    this.protectionEnabled = true,
    this.notificationsEnabled = true,
    this.autoSyncEnabled = true,
    this.mongoAutoSyncEnabled = true,
  });
}

class SettingsService {
  AppSettings settings = AppSettings();

  final List<void Function()> _listeners = [];

  Future<void> initialize() async {}

  bool isAppEnabled() {
    return settings.protectionEnabled;
  }

  void setProtectionEnabled(bool value) {
    settings.protectionEnabled = value;
    _notify();
  }

  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  void _notify() {
    for (final listener in _listeners) {
      listener();
    }
  }
}