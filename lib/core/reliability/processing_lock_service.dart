class ProcessingLockService {
  ProcessingLockService._();

  static final ProcessingLockService instance = ProcessingLockService._();

  bool _locked = false;

  Future<T> runExclusive<T>(Future<T> Function() action) async {
    if (_locked) {
      throw Exception("Another process is already running");
    }

    _locked = true;
    try {
      return await action();
    } finally {
      _locked = false;
    }
  }
}