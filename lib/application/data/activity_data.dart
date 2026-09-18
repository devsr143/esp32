import 'package:esp32/application/view/scratch/scratch_program_page.dart';
import 'package:flutter/material.dart';
import '../view/example.dart';
import '../model/activity_model.dart';


class ActivityData {
  static final Map<int, List<ActivityModel>> activities = {
    3: [
      ActivityModel(
        id: 1,
        title: 'Shape Drawing',
        icon: Icons.draw,
        binAsset: 'assets/bin/class 3/Shapes_Modified_6.ino.bin',
        pageBuilder: () => const ScratchProgramPage(selectedClass: 3),
      ),
      ActivityModel(
        id: 2,
        title: 'Measurement',
        icon: Icons.straighten,
        binAsset: 'assets/bin/class3/activity2.bin',
        pageBuilder: () => const MeasurementPage(),
      ),
      ActivityModel(
        id: 3,
        title: 'Audio',
        icon: Icons.audiotrack,
        binAsset: 'assets/bin/class3/activity3.bin',
        pageBuilder: () => const AudioPage(),
      ),
      ActivityModel(
        id: 4,
        title: 'Video',
        icon: Icons.video_library,
        binAsset: 'assets/bin/class3/activity4.bin',
        pageBuilder: () => const VideoPage(),
      ),
    ],
  };

  static List<ActivityModel> getActivities(int selectedClass) {
    return activities[selectedClass] ?? [];
  }
}
