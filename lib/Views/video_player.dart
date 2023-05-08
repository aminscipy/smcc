import 'package:cc/Controllers/video_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PlayVideo extends StatelessWidget {
  const PlayVideo({super.key});

  @override
  Widget build(BuildContext context) {
    VideoController videoController = Get.find<VideoController>();
    VideoPlayerController controller =
        VideoPlayerController.network('http://192.168.43.201:5000/video');
    Future initialize = controller.initialize();
    return Scaffold(
        appBar: AppBar(
          title: const Text('SMCC'),
        ),
        body: FutureBuilder(
            future: initialize,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () async {
                              await controller.play();
                            },
                            icon: const Icon(Icons.play_arrow)),
                        Obx(() => videoController.isDownloading.value
                            ? Padding(
                                padding: const EdgeInsets.only(right: 25.0),
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: const Center(
                                        child: LinearProgressIndicator(
                                      color: Colors.black,
                                    ))),
                              )
                            : TextButton.icon(
                                style: TextButton.styleFrom(
                                    iconColor: Colors.black),
                                label: const Text('Download',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () async {
                                  await videoController.downloadVideo();
                                },
                                icon: const Icon(Icons.download)))
                      ],
                    )
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
