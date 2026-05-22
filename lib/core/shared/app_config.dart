class AppConfig {
  static const String appName = "CyberShield";

  static const String mongoUrl = "YOUR_MONGODB_URL";
  static const String mongoDbName = "cybershield";

  static const String mongoConnectionString = mongoUrl;
  static const String mongoDatabaseName = mongoDbName;
  static const String mongoCollectionName = "sms_history";

  static const String notificationChannelId = "cybershield_alerts";
  static const String notificationChannelName = "CyberShield Alerts";
  static const String notificationChannelDescription =
      "Alerts for suspicious SMS and cyber threats";
  static const String recentScansEndpoint = "";
}