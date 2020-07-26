// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show VideoElement;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() {
  final String src =
      'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_30MB.mp4';
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
          child: WebVideoElement(src: src),
        ),
      ),
    ),
  );
}

class WebVideoElement extends StatefulWidget {
  WebVideoElement({Key key, this.src}) : super(key: key);

  final String src;

  @override
  _WebVideoElementState createState() => _WebVideoElementState();
}

class _WebVideoElementState extends State<WebVideoElement> {
  VideoElement video;

  double _width = 0;
  double _heigth = 0;

  final String _iosVideoAutoplayElement = 'playsinline';

  @override
  void initState() {
    super.initState();
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(widget.src, (int viewId) {
      video = VideoElement()
        ..src = widget.src
        ..controls = false
        ..autoplay = true
        ..loop = true
        ..muted = true;

      video
        ..onEnded.listen((event) {
          Navigator.pop(context, true);
        });

      video
        ..onLoadedData.listen((event) {
          _width = video.videoWidth.toDouble();
          debugPrint("width: ${video.videoWidth}");
          _heigth = video.videoHeight.toDouble();
          debugPrint("heigth: ${video.videoHeight}");
        });

      // Attribute is necessary in order to enable auto play on iPhone devices.
      video.attributes[_iosVideoAutoplayElement] = '';

      return video;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: _width,
          height: _heigth,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            // Use the VideoPlayer widget to display the video.
            child: HtmlElementView(viewType: widget.src),
          ),
        ),
      ),
    );
  }
}
