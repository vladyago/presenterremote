import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:presenterremote/constants/routes.dart';
import 'package:presenterremote/models/discovered_instance.dart';
import 'package:presenterremote/services/network_discovery_service.dart';
import 'package:presenterremote/services/port_preferences_service.dart';

class ConnectView extends StatefulWidget {
  const ConnectView({super.key});

  @override
  State<ConnectView> createState() => _ConnectViewState();
}

class _ConnectViewState extends State<ConnectView> {
  late final TextEditingController _ipaddress;
  late final TextEditingController _port;
  final NetworkDiscoveryService _discoveryService = NetworkDiscoveryService();
  final PortPreferencesService _portPreferences = PortPreferencesService();

  bool _isScanning = false;
  List<DiscoveredInstance> _discoveredInstances = [];
  String? _scanError;
  int _scanProgress = 0;
  int _scanTotal = 0;

  @override
  void initState() {
    _ipaddress = TextEditingController();
    _port = TextEditingController(text: PortPreferencesService.defaultPort);
    super.initState();
    // Start automatic scanning when view loads
    _startScanning();
  }

  @override
  void dispose() {
    _ipaddress.dispose();
    _port.dispose();
    super.dispose();
  }

  Future<void> _startScanning() async {
    setState(() {
      _isScanning = true;
      _discoveredInstances = [];
      _scanError = null;
      _scanProgress = 0;
      _scanTotal = 0;
    });

    try {
      final instances = await _discoveryService.scanNetwork(
        onProgress: (current, total) {
          if (mounted) {
            setState(() {
              _scanProgress = current;
              _scanTotal = total;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _isScanning = false;
          _discoveredInstances = instances;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _scanError = 'Failed to scan network: $e';
        });
      }
    }
  }

  Future<void> _connectToInstance(
      String ipAddress, String port, bool isManual) async {
    try {
      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final response =
          await http.get(Uri.parse('http://$ipAddress:$port/version'));

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }

      if (response.statusCode == 200) {
        // Save port to preferred ports if manually connected with non-default port
        if (isManual && port != PortPreferencesService.defaultPort) {
          await _portPreferences.addPreferredPort(port);
        }
        // Navigate to playlist view
        goToPlaylistView(ipAddress, port);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Connection failed: ${response.statusCode}'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog if still open
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection error: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to ProPresenter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isScanning ? null : _startScanning,
            tooltip: 'Rescan network',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Discovered instances section
            if (_isScanning) ...[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 16),
                    Text('Scanning for ProPresenter instances...'),
                  ],
                ),
              ),
              if (_scanTotal > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: LinearProgressIndicator(
                    value: _scanProgress / _scanTotal,
                  ),
                ),
            ] else if (_scanError != null) ...[
              Card(
                color: Colors.red.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        _scanError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _startScanning,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (_discoveredInstances.isNotEmpty) ...[
              const Text(
                'Discovered ProPresenter Instances:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ..._discoveredInstances.map((instance) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.computer),
                      title: Text(instance.name),
                      subtitle: Text(
                          'IP: ${instance.ipAddress} Port: ${instance.port}'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => _connectToInstance(
                        instance.ipAddress,
                        instance.port,
                        false,
                      ),
                    ),
                  )),
              const Divider(height: 32),
            ] else ...[
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No ProPresenter instances found on the network.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Manual connection section
            const Text(
              'Manual Connection',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter the ProPresenter IP address and port number',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ipaddress,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                hintText: 'Enter IP address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _port,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText:
                    'Enter port number (default: ${PortPreferencesService.defaultPort})',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final ipaddress = _ipaddress.text.trim();
                final port = _port.text.trim().isEmpty
                    ? PortPreferencesService.defaultPort
                    : _port.text.trim();
                if (ipaddress.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter an IP address'),
                    ),
                  );
                  return;
                }
                _connectToInstance(ipaddress, port, true);
              },
              child: const Text('Connect Manually'),
            ),
          ],
        ),
      ),
    );
  }

  void goToPresentationScreen(String ipAddress, String port) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      presentationViewRoute,
      (route) => false,
      arguments: {
        'ipaddress': ipAddress,
        'port': port,
      },
    );
  }

  void goToPlaylistView(String ipAddress, String port) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      playlistsViewRoute,
      (route) => false,
      arguments: {
        'ipaddress': ipAddress,
        'port': port,
      },
    );
  }
}
