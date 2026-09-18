import 'package:flutter/foundation.dart';

import '../model/activity_model.dart';
import '../service/esp32_service.dart';
import '../data/activity_data.dart';

class ActivityListViewModel extends ChangeNotifier {
  ActivityListViewModel({
    Esp32Service? esp32Service,
  }) : _esp32Service = esp32Service ?? Esp32Service();

  final Esp32Service _esp32Service;

  List<ActivityModel> _activities = [];

  bool _isSending = false;
  String? _errorMessage;

  List<ActivityModel> get activities => _activities;

  bool get isSending => _isSending;

  String? get errorMessage => _errorMessage;

  void loadActivities(int selectedClass) {
    _activities = ActivityData.getActivities(selectedClass);
    _errorMessage = null;

    notifyListeners();
  }

  Future<bool> sendActivity(ActivityModel activity) async {
    _isSending = true;
    _errorMessage = null;

    notifyListeners();

    final error = await _esp32Service.sendBin(
      activity.binAsset,
    );

    _isSending = false;

    if (error != null) {
      _errorMessage = 'Failed: $error';
    }

    notifyListeners();

    return error == null;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _esp32Service.dispose();
    super.dispose();
  }
}
