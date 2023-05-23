import 'package:http/http.dart';
import 'dart:convert';

class PresentationService {
  //List<Slide> _slides = [];

  List<Slide> getAllSlides() {
    final List<Slide> slides = [];

    slides.add(Slide(
        thumbnailUrl:
            'http://192.168.1.213:1025/v1/presentation/6886C856-CEB6-4893-AED3-98139F2EACC0/thumbnail/4?quality=400&thumbnail_type=jpeg',
        label: 'Matt. 1:1 (NIV)'));

    if (slides.isEmpty) {
      throw Exception();
    } else {
      return slides;
    }
  }
}

class Slide {
  Slide({
    required this.thumbnailUrl,
    required this.label,
  });

  final String thumbnailUrl;
  final String label;
}
