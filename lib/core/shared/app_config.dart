class AppConfig {
  static const String appName = "CyberShield";

  static const String mongoUrl =
      "mongodb+srv://cybershield:cybershield%402027@cybershield-cluster.kki4hip.mongodb.net/cybershield?retryWrites=true&w=majority&appName=cybershield-cluster";

  static const String mongoDbName = "cybershield";

  static const String mongoConnectionString = mongoUrl;
  static const String mongoDatabaseName = mongoDbName;
  static const String mongoCollectionName = "sms_detections";

  static const String notificationChannelId = "cybershield_alerts";
  static const String notificationChannelName = "CyberShield Alerts";
  static const String notificationChannelDescription =
      "Alerts for suspicious SMS and cyber threats";

  static const String recentScansEndpoint = "";
}