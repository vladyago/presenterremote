import 'package:flutter/material.dart';
import 'package:presenterremote/constants/routes.dart';
import 'package:presenterremote/constants/types.dart';
import 'package:presenterremote/models/playlist.dart';
import 'package:presenterremote/services/presentation_service.dart';

class PlaylistItemsView extends StatefulWidget {
  const PlaylistItemsView({super.key});

  @override
  State<PlaylistItemsView> createState() => _PlaylistItemsViewState();
}

class _PlaylistItemsViewState extends State<PlaylistItemsView> {
  late PresentationService _presentationService;
  late PlaylistId _playlistId;
  late Future<Playlist> futurePlaylist;

  @override
  void initState() {
    super.initState();
  }

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
        title: Text(_playlistId.name),
      ),
      body: FutureBuilder<Playlist>(
        future: futurePlaylist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.items.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data!.items[index];
                  if (item.type == presentationType) {
                    return ListTile(
                      onTap: () => goToPresentationScreen(
                        item.presentationInfo?.presentationUuid ?? '',
                      ),
                      title: Text(item.id.name),
                    );
                  } else if (item.type == headerType) {
                    return ListTile(
                      onTap: () => {},
                      title: Text(
                        item.id.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      tileColor: item.headerColor?.toColor().withOpacity(0.1),
                    );
                  } else {
                    return ListTile(
                      onTap: () => {},
                      title: Text(item.id.name),
                    );
                  }
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  void goToPresentationScreen(String presentationId) {
    Navigator.of(context).pushNamed(
      presentationViewRoute,
      arguments: {
        'presentService': _presentationService,
        'itemId': presentationId,
      },
    );
  }
}
