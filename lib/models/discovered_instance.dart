class DiscoveredInstance {
  final String ipAddress;
  final String port;
  final String name;

  DiscoveredInstance({
    required this.ipAddress,
    required this.port,
    required this.name,
  });

  String get fullAddress => '$ipAddress:$port';

  @override
  String toString() => '$name ($fullAddress)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoveredInstance &&
          runtimeType == other.runtimeType &&
          ipAddress == other.ipAddress &&
          port == other.port &&
          name == other.name;

  @override
  int get hashCode => ipAddress.hashCode ^ port.hashCode ^ name.hashCode;
}
