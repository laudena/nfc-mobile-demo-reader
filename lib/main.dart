import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LinkDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LinkDemo extends StatefulWidget {
  const LinkDemo({super.key});
  @override
  State<LinkDemo> createState() => _LinkDemoState();
}

class _LinkDemoState extends State<LinkDemo> {
  final _appLinks = AppLinks();
  static const _ch = MethodChannel('com.laudev.demo_reader/links');

  StreamSubscription<Uri>? _sub;
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;

  @override
  void initState() {
    super.initState();
    _initAppLinks();
    _initNativeBridge();
  }

  Future<void> _initAppLinks() async {
    try {
      final uri = await _appLinks.getInitialLink();
      debugPrint('AppLinks INITIAL: $uri');
      if (!mounted) return;
      setState(() => _initialUri = uri);
    } catch (e) {
      if (!mounted) return;
      setState(() => _err = e);
    }

    _sub?.cancel();
    _sub = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('AppLinks STREAM: $uri');
      setState(() => _latestUri = uri);
    }, onError: (e) {
      setState(() => _err = e);
    });
  }

  void _initNativeBridge() {
    _ch.setMethodCallHandler((call) async {
      if (call.method == 'link') {
        final s = call.arguments as String?;
        debugPrint('Native CHANNEL: $s');
        if (!mounted || s == null) return;
        final uri = Uri.tryParse(s);
        setState(() {
          // If initial is not set (cold start), fill it once
          _initialUri ??= uri;
          _latestUri = uri;
        });
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 16, color: Colors.black);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Deep Link Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: style,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('initial: ${_initialUri ?? "null"}'),
              const SizedBox(height: 8),
              Text('latest:  ${_latestUri ?? "null"}'),
              const SizedBox(height: 8),
              if (_err != null) Text('error:   $_err'),
            ],
          ),
        ),
      ),
    );
  }
}
