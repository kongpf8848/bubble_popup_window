import 'package:bubble_popup_window/bubble_popup_window.dart';
import 'package:flutter/material.dart';

class ChatModel {
  String content;
  bool isMe;

  ChatModel(this.content, {this.isMe = false});
}

class ItemModel {
  String title;
  IconData icon;

  ItemModel(this.title, this.icon);
}

class ComplexExample extends StatefulWidget {
  const ComplexExample({super.key});

  @override
  _ComplexExampleState createState() => _ComplexExampleState();
}

class _ComplexExampleState extends State<ComplexExample> {
  late List<ChatModel> messages;
  late List<ItemModel> menuItems;

  @override
  void initState() {
    messages = [
      ChatModel('我来了'),
      ChatModel('哈哈', isMe: true),
      ChatModel('好久不见，最近怎么样?'),
      ChatModel('还行，最近出去旅游了', isMe: true),
      ChatModel('去哪里了啊？', isMe: false),
      ChatModel(
          '上周去北京玩了，玩的挺开心的，特地总结出这篇全新北京旅游省钱攻略提供给你，希望给你带来有价值的参考。我们一共玩了3天，去了故宫、八达岭长城、圆明园、颐和园、奥林匹克公园等网红景点。',
          isMe: true),
      ChatModel('我也想去，但没有时间', isMe: false),
      ChatModel('明白', isMe: true),
      ChatModel('你就是太忙了', isMe: true),
      ChatModel('过几天我准备去巴厘岛玩玩', isMe: true),
      ChatModel('羡慕你', isMe: false),
      ChatModel('一起去啊，来一次说走就走的旅行', isMe: true),
    ];
    menuItems = [
      ItemModel('发起群聊', Icons.chat_bubble),
      ItemModel('添加朋友', Icons.group_add),
      ItemModel('扫一扫', Icons.settings_overscan),
      ItemModel('收付款', Icons.payment),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Complex Example'),
        actions: <Widget>[
          Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                var menu = IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: menuItems
                        .map(
                          (item) => GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              debugPrint("onTap:${item.title}");
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    item.icon,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        item.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
                BubblePopupWindow.show(
                  anchorContext: context,
                  child: menu,
                  direction: BubbleDirection.bottomEnd,
                  color: const Color(
                    0xFF4C4C4C,
                  ),
                  radius: BorderRadius.circular(4),
                );
              },
              child: const Icon(Icons.add_circle_outline, color: Colors.black),
            );
          }),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Column(
                children: messages
                    .map(
                      (message) => MessageContent(
                        message,
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class MessageContent extends StatelessWidget {
  MessageContent(this.message);

  final ChatModel message;
  List<ItemModel> menuItems = [
    ItemModel('复制', Icons.content_copy),
    ItemModel('转发', Icons.send),
    ItemModel('收藏', Icons.collections),
    ItemModel('删除', Icons.delete),
    ItemModel('多选', Icons.playlist_add_check),
    ItemModel('引用', Icons.format_quote),
    ItemModel('提醒', Icons.add_alert),
    ItemModel('搜一搜', Icons.search),
  ];

  Widget _buildLongPressMenu() {
    return Container(
      width: 220,
      child: GridView.count(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        crossAxisCount: 5,
        crossAxisSpacing: 0,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: menuItems
            .map(
              (item) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    item.icon,
                    size: 20,
                    color: Colors.white,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.title,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildAvatar(bool isMe, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isMe ? Colors.blueAccent : Colors.pinkAccent,
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: AssetImage(
            isMe ? "images/ic_user_head2.jpg" : "images/ic_user_head1.jpg",
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = message.isMe;
    double avatarSize = 40;

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: isMe ? 0 : 5, left: isMe ? 5 : 0),
            child: _buildAvatar(isMe, avatarSize),
          ),
          Builder(builder: (context) {
            return GestureDetector(
              onLongPress: () {
                var menu = _buildLongPressMenu();
                BubblePopupWindow.show(
                  anchorContext: context,
                  child: menu,
                  direction: BubbleDirection.topCenter,
                  color: const Color(0xFF4C4C4C),
                  radius: BorderRadius.circular(4),
                  miniEdgeMargin: const EdgeInsets.only(left: 10, right: 10),
                );
              },
              child: BubbleContainer(
                padding: const EdgeInsets.all(10),
                constraints:
                    BoxConstraints(maxWidth: 240, minHeight: avatarSize),
                color: isMe ? const Color(0xff98e165) : Colors.white,
                borderRadius: BorderRadius.circular(3.0),
                arrowDirection:
                    isMe ? ArrowDirection.right : ArrowDirection.left,
                arrowOffset: 20.0,
                child: Text(
                  message.content,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
