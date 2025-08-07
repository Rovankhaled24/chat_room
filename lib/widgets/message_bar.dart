import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chat_room/const.dart';
import 'package:chat_room/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:uuid/uuid.dart';

class Message_bar extends StatefulWidget {
  final ScrollController scrollController;
  final String email;
  final String senderId;
  final String receiverId;
  Message_bar({
    super.key,
    required this.scrollController,
    required this.email,
    required this.senderId,
    required this.receiverId,
  });

  @override
  State<Message_bar> createState() => _Message_barState();
}

class _Message_barState extends State<Message_bar> {
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessages,
  );
  TextEditingController controller = TextEditingController();
  final RecorderController recorderController = RecorderController();
  Duration recordDuration = Duration.zero;
  Timer? timer;

  String? path;
  String url = '';
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    recorderController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        recordDuration += Duration(seconds: 1);
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
    setState(() {
      recordDuration = Duration.zero;
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _sendMessage() {
    String message = controller.text.trim();
    if (message.isNotEmpty) {
      messages.add({
        'message': message,
        'date': Timestamp.now(),
        'email': widget.email,
        'type': 'text',
        'senderId': widget.senderId,
        'receiverId': widget.receiverId,
      });
      controller.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        }
      });
    }
  }

  Future<void> startRecording() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final name = '${Uuid().v1()}.m4a';
      path = '${dir.path}/$name';

      await recorderController.record(
        path: path!,
        androidEncoder: AndroidEncoder.aac,
        androidOutputFormat: AndroidOutputFormat.mpeg4,
        sampleRate: 16000,
      );

      startTimer();
      setState(() {
        isRecording = true;
      });

      print('Recording started');
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> upload() async {
    if (path == null) return;

    try {
      String name = basename(path!);
      final ref = FirebaseStorage.instance.ref('voices/$name');

      await ref.putFile(File(path!));
      String downloadUrl = await ref.getDownloadURL();

      setState(() {
        url = downloadUrl;
      });

      await messages.add({
        'message': '🎵',
        'audio': downloadUrl,
        'senderId': widget.senderId, // Add this
        'receiverId': widget.receiverId, // Add this
        'date': Timestamp.now(),
        'email': widget.email,
        'type': 'voice',
        'duration': recordDuration.inSeconds,
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        }
      });

      print('Voice message uploaded and sent successfully');
    } catch (e) {
      print('Error uploading: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      await recorderController.stop();
      stopTimer();
      setState(() {
        isRecording = false;
      });

      if (path != null) {
        await upload();
      }

      print('Recording stopped');
    } catch (e) {
      print('Error stopping recording: $e');
      setState(() {
        isRecording = false;
      });
    }
  }

  void _handleVoiceButton() {
    if (!isRecording) {
      startRecording();
    } else {
      stopRecording();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: primaryGradientColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      height: isRecording ? 120 : 105,
      child: Column(
        children: [
          if (isRecording)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.mic, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: AudioWaveforms(
                      size: Size(200, 30),
                      recorderController: recorderController,
                      enableGesture: true,
                      waveStyle: const WaveStyle(
                        waveColor: Colors.white,
                        showDurationLabel: false,
                        extendWaveform: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    formatDuration(recordDuration),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(BoxIcons.bx_camera, size: 32, color: Colors.white),
                ),
                SizedBox(
                  width: 290,
                  height: 48,
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => _sendMessage(),
                    enabled: !isRecording, // Disable when recording
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),

                      hintText:
                          isRecording ? 'Recording...' : 'write something...',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: isRecording ? Colors.grey : null,
                      ),
                      filled: true,
                      fillColor: isRecording ? Colors.grey[100] : Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                controller.text.isEmpty || isRecording
                    ? Padding(
                      padding: const EdgeInsets.only(bottom: 7, right: 6),
                      child: CircleAvatar(
                        backgroundColor:
                            isRecording
                                ? Colors.red.withOpacity(0.2)
                                : Colors.transparent,
                        child: IconButton(
                          onPressed: _handleVoiceButton,
                          icon: Icon(
                            isRecording
                                ? Icons.stop
                                : Icons.keyboard_voice_outlined,
                            color: isRecording ? Colors.red : Colors.white,
                            size: isRecording ? 28 : 32,
                          ),
                        ),
                      ),
                    )
                    : IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(Icons.send, size: 32, color: Colors.white),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
