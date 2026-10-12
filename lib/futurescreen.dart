import 'package:flutter/material.dart';
import 'api_service.dart';
import 'catfact.dart';

// SCREEN 1: loads data ONCE using FutureBuilder.
class FutureScreen extends StatefulWidget {
  const FutureScreen({super.key});

  @override
  State<FutureScreen> createState() => _FutureScreenState();
}

class _FutureScreenState extends State<FutureScreen> {
  final _api = ApiService();
  late Future<List<CatFact>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.fetchFacts(); // fetched once, here (not in build)
  }

  void _retry() {
    setState(() {
      _future = _api.fetchFacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CatFact>>(
      future: _future,
      builder: (context, snapshot) {
        // 1. Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Error -> message + Retry button
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off, size: 48),
                const SizedBox(height: 8),
                const Text('Could not load facts.'),
                const SizedBox(height: 8),
                ElevatedButton(onPressed: _retry, child: const Text('Retry')),
              ],
            ),
          );
        }

        // 3. Empty
        final facts = snapshot.data ?? [];
        if (facts.isEmpty) {
          return const Center(child: Text('No facts to show.'));
        }

        // 4. Real data
        return ListView.builder(
          itemCount: facts.length,
          itemBuilder: (context, i) => ListTile(
            leading: const Icon(Icons.pets),
            title: Text(facts[i].fact),
            subtitle: Text('${facts[i].length} characters'),
          ),
        );
      },
    );
  }
}
