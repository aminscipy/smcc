import 'package:cc/Controllers/video_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';

class PlayVideo extends StatelessWidget {
  const PlayVideo({super.key});

  @override
  Widget build(BuildContext context) {
    VideoController videoController = Get.find<VideoController>();
    VideoPlayerController controller =
        VideoPlayerController.network('$endpoint/video');
    Future initialize = controller.initialize();
    return Scaffold(
        appBar: AppBar(
          title: const Text('SMCC'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: FutureBuilder(
                future: initialize,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  await controller.play();
                                },
                                icon: const Icon(
                                  Icons.play_circle,
                                  size: 40,
                                )),
                            Obx(() => videoController.isDownloading.value
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 25.0),
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5,
                                        child: const Center(
                                            child: LinearProgressIndicator(
                                          color: Colors.black,
                                        ))),
                                  )
                                : TextButton.icon(
                                    style: TextButton.styleFrom(
                                        iconColor: Colors.black),
                                    label: const Text('',
                                        style: TextStyle(color: Colors.black)),
                                    onPressed: () async {
                                      await videoController.downloadVideo();
                                    },
                                    icon: const Icon(
                                      Icons.download,
                                      size: 38,
                                    )))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ));
  }
}
