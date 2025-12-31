import 'dart:developer' as dev;

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
  late Future<Stream<Map<String, dynamic>>?> futureStatus;
  late Future<Stream<Map<String, dynamic>>?> futureSlideIndex;
  bool _isInitialized = false;
  String? presId;
  int? slideIndex;
  bool slideLayer = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
      _presentationService = args['presentService'] as PresentationService;
      presentationId = args['itemId'] as String;
      futurePresentation = _presentationService.getPresentation(presentationId);
      futureStatus = _presentationService
          .getStatusUpdates(['presentation/slide_index', 'status/layers']);
      futureSlideIndex = _presentationService.getSlideIndexStream();
      _isInitialized = true;
    }
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
            body: FutureBuilder<Stream<Map<String, dynamic>>?>(
              future: futureSlideIndex, //futureStatus,
              builder: (context, streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return StreamBuilder<Map<String, dynamic>>(
                    stream: streamSnapshot.data,
                    builder: (context, slideIndexSnapshot) {
                      if (slideIndexSnapshot.hasData) {
                        dev.log(
                            'slideIndexSnapshot: ${slideIndexSnapshot.data}',
                            name: 'PresentationView');
                        // if (slideIndexSnapshot.data!['url'] ==
                        //     'presentation/slide_index') {
                        // if (slideIndexSnapshot.data!['presentation_index'] !=
                        //     null) {
                        presId = slideIndexSnapshot.data!['presentation_index']
                            ?['presentation_id']?['uuid'];
                        slideIndex = slideIndexSnapshot
                            .data!['presentation_index']?['index'];
                        // }
                        dev.log('slideIndex: $slideIndex | presId: $presId',
                            name: 'PresentationView');
                        // }
                        // if (statusSnapshot.data!['url'] == 'status/layers') {
                        //   slideLayer =
                        //       statusSnapshot.data!['data']['slide'] as bool;
                        //   dev.log('slideLayer: $slideLayer',
                        //       name: 'PresentationView');
                        // }
                      }
                      return Center(
                        child: GridView.count(
                          padding: const EdgeInsets.all(10),
                          crossAxisCount: 2,
                          childAspectRatio: 1.78,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: snapshot.data!.map<Widget>((slide) {
                            return Material(
                              shape: RoundedRectangleBorder(
                                  side: presId == presentationId &&
                                          slideIndex == slide.index
                                      ? const BorderSide(
                                          color: Colors.orange,
                                          width: 6.0,
                                        )
                                      : BorderSide(
                                          color: slide.groupColor.toColor(),
                                          width: 1.0,
                                        ),
                                  borderRadius: BorderRadius.circular(1)),
                              clipBehavior: Clip.antiAlias,
                              child: _GridSlideItem(
                                slide: slide,
                                presentationService: _presentationService,
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                }
                if (streamSnapshot.hasError) {
                  dev.log('Error loading slide index: ${streamSnapshot.error}',
                      name: 'PresentationView', error: streamSnapshot.error);
                  return const Text(
                    'Error loading slide index',
                    style: TextStyle(color: Colors.red),
                  );
                }
                return const RefreshProgressIndicator();
              },
            ),
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
      {required this.slide, required this.presentationService});

  final AppSlide slide;
  final PresentationService presentationService;

  @override
  Widget build(BuildContext context) {
    final Widget image = Semantics(
      label: slide.label,
      enabled: slide.enabled,
      child: Material(
        shape: const RoundedRectangleBorder(),
        clipBehavior: Clip.antiAlias,
        child: presentationService.getSlideThumbnail(slide.index),
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
