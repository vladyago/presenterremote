import 'package:flutter/material.dart';
import 'package:presenterremote/models/playlist.dart';
import 'package:presenterremote/services/presentation_service.dart';

class PlaylistItemsView extends StatefulWidget {
  const PlaylistItemsView({super.key});

  @override
  State<PlaylistItemsView> createState() => _PlaylistItemsViewState();
}

class _PlaylistItemsViewState extends State<PlaylistItemsView> {
  late final PresentationService _presentationService;
  late final PlaylistId _playlistId;
  late Future<Playlist> futurePlaylist;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    _presentationService = args['presentService'] as PresentationService;
    _playlistId = args['playlistId'] as PlaylistId;
    futurePlaylist = _presentationService.getPlaylist(_playlistId.uuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
      ),
      body: FutureBuilder<Playlist>(
        future: futurePlaylist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.items.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data!.items[index];
                  return ListTile(
                    onTap: () => {},
                    title: Text(item.id.name),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
