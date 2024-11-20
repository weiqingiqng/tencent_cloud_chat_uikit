// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_state.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/common_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/message.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class TIMUIKitLastMsg extends StatefulWidget {
  final V2TimMessage? lastMsg;
  final List<V2TimGroupAtInfo?> groupAtInfoList;
  final BuildContext context;
  final double fontSize;
  final String? subjectNo;

  const TIMUIKitLastMsg({
    Key? key,
    this.lastMsg,
    required this.groupAtInfoList,
    required this.context,
    this.fontSize = 14.0,
    this.subjectNo,
  }) : super(key: key);

  @override
  State<TIMUIKitLastMsg> createState() => _TIMUIKitLastMsgState();
}

class _TIMUIKitLastMsgState extends TIMUIKitState<TIMUIKitLastMsg> {
  String groupTipsAbstractText = "";

  @override
  void initState() {
    super.initState();
    _getMsgElem();
  }

  @override
  void didUpdateWidget(covariant TIMUIKitLastMsg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.lastMsg?.msgID != widget.lastMsg?.msgID) ||
        (oldWidget.lastMsg?.id != widget.lastMsg?.id) ||
        (oldWidget.lastMsg?.status != widget.lastMsg?.status)) {
      _getMsgElem();
    }
  }

  (bool isRevoke, bool isRevokeByAdmin) isRevokeMessage(V2TimMessage? message) {
    if (message == null) {
      return (false, false);
    }
    if (message.status == 6) {
      return (true, false);
    } else {
      try {
        final customData = jsonDecode(message.cloudCustomData ?? "{}");
        final isRevoke = customData["isRevoke"] ?? false;
        final revokeByAdmin = customData["revokeByAdmin"] ?? false;
        return (isRevoke, revokeByAdmin);
      } catch (e) {
        return (false, false);
      }
    }
  }

  void _getMsgElem() async {
    final revokeStatus = isRevokeMessage(widget.lastMsg);
    final isRevokedMessage = revokeStatus.$1;
    final isAdminRevoke = revokeStatus.$2;

    final newText =
        await _getLastMsgShowText(widget.lastMsg, widget.context) ?? "";
    if (mounted) {
      setState(() {
        groupTipsAbstractText = newText;
      });
    }
  }

  Future<String?> _getLastMsgShowText(
      V2TimMessage? message, BuildContext context) async {
    final msgType = message!.elemType;
    if (message.groupID != null) {
      return widget.subjectNo;
    } else {
      return '';
    }
  }

  Icon? _getIconByMsgStatus(BuildContext context) {
    final msgStatus = widget.lastMsg!.status;
    final theme = Provider.of<TUIThemeViewModel>(context).theme;
    if (msgStatus == MessageStatus.V2TIM_MSG_STATUS_SEND_FAIL) {
      return Icon(Icons.error, color: theme.cautionColor, size: 16);
    }
    if (msgStatus == MessageStatus.V2TIM_MSG_STATUS_SENDING) {
      return Icon(Icons.arrow_back, color: theme.weakTextColor, size: 16);
    }
    return null;
  }

  String _getAtMessage() {
    String msg = "";
    for (var item in widget.groupAtInfoList) {
      if (item!.atType == 1) {
        msg = TIM_t("[有人@我] ");
      } else {
        msg = TIM_t("[@所有人] ");
      }
    }
    return msg;
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;
    final icon = _getIconByMsgStatus(context);
    return Row(children: [
      if (icon != null)
        Container(
          margin: const EdgeInsets.only(right: 2),
          child: icon,
        ),
      if (widget.groupAtInfoList.isNotEmpty)
        Text(_getAtMessage(),
            style: TextStyle(
                color: theme.cautionColor, fontSize: widget.fontSize)),
      if (TencentUtils.checkString(groupTipsAbstractText) != null)
        Expanded(
            child: Text(
          groupTipsAbstractText,
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              height: 1, color: theme.weakTextColor, fontSize: widget.fontSize),
        )),
    ]);
  }
}
