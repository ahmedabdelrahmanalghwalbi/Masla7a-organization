import 'package:flutter/material.dart';

Map<String, Object> statusParser(String statusText) {
  late var status;
  switch (statusText) {
    case 'online':
      status = {'text': 'Online', 'color': Colors.green};
      break;
    case 'busy':
      status = {'text': 'Busy', 'color': Colors.yellow};
      break;
    case 'offline':
      status = {'text': 'Offline', 'color': Colors.red};
      break;
    default:
      status = {'text': 'Offline', 'color': Colors.red};
      break;
  }
  return status;
}
