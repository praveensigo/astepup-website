import 'dart:async';
import 'dart:html';
import 'package:get/get.dart';
import 'package:astepup_website/Utils/Utils.dart';

class AppMonitorController extends GetxController {
  final String _storageKey = 'totalHour';

  int _totalTime = 0;
  bool _isFocused = true;
  late Timer _timer;
  String token = '';

  @override
  void onInit() {
    token = getSavedObject('token') ?? '';
    super.onInit();
    _loadTotalTime();
    _setupEventListeners();
    _startTimer();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
  }

  Future<void> _loadTotalTime() async {
    int storedTime = await getSavedObject(_storageKey) ?? 0;
    _totalTime = storedTime + _totalTime;
  }

  void _setupEventListeners() {
    window.onBlur.listen((event) {
      _isFocused = false;
    });

    window.onFocus.listen((event) {
      _isFocused = true;
    });
  }

  void _saveTotalTime() async {
    await savename(_storageKey, _totalTime);
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_isFocused) {
        _totalTime++;
        _saveTotalTime();
      }
    });
  }

  int getTotalTime() {
    return _totalTime;
  }
}
