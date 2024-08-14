import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/Home/posts/polls.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:video_player/video_player.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String imagePath = "";
  String vedioPath = "";
  String filePath = "";
  bool _isUploading = false;
  final TextEditingController _textController = TextEditingController();
  double _uploadProgress = 0.0;

  Future<String?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      final path = result.files.single.path;
      return path;
    } else {
      return null;
    }
  }

  Future<String?> pickImage({required bool fromCamera}) async {
    final picker = ImagePicker();
    final filePicker = FilePicker.platform;

    final source = fromCamera ? ImageSource.camera : ImageSource.gallery;

    final pickedFile = await picker.pickImage(
      source: source,
    );

    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      final result = await filePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
      );

      if (result != null) {
        final path = result.files.single.path!;
        return path;
      }
    }

    return null;
  }

  Future<String?> pickVedio({required bool fromCamera}) async {
    final picker = ImagePicker();
    final filePicker = FilePicker.platform;

    final source = fromCamera ? ImageSource.camera : ImageSource.gallery;

    final pickedFile = await picker.pickVideo(
      source: source,
      maxDuration: const Duration(minutes: 1),
    );

    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      final result = await filePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
      );

      if (result != null) {
        final path = result.files.single.path!;
        return path;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة منشور'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 0.5),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearPercentIndicator(
                  percent: _uploadProgress,
                  center: Text('${(_uploadProgress * 100).toInt()}%'),
                  // ignore: deprecated_member_use
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                TextField(
                  controller: _textController,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    hintText: 'أكتب منشورك',
                  ),
                ),
                if (vedioPath.isNotEmpty) ...[
                  if (vedioPath.endsWith('.mp4') || vedioPath.endsWith('.mov'))
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 0.5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: VideoPlayers(videoPath: vedioPath),
                        ),
                      ),
                    ),
                ],
                if (imagePath.endsWith('.jpg') ||
                    imagePath.endsWith('.jpeg') ||
                    imagePath.endsWith('.png')) ...[
                  Image.file(File(imagePath)),
                ],
                if (filePath.isNotEmpty) ...[
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.attachment_sharp),
                      title: Text(filePath),
                      onTap: () {
                        if (filePath.endsWith('.pdf')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFView(
                                filePath: filePath,
                              ),
                            ),
                          );
                        } else {
                          // Handle other file types
                        }
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        final path = await pickImage(fromCamera: false);
                        if (path != null) {
                          setState(() {
                            imagePath = path;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final path = await pickVedio(fromCamera: false);
                        if (path != null) {
                          setState(() {
                            vedioPath = path;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.video_collection_rounded,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final path = await pickFile();
                        if (path != null) {
                          setState(() {
                            filePath = path;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.attachment_sharp,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const MyPolls();
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.equalizer_sharp,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _isUploading
                          ? null
                          : () async {
                              setState(() {
                                _isUploading = true;
                              });
                              creatPost();

                              Navigator.pop(context);
                            },
                      child: _isUploading
                          ? CircularProgressIndicator(
                              value: _uploadProgress,
                            )
                          : const Text('نشر '),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("إلغاء")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> creatPost() async {
    String imageUrl = "";
    String vedioUrl = "";
    String fileUrl = "";
    if (imagePath != "") {
      imageUrl = await FireBase().uploadFile(File(imagePath));
    }
    if (vedioPath != "") {
      vedioUrl = await FireBase().uploadVideoToFirebase(File(imagePath));
    }
    if (filePath != "") {
      fileUrl = await FireBase().uploadFile(File(imagePath));
    }
    final user = FirebaseAuth.instance.currentUser;
    await FireBase().addDataToFirebase_Id('posts', {
      "text": _textController.text,
      "imageUrl": imageUrl,
      "videoUrl": vedioUrl,
      "fileUrl": fileUrl,
      "userId": user?.uid,
      'like': 0,
      'command': 0,
      "timeStamp": DateTime.now(),
      "type": 'normal'
    });
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم النشر بنجاح'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}

class VideoPlayers extends StatefulWidget {
  const VideoPlayers({super.key, required this.videoPath});
  final String videoPath;
  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayers> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool _isPlaying = false;
  bool _isVoice = false;

  String _duration = '';
  String _position = '';

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      File(widget.videoPath),
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);

    _controller.addListener(() {
      final duration = _controller.value.duration;
      final position = _controller.value.position;

      if (mounted) {
        setState(() {
          _duration = formatDuration(duration);
          _position = formatDuration(position);
        });
      }
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }

  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(
                    _controller,
                  ),
                ),
              ]),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                          if (_isPlaying) {
                            _controller.play();
                          } else {
                            _controller.pause();
                          }
                        });
                      },
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Text(
                      _position,
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                    Slider(
                      value: _controller.value.position.inSeconds.toDouble(),
                      min: 0.0,
                      max: _controller.value.duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _controller.seekTo(Duration(seconds: value.toInt()));
                        });
                      },
                    ),
                    Text(
                      _duration,
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                    IconButton(
                      onPressed: () {
                        _controller
                            .setVolume(_controller.value.volume == 0 ? 1 : 0);
                        setState(() {
                          _isVoice = !_isVoice;
                        });
                      },
                      icon: Icon(
                        _isVoice ? Icons.volume_off : Icons.volume_up,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
