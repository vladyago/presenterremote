import 'package:flutter/material.dart';
import 'package:presenterremote/services/presentation_service.dart';

class PresentationView extends StatefulWidget {
  const PresentationView({super.key});

  @override
  State<PresentationView> createState() => _PresentationViewState();
}

class _PresentationViewState extends State<PresentationView> {
  late final PresentationService _presentationService;
  late final String presentationId;
  late Future<List<AppSlide>> futurePresentation;

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
    presentationId = args['itemId'] as String;
    futurePresentation = _presentationService.getPresentation(presentationId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppSlide>>(
      future: futurePresentation,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_presentationService.getPresentationName()),
              actions: [
                PopupMenuButton(
                  icon: const Icon(Icons.layers_clear),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: const Text('Clear Slide'),
                        onTap: () {
                          _presentationService.clearSlideLayer();
                        },
                      ),
                      PopupMenuItem(
                        child: const Text('Clear Media'),
                        onTap: () {
                          _presentationService.clearMediaLayer();
                        },
                      ),
                      PopupMenuItem(
                        child: const Text('Clear All'),
                        onTap: () {
                          _presentationService.clearAll();
                        },
                      ),
                    ];
                  },
                )
              ],
            ),
            body: Center(
              child: GridView.count(
                padding: const EdgeInsets.all(10),
                crossAxisCount: 2,
                childAspectRatio: 1.78,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: snapshot.data!.map<Widget>((slide) {
                  return _GridSlideItem(
                    slide: slide,
                    presentationService: _presentationService,
                    presentationId: presentationId,
                  );
                }).toList(),
              ),
            ),
            backgroundColor: Colors.black,
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Presentation Screen'),
            ),
            body: Center(
              child: Text(
                '${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Presentation Screen'),
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class _GridSlideItem extends StatelessWidget {
  const _GridSlideItem(
      {required this.slide,
      required this.presentationService,
      required this.presentationId});

  final AppSlide slide;
  final PresentationService presentationService;
  final String presentationId;

  @override
  Widget build(BuildContext context) {
    final Widget image = Semantics(
      label: slide.label,
      enabled: slide.enabled,
      child: FutureBuilder<Stream<Map<String, dynamic>>?>(
        future: presentationService.getSlideIndexStream(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.hasData) {
            return StreamBuilder<Map<String, dynamic>>(
              stream: streamSnapshot.data,
              builder: (context, snapshot) {
                return Material(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: snapshot.hasData &&
                                snapshot.data!['presentation_index'] != null &&
                                snapshot.data!['presentation_index']
                                        ['presentation_id']['uuid'] ==
                                    presentationId &&
                                snapshot.data!['presentation_index']['index'] ==
                                    slide.index
                            ? Colors.orange
                            : Colors.black,
                        width: 6.0,
                      ),
                      borderRadius: BorderRadius.circular(1)),
                  clipBehavior: Clip.antiAlias,
                  child: presentationService.getSlideThumbnail(slide.index),
                );
              },
            );
          }
          if (streamSnapshot.hasError) {
            return const Text('Error loading slide index');
          }
          return const CircularProgressIndicator();
        },
      ),
    );

    return GestureDetector(
      onTap: () => presentationService.triggerSlide(slide.index),
      child: GridTile(
        footer: Material(
          color: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(1)),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 32,
            child: GridTileBar(
              backgroundColor: slide.groupColor.toColor().withOpacity(0.7),
              title: Text(slide.label),
            ),
          ),
        ),
        child: image,
      ),
    );
  }
}
