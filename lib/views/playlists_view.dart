import 'package:flutter/material.dart';
import 'package:presenterremote/constants/routes.dart';
import 'package:presenterremote/constants/types.dart';
import 'package:presenterremote/models/playlist.dart';
import 'package:presenterremote/services/presentation_service.dart';
import 'package:presenterremote/views/playlists_list_view.dart';

class PlaylistsView extends StatefulWidget {
  const PlaylistsView({super.key});

  @override
  State<PlaylistsView> createState() => _PlaylistsViewState();
}

class _PlaylistsViewState extends State<PlaylistsView> {
  late final PresentationService _presentationService;
  late final String baseUrl;
  late Future<List<PlaylistTreeNode>> futurePlaylists;
  late List<PlaylistTreeNode> currList = List.empty(growable: true);
  late List<PlaylistTreeNode> parentList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPresentationService();
    futurePlaylists = _presentationService.getAllPlaylists();
  }

  void loadPresentationService() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String ipaddress = args['ipaddress'] as String;
    String port = args['port'] as String;
    baseUrl = '$ipaddress:$port';
    _presentationService = PresentationService(baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlists'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FutureBuilder<List<PlaylistTreeNode>>(
          future: futurePlaylists,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<PlaylistTreeNode>? rootList = snapshot.data!;
              if (currList.isEmpty) currList = rootList;
              return PlaylistsListView(
                playlists: currList,
                onTap: (node) {
                  if (node.fieldType == groupType) {
                    setState(() {
                      parentList = currList;
                      currList = node.children;
                    });
                  } else {
                    Navigator.of(context).pushNamed(
                      playlistItemsViewRoute,
                      arguments: {
                        'presentService': _presentationService,
                        'playlistId': node.id,
                      },
                    );
                  }
                },
                onGoBack: () {
                  setState(() {
                    currList = parentList;
                  });
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
