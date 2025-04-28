import 'package:flutter/material.dart';
import 'package:presenterremote/constants/routes.dart';
import 'package:presenterremote/views/connect_view.dart';
import 'package:presenterremote/views/playlist_items_view.dart';
import 'package:presenterremote/views/playlists_view.dart';
import 'package:presenterremote/views/presentation_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presenter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
        ),
      ),
      home: const HomePage(),
      routes: {
        connectViewRoute: (context) => const ConnectView(),
        presentationViewRoute: (context) => const PresentationView(),
        playlistsViewRoute: (context) => const PlaylistsView(),
        playlistItemsViewRoute: (context) => const PlaylistItemsView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConnectView();
  }
}
