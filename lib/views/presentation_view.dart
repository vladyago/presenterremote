import 'package:flutter/material.dart';
import 'package:presenterremote/services/presentation_service.dart';

class PresentationView extends StatefulWidget {
  const PresentationView({super.key});

  @override
  State<PresentationView> createState() => _PresentationViewState();
}

class _PresentationViewState extends State<PresentationView> {
  late final PresentationService _presentationService;
  late Future<List<AppSlide>> futurePresentation;
  late final String baseUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    _presentationService = args['presentService'] as PresentationService;
    String presentationId = args['itemId'] as String;
    // loadPresentationService();
    futurePresentation = _presentationService.getPresentation(presentationId);
  }

  // void loadPresentationService() {
  //   final args =
  //       ModalRoute.of(context)!.settings.arguments as Map<String, String>;
  //   String ipaddress = args['ipaddress'] as String;
  //   String port = args['port'] as String;
  //   baseUrl = '$ipaddress:$port';
  //   _presentationService = PresentationService(baseUrl);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presentation Screen'),
      ),
      body: Center(
        child: FutureBuilder<List<AppSlide>>(
          future: futurePresentation,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                padding: const EdgeInsets.all(10),
                crossAxisCount: 2,
                childAspectRatio: 1.78,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: snapshot.data!.map<Widget>((slide) {
                  return _GridSlideItem(
                    slide: slide,
                    presentationService: _presentationService,
                  );
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
      backgroundColor: Colors.black,
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
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
          ),
          clipBehavior: Clip.antiAlias,
          child: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(slide.label),
          ),
        ),
        child: image,
      ),
    );
  }
}
