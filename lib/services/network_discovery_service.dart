import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:presenterremote/models/discovered_instance.dart';
import 'package:presenterremote/services/port_preferences_service.dart';

class NetworkDiscoveryService {
  final NetworkInfo _networkInfo = NetworkInfo();
  final PortPreferencesService _portPreferences = PortPreferencesService();
  static const int _scanTimeoutSeconds = 2;
  static const int _maxConcurrentScans = 20;

  /// Get the local IP address of the device
  Future<String?> getLocalIpAddress() async {
    try {
      final wifiIP = await _networkInfo.getWifiIP();
      if (wifiIP != null && wifiIP.isNotEmpty) {
        return wifiIP;
      }
      // Fallback: try to get IP from network interfaces
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 &&
              !addr.isLoopback &&
              (addr.address.startsWith('192.168.') ||
                  addr.address.startsWith('10.') ||
                  addr.address.startsWith('172.'))) {
            return addr.address;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Calculate subnet from IP address (assumes /24 subnet)
  List<String> _generateSubnetIps(String ipAddress) {
    final parts = ipAddress.split('.');
    if (parts.length != 4) return [];

    final baseIp = '${parts[0]}.${parts[1]}.${parts[2]}';
    final ips = <String>[];
    for (int i = 1; i <= 254; i++) {
      ips.add('$baseIp.$i');
    }
    return ips;
  }

  /// Test if a ProPresenter instance is available at the given IP and port
  Future<DiscoveredInstance?> _testProPresenterInstance(
      String ipAddress, String port) async {
    try {
      final uri = Uri.parse('http://$ipAddress:$port/version');
      final response =
          await http.get(uri).timeout(Duration(seconds: _scanTimeoutSeconds));
      if (response.statusCode == 200) {
        final name = jsonDecode(response.body)['name'];
        return DiscoveredInstance(ipAddress: ipAddress, port: port, name: name);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Scan the network for ProPresenter instances
  /// Returns a list of discovered instances
  Future<List<DiscoveredInstance>> scanNetwork({
    Function(int current, int total)? onProgress,
  }) async {
    final discoveredInstances = <DiscoveredInstance>[];
    final localIp = await getLocalIpAddress();

    if (localIp == null) {
      return discoveredInstances;
    }

    final subnetIps = _generateSubnetIps(localIp);
    final portsToScan = await _portPreferences.getPortsToScan();

    // Create all IP:Port combinations
    final scanTargets = <Map<String, String>>[];
    for (final ip in subnetIps) {
      for (final port in portsToScan) {
        scanTargets.add({'ip': ip, 'port': port});
      }
    }

    int completed = 0;
    final total = scanTargets.length;

    // Scan with concurrency limit using Future.wait with chunks
    for (int i = 0; i < scanTargets.length; i += _maxConcurrentScans) {
      final chunk = scanTargets.skip(i).take(_maxConcurrentScans);
      final chunkFutures = chunk.map((target) async {
        try {
          final instance = await _testProPresenterInstance(
            target['ip']!,
            target['port']!,
          );
          if (instance != null) {
            // Avoid duplicates
            if (!discoveredInstances.any((i) =>
                i.ipAddress == instance.ipAddress && i.port == instance.port)) {
              discoveredInstances.add(instance);
            }
          }
        } catch (e) {
          // Ignore errors, just continue
        } finally {
          completed++;
          onProgress?.call(completed, total);
        }
      });

      await Future.wait(chunkFutures);
    }

    return discoveredInstances;
  }

  /// Cancel ongoing scan (if needed in future)
  void cancelScan() {
    // Implementation for cancellation if needed
  }
}
