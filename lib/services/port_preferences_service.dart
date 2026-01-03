import 'package:shared_preferences/shared_preferences.dart';

class PortPreferencesService {
  static const String _preferredPortsKey = 'preferred_ports';
  static const String _defaultPort = '50001';

  /// Get the default ProPresenter port
  static String get defaultPort => _defaultPort;

  /// Get list of preferred ports (excluding default port)
  Future<List<String>> getPreferredPorts() async {
    final prefs = await SharedPreferences.getInstance();
    final portsString = prefs.getString(_preferredPortsKey);
    if (portsString == null || portsString.isEmpty) {
      return [];
    }
    return portsString.split(',').where((p) => p.isNotEmpty).toList();
  }

  /// Add a port to the preferred ports list (if not already default)
  Future<void> addPreferredPort(String port) async {
    if (port == _defaultPort) {
      return; // Don't save default port
    }
    final prefs = await SharedPreferences.getInstance();
    final currentPorts = await getPreferredPorts();
    if (!currentPorts.contains(port)) {
      currentPorts.add(port);
      await prefs.setString(_preferredPortsKey, currentPorts.join(','));
    }
  }

  /// Get all ports to scan (preferred ports first, then default)
  Future<List<String>> getPortsToScan() async {
    final preferredPorts = await getPreferredPorts();
    return [...preferredPorts, _defaultPort];
  }
}

