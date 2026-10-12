import 'dart:async';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'catfact.dart';

// SCREEN 2: a new random fact every 5 seconds using StreamBuilder.
class StreamScreen extends StatefulWidget {
  const StreamScreen({super.key});

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  final _api = ApiService();
  final _controller = StreamController<CatFact>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load(); // first fact right away
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _load());
  }

  Future<void> _load() async {
    try {
      final fact = await _api.fetchRandomFact();
      if (!_controller.isClosed) _controller.add(fact);
    } catch (e) {
      // Send the error into the stream. The stream stays ALIVE,
      // so the next tick can still succeed.
      if (!_controller.isClosed) _controller.addError(e);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CatFact>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        // Error state (shows while the latest fetch failed)
        if (snapshot.hasError) {
          return const Center(
            child: Text('Connection problem. Trying again in 5 seconds...'),
          );
        }

        // Loading state (before the first data)
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Live data
        final fact = snapshot.data!;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pets, size: 48),
                const SizedBox(height: 16),
                Text(
                  fact.fact,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text('${fact.length} characters'),
                const SizedBox(height: 16),
                const Text('Updates every 5 seconds'),
              ],
            ),
          ),
        );
      },
    );
  }
}
