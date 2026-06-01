import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:cyber_shield/core/shared/app_config.dart';

class HistoryService {
  static const String _collectionName = "link_scans";

  static Future<void> saveScan({
  required String url,
  required String status,
  required int riskScore,
}) async {
  Db? db;

  try {
    debugPrint("[HistoryService] saveScan called");
    debugPrint("[HistoryService] URL: $url");
    debugPrint("[HistoryService] Status: $status");
    debugPrint("[HistoryService] Risk Score: $riskScore");
    debugPrint("[HistoryService] Mongo URL empty: ${AppConfig.mongoConnectionString.isEmpty}");

    db = await Db.create(AppConfig.mongoConnectionString);
    debugPrint("[HistoryService] DB created");

    await db.open();
    debugPrint("[HistoryService] DB opened");

    final collection = db.collection(_collectionName);
    debugPrint("[HistoryService] Collection: $_collectionName");

    final result = await collection.insertOne({
      "_id": ObjectId(),
      "url": url,
      "status": status,
      "riskScore": riskScore,
      "scannedAt": DateTime.now().toUtc(),
    });

    debugPrint("[HistoryService] Insert success: ${result.isSuccess}");
    debugPrint("[HistoryService] Insert document id: ${result.id}");
  } catch (e, stackTrace) {
    debugPrint("[HistoryService] Save Error: $e");
    debugPrint("[HistoryService] Save StackTrace: $stackTrace");
  } finally {
    await db?.close();
    debugPrint("[HistoryService] DB closed");
  }
}
  static Future<List<dynamic>> getHistory() async {
    Db? db;

    try {
      debugPrint("[HistoryService] getHistory called");

      db = await Db.create(AppConfig.mongoConnectionString);
      await db.open();

      final collection = db.collection(_collectionName);

      final history = await collection
          .find(where.sortBy("scannedAt", descending: true))
          .toList();

      debugPrint("[HistoryService] History Count: ${history.length}");

      return history;
    } catch (e) {
      debugPrint("[HistoryService] History Error: $e");
      return [];
    } finally {
      await db?.close();
    }
  }
}