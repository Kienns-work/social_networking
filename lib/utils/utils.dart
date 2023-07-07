import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imageSource) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: imageSource);

  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("No image choosed");
}

caculateTimeDurationFromNow(DateTime datePublished) {
  Duration duration = DateTime.now().difference(datePublished);
  if (duration.inDays >= 365) {
    int years = (duration.inDays / 365).round();
    return '$years năm trước';
  } else if (duration.inDays >= 1) {
    return '${duration.inDays} ngày trước';
  } else if (duration.inHours >= 1) {
    return '${duration.inHours} giờ trước';
  } else if (duration.inMinutes >= 1) {
    return '${duration.inMinutes} phút trước';
  } else {
    return 'Vừa đăng';
  }
}

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
