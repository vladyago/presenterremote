import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:presenterremote/models/slide.dart';
import 'package:presenterremote/models/presentation.dart';
// import 'package:propresenter_api/propresenter_api.dart';

class PresentationService {
  //List<Slide> _slides = [];
  String _uuid = '';
  final String _baseUrl;
  // var api = ProApiClient(
  //     ProSettings(version: ProVersion.seven9, host: 'localhost', port: 60157));

  PresentationService(this._baseUrl);

  Uri _makeUri(String path, {Map<String, dynamic>? params}) {
    return Uri.http(_baseUrl, path, params);
  }

  Future<List<AppSlide>> getPresentation(String uuid) async {
    final List<AppSlide> appSlides = [];
    final Presentation presentation;
    _uuid = uuid;

    final response =
        await http.get(Uri.parse('$_baseUrl/v1/presentation/$uuid'));

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

    if (appSlides.isEmpty) {
      throw Exception();
    } else {
      return appSlides;
    }
  }

  Image getSlideThumbnail(int index) {
    return Image.network(
      '$_baseUrl/v1/presentation/$_uuid/thumbnail/$index?quality=400&thumbnail_type=jpeg',
      fit: BoxFit.cover,
    );
  }

  Future<Stream<Map<String, dynamic>>?> getSlideIndexStream() async {
    String url = '/v1/presentation/slideIndex';

    // return api.callStream(
    //     'get', url);
    return callStream('get', url, params: {'chunked': 'true'});
  }

  void triggerSlide(int index) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/v1/presentation/$_uuid/$index/trigger'));

    if (response.statusCode != 204) {
      throw Exception('Failed to trigger slide');
    }
  }

  Future<Stream<Map<String, dynamic>>?> callStream(String verb, String path,
      {Map<String, dynamic>? params, Object? data}) async {
    var uri = _makeUri(path, params: params);

    // setup a manual request to manage streaming
    var client = http.Client();
    var verb = data == null ? 'GET' : 'POST';
    var r = http.Request(verb, uri);
    r.headers['content-type'] = 'application/json';
    if (data is String) {
      r.body = data;
    } else if (data != null) {
      r.body = json.encode(data);
    }

    var res = await client.send(r);

    // if successful, create a stream of Json Objects
    if (res.statusCode > 199 && res.statusCode < 300) {
      /// propresenter might close this connection prematurely.
      /// we want to catch it.
      try {
        var sc = StreamController<Map<String, dynamic>>();
        var accum = '';
        var bodyListener = res.stream.listen((e) {
          accum += utf8.decode(e);
          var chunks = accum.split('\r\n\r\n');
          // if the received data ended with \r\n\r\n, the last chunk will be empty
          // if it didn't end with \r\n\r\n, then we want to leave it in the accumulator
          accum = chunks.removeLast();
          for (var chunk in chunks) {
            try {
              var decoded = json.decode(chunk);
              // print(decoded);
              sc.add({...decoded});
            } catch (e) {
              // print('JSON ERROR: $e');
            }
          }
        });

        // cleanup stream when the server has stopped sending data
        bodyListener.onDone(() {
          sc.isClosed ? null : sc.close();
        });

        // close http connection when the listener to the stream cancels
        sc.onCancel = () {
          bodyListener.cancel();
          client.close();
        };
        return sc.stream;
      } on http.ClientException catch (e) {
        debug(e);
        return null;
      }
    } else {
      // we had an error of some kind, but we used a streaming request
      // so we wait until all the response data has arrived before throwing
      // the error.
      var err = await _awaitBody(res.stream).timeout(const Duration(seconds: 2),
          onTimeout: () => '"stream timeout"');
      if (err != 'stream timeout' &&
          res.headers['content-type'] == 'application/json') {
        throw http.ClientException(json.decode(err));
      }
      throw http.ClientException(err);
    }
    // return null;
  }

  Future<String> _awaitBody(http.ByteStream s) {
    var accum = <int>[];
    var completer = Completer<String>();
    s.listen((bytes) => accum.addAll(bytes)).onDone(() {
      completer.complete(utf8.decode(accum));
    });
    return completer.future;
  }

  void debug(http.ClientException e) {
    // Maybe implement
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
