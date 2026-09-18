import 'package:flutter/material.dart';

class ShapeDrawingPage extends StatelessWidget {
  const ShapeDrawingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shape Drawing'),
      ),
      body: const Center(
        child: Text(
          'Shape Drawing Activity',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
class MeasurementPage extends StatelessWidget {
  const MeasurementPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Measurement')),
      body: const Center(child: Text('Measurement Activity')),
    );
  }
}

class AudioPage extends StatelessWidget {
  const AudioPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio')),
      body: const Center(child: Text('Audio Activity')),
    );
  }
}

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video')),
      body: const Center(child: Text('Video Activity')),
    );
  }
}
