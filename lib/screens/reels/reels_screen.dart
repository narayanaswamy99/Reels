import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:reels/screens/video_recording_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ReelsScreen extends StatefulWidget {
  List<String>? videoUrls;
  int index;
  ReelsScreen({Key? key, this.videoUrls, this.index = 0}) : super(key: key);

  @override
  _ReelsScreenState createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  FlickManager? flickManager;
  final FirebaseStorage storage = FirebaseStorage.instance;
  List<String> videoUrls = [];

  @override
  void initState() {
    super.initState();

    getVideoUrls();
  }

// to get the urls of videos from the firebase storage
  Future<void> getVideoUrls() async {
    final ListResult result = await FirebaseStorage.instance.ref('').listAll();
    final List<String> urls = await Future.wait(
      result.items.map((ref) => ref.getDownloadURL()).toList(),
    );
    setState(() {
      videoUrls = urls;
      print(videoUrls);
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(videoUrls[0]),
      );
    });
  }

  @override
  void dispose() {
    flickManager!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButton: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraExampleHome()),
                  );
                },
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    child: const Icon(
                      Icons.video_camera_back_outlined,
                      size: 30,
                    ))),
            body: videoUrls.isNotEmpty && flickManager != null
                ? GestureDetector(
                    onVerticalDragEnd: (details) {
                      //  int sensitivity = 8;
                      if (details.velocity.pixelsPerSecond.dy < 0) {
                        if (widget.index == 0) {
                        } else {
                          widget.index = widget.index - 1;
                          flickManager!.handleChangeVideo(
                            VideoPlayerController.network(
                                videoUrls[widget.index]),
                          );
                          // flickManager = FlickManager(
                          //   videoPlayerController:
                          //       VideoPlayerController.network(
                          //           videoUrls[widget.index]),
                          // );
                          setState(
                            () {},
                          );
                        }
                      } else {
                        if (widget.index < videoUrls.length) {
                          widget.index = widget.index + 1;
                          flickManager!.handleChangeVideo(
                            VideoPlayerController.network(
                                videoUrls[widget.index]),
                          );
                          // flickManager = FlickManager(
                          //   videoPlayerController:
                          //       VideoPlayerController.network(
                          //           videoUrls[widget.index]),
                          // );
                          setState(
                            () {},
                          );
                        }
                      }
                    },
                    child:

                        // Stack(children: [
                        FlickVideoPlayer(
                      flickManager: flickManager!,
                      // flickVideoWithControls: FlickVideoWithControls(),
                    ))
                // Align(
                //     alignment: Alignment.topCenter,
                //     child: InkWell(
                //         onTap: () {
                //           if (widget.index == 0) {
                //           } else {
                //             widget.index = widget.index - 1;
                //             flickManager!.handleChangeVideo(
                //               VideoPlayerController.network(
                //                   videoUrls[widget.index]),
                //             );
                //             // flickManager = FlickManager(
                //             //   videoPlayerController:
                //             //       VideoPlayerController.network(
                //             //           videoUrls[widget.index]),
                //             // );
                //             setState(
                //               () {},
                //             );
                //           }
                //         },
                //         child: const Icon(
                //           Icons.arrow_circle_up_rounded,
                //           size: 70,
                //         ))),
                // Align(
                //     alignment: Alignment.bottomCenter,
                //     child: InkWell(
                //         onTap: () {
                //           if (widget.index < videoUrls.length) {
                //             widget.index = widget.index + 1;
                //             flickManager!.handleChangeVideo(
                //               VideoPlayerController.network(
                //                   videoUrls[widget.index]),
                //             );
                //             // flickManager = FlickManager(
                //             //   videoPlayerController:
                //             //       VideoPlayerController.network(
                //             //           videoUrls[widget.index]),
                //             // );
                //             setState(
                //               () {},
                //             );
                //           }
                //         },
                //         child: const Icon(
                //           Icons.arrow_circle_down_rounded,
                //           size: 70,
                //         )))
                // ])
                // )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [CircularProgressIndicator()])));
  }
}
