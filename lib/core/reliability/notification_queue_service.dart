class NotificationQueueService<T> {
  final List<T> _queue = [];

  final Future<void> Function(T item)? onProcess;

  NotificationQueueService({this.onProcess});

  Future<bool> enqueue(T item) async {
    _queue.add(item);

    if (onProcess != null) {
      await onProcess!(item);
    }

    return true;
  }

  Future<void> processPending() async {
    while (_queue.isNotEmpty) {
      final item = _queue.removeAt(0);
      if (onProcess != null) {
        await onProcess!(item);
      }
    }
  }

  void dispose() {
    _queue.clear();
  }
}