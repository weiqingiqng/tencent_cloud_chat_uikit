// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class TIMUIKitGroupProfileExample extends StatelessWidget {
  final String? groupID;

  const TIMUIKitGroupProfileExample({Key? key, this.groupID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TIMUIKitGroupProfile(
      groupID: groupID ??
          '@TGS#1X2AML5H6', // Please fill in here according to the actual cleaning
    );
  }
}
