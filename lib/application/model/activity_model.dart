// ignore: file_names
import 'package:flutter/material.dart';

class ActivityModel {
  final int id;
  final String title;
  final IconData icon;
  final String binAsset;

  // The page to open after the .bin is sent successfully.
  final Widget Function() pageBuilder;

  ActivityModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.binAsset,
    required this.pageBuilder,
  });
}
