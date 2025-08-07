import 'package:chat_room/const.dart';
import 'package:chat_room/models/message.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({super.key, required this.message, required this.receivername});
  final Message message;
  final String receivername;

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  bool isLoading = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    print('Message type: ${widget.message.type}');
    print('Audio URL: ${widget.message.audio}');
  }

  bool _isVoiceMessage() {
    print('Checking voice message:');
    print('Type: ${widget.message.type}');
    print('Audio: ${widget.message.audio}');
    print('Duration: ${widget.message.duration}');

    return (widget.message.type == 'voice' ||
        (widget.message.audio != null && widget.message.audio!.isNotEmpty));
  }

  Future<void> _togglePlayback() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 300));

    setState(() {
      isLoading = false;
      isPlaying = !isPlaying;
    });

    if (isPlaying) {
      int duration = widget.message.duration ?? 10;
      print('Playing voice message for $duration seconds');

      Future.delayed(Duration(seconds: duration), () {
        if (mounted) {
          setState(() {
            isPlaying = false;
          });
          print('Voice message finished playing');
        }
      });
    }
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return "00:00";

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget VoiceMessage() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        color: Color(0xFFE8ECF1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: isLoading ? null : _togglePlayback,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLoading
                    ? Icons.hourglass_empty
                    : (isPlaying ? Icons.pause : Icons.play_arrow),
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      25,
                      (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 2.5,
                        height:
                            isPlaying
                                ? (10 + (index % 6) * 3.0)
                                : (6 + (index % 4) * 2.0),
                        decoration: BoxDecoration(
                          color: isPlaying ? Colors.white : Colors.white54,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),

                Text(
                  _formatDuration(widget.message.duration ?? 0),
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/girl.png'),
          ),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.receivername,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text('deleta a message'),
                                content: Text(
                                  'do you want to delete a message?',
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          if (widget.message.documentId !=
                                              null) {
                                            await FirebaseFirestore.instance
                                                .collection(kMessages)
                                                .doc(widget.message.documentId)
                                                .update({
                                                  'message':
                                                      'this message is deleted 🚫',
                                                });
                                          }
                                        },
                                        child: Text('yes'),
                                      ),

                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('cancel'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        );
                      },
                      child:
                          _isVoiceMessage()
                              ? VoiceMessage()
                              : Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  color: Color(0xFFE8ECF1),
                                ),
                                child: Text(
                                  widget.message.message,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 10),
                      child: Text(
                        DateFormat('h:mm a').format(widget.message.date),
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
