import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:presenterremote/constants/routes.dart';

class ConnectView extends StatefulWidget {
  const ConnectView({super.key});

  @override
  State<ConnectView> createState() => _ConnectViewState();
}

class _ConnectViewState extends State<ConnectView> {
  late final TextEditingController _ipaddress;
  late final TextEditingController _port;

  @override
  void initState() {
    _ipaddress = TextEditingController();
    _port = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _ipaddress.dispose();
    _port.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to ProPresenter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
                'Please enter the ProPresenter IP address and port number'),
            TextField(
              controller: _ipaddress,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(hintText: 'Enter IP address'),
            ),
            TextField(
              controller: _port,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter port number'),
            ),
            TextButton(
              onPressed: () async {
                String ipaddress = _ipaddress.text;
                String port = _port.text;
                final response = await http
                    .get(Uri.parse('http://$ipaddress:$port/version'));
                if (response.statusCode == 200) {
                  // go to presentation
                  // goToPresentationScreen(ipaddress, port);
                  // go to choose a playlists & presentation
                  goToPlaylistView(ipaddress, port);
                } else {
                  throw Exception(response.statusCode);
                }
              },
              child: const Text('Connect'),
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
