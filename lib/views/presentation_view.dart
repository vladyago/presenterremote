import 'package:flutter/material.dart';
import 'package:presenterremote/services/presentation_service.dart';

class PresentationView extends StatefulWidget {
  const PresentationView({Key? key}) : super(key: key);

  @override
  State<PresentationView> createState() => _PresentationViewState();
}

class _PresentationViewState extends State<PresentationView> {
  late final PresentationService _presentationService;
  late Future<List<AppSlide>> futurePresentation;

  @override
  void initState() {
    _presentationService = PresentationService();
    super.initState();
    futurePresentation = _presentationService
        .getPresentation('6886C856-CEB6-4893-AED3-98139F2EACC0');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Presentation Screen'),
      ),
      body: Center(
        child: FutureBuilder<List<AppSlide>>(
          future: futurePresentation,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.78,
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
        shape: RoundedRectangleBorder(
            side: const BorderSide(), borderRadius: BorderRadius.circular(1)),
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
