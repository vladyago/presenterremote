import 'package:flutter/material.dart';
import 'package:presenterremote/models/playlist.dart';

typedef NodeCallback = void Function(PlaylistTreeNode node);

class PlaylistsListView extends StatelessWidget {
  final List<PlaylistTreeNode> playlists;
  final NodeCallback onTap;
  final VoidCallback onGoBack;

  const PlaylistsListView({
    super.key,
    required this.playlists,
    required this.onTap,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final node = playlists[index];
            return ListTile(
              onTap: () => onTap(node),
              title: Text(node.id.name),
              // shape: LinearBorder.bottom(
              //   side: const BorderSide(
              //     color: Colors.grey,
              //     width: 1,
              //   ),
              // ),
            );
          }, childCount: playlists.length),
        ),
      ],
    );
  }
}
