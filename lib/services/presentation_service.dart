import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:presenterremote/models/slide.dart';
import 'package:presenterremote/models/presentation.dart';

class PresentationService {
  //List<Slide> _slides = [];
  String _uuid = '';

  Future<List<AppSlide>> getPresentation(String uuid) async {
    final List<AppSlide> appSlides = [];
    final Presentation presentation;
    _uuid = uuid;

    final response = await http
        .get(Uri.parse('http://192.168.1.213:1025/v1/presentation/$uuid'));

    if (response.statusCode == 200) {
      presentation =
          Presentation.fromJson(jsonDecode(response.body)['presentation']);

      Slide slide;
      int slideIndex = 0;
      for (var i = 0; i < presentation.groups.length; i++) {
        for (var j = 0; j < presentation.groups[i].slides.length; j++) {
          slide = presentation.groups[i].slides[j];
          appSlides.add(
            AppSlide(
              enabled: slide.enabled,
              notes: slide.notes,
              text: slide.text,
              label: slide.label,
              index: slideIndex,
            ),
          );
          slideIndex++;
        }
      }
    } else {
      throw Exception('Failed to load presentation');
    }
    // slides.add(Slide(
    //     thumbnailUrl:
    //         'http://192.168.1.213:1025/v1/presentation/6886C856-CEB6-4893-AED3-98139F2EACC0/thumbnail/4?quality=400&thumbnail_type=jpeg',
    //     label: 'Matt. 1:1 (NIV)'));

    if (appSlides.isEmpty) {
      throw Exception();
    } else {
      return appSlides;
    }
  }

  Image getSlideThumbnail(int index) {
    return Image.network(
      'http://192.168.1.213:1025/v1/presentation/$_uuid/thumbnail/$index?quality=400&thumbnail_type=jpeg',
      fit: BoxFit.cover,
    );
  }
}

class AppSlide {
  AppSlide({
    required this.enabled,
    required this.notes,
    required this.text,
    required this.label,
    required this.index,
  });

  final bool enabled;
  final String notes;
  final String text;
  final String label;
  final int index;
}
