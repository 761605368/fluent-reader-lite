import 'package:fluent_reader_lite/models/feeds_model.dart';
import 'package:fluent_reader_lite/models/global_model.dart';
import 'package:fluent_reader_lite/models/groups_model.dart';
import 'package:fluent_reader_lite/models/items_model.dart';
import 'package:fluent_reader_lite/models/service.dart';
import 'package:fluent_reader_lite/models/services/feedbin.dart';
import 'package:fluent_reader_lite/models/services/fever.dart';
import 'package:fluent_reader_lite/models/services/greader.dart';
import 'package:fluent_reader_lite/models/sources_model.dart';
import 'package:fluent_reader_lite/models/sync_model.dart';
import 'package:fluent_reader_lite/utils/db.dart';
import 'package:fluent_reader_lite/utils/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:jaguar/serve/server.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

abstract class Global {
  static bool _initialized = false;
  static late GlobalModel globalModel;
  static late SourcesModel sourcesModel;
  static late ItemsModel itemsModel;
  static late FeedsModel feedsModel;
  static late GroupsModel groupsModel;
  static late SyncModel syncModel;
  static ServiceHandler? service;
  static late Database db;
  static late Jaguar server;
  static final GlobalKey<NavigatorState> tabletPanel = GlobalKey();

  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const String apiHost = String.fromEnvironment('API_HOST', 
    defaultValue: 'https://api.example.com');
  static const int apiVersion = int.fromEnvironment('API_VERSION', 
    defaultValue: 1);

  static String get environment {
    if (isProduction) return 'production';
    if (kDebugMode) return 'development';
    return 'staging';
  }

  static void init() {
    assert(!_initialized);
    _initialized = true;
    globalModel = GlobalModel();
    sourcesModel = SourcesModel();
    itemsModel = ItemsModel();
    feedsModel = FeedsModel();
    groupsModel = GroupsModel();
    final serviceType = SyncService.values[Store.sp.getInt(StoreKeys.SYNC_SERVICE) ?? 0];
    switch (serviceType) {
      case SyncService.None:
        break;
      case SyncService.Fever:
        service = FeverServiceHandler();
        break;
      case SyncService.Feedbin:
        service = FeedbinServiceHandler();
        break;
      case SyncService.GReader:
      case SyncService.Inoreader:
        service = GReaderServiceHandler();
        break;
    }
    syncModel = SyncModel();
    _initContents();
  }

  static void _initContents() async {
    db = await DatabaseHelper.getDatabase();
    await db.delete(
      "items",
      where: "date < ? AND starred = 0",
      whereArgs: [
        DateTime.now()
          .subtract(Duration(days: globalModel.keepItemsDays))
          .millisecondsSinceEpoch,
      ],
    );
    server = Jaguar(address: "127.0.0.1",port: 9000);
    server.addRoute(serveFlutterAssets());
    await server.serve();
    await sourcesModel.init();
    await feedsModel.all.init();
    if (globalModel.syncOnStart) await syncModel.syncWithService();
  }

  static Brightness currentBrightness(BuildContext context) {
    return globalModel.getBrightness() ?? MediaQuery.of(context).platformBrightness;
  }

  static bool get isTablet => tabletPanel.currentWidget != null;

  static NavigatorState responsiveNavigator(BuildContext context) {
    return tabletPanel.currentWidget != null
      ? Global.tabletPanel.currentState!
      : Navigator.of(context, rootNavigator: true);
  }
}