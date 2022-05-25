import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_ui_clone/data.dart';
import 'package:youtube_ui_clone/screens/screens.dart';
import 'package:youtube_ui_clone/widgets/widgets.dart';

class VideoScreen extends ConsumerStatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  ScrollController? _scrollController;
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    isTapped;
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          ref
              .read(miniPlayerControllerProvider.state)
              .state
              .animateToHeight(state: PanelState.MAX);
          setState(() => isTapped = !isTapped);
        },
        child: Scaffold(
          body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: CustomScrollView(
              controller: _scrollController,
              shrinkWrap: true,
              slivers: [
                SliverToBoxAdapter(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final selectedVideo = ref.watch(selectedVideoProvider);
                      return Column(
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                selectedVideo!.thumbnailUrl,
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              isTapped
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          iconSize: 30,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          onPressed: () => ref
                                              .read(miniPlayerControllerProvider
                                                  .state)
                                              .state
                                              .animateToHeight(
                                                  state: PanelState.MIN),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              iconSize: 30,
                                              icon: const Icon(Icons.cast),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              iconSize: 30,
                                              icon: const Icon(MdiIcons
                                                  .closedCaptionOutline),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              iconSize: 30,
                                              icon: const Icon(Icons.more_vert),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              isTapped
                                  ? Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: IconButton(
                                        iconSize: 30,
                                        icon: const Icon(MdiIcons.fullscreen),
                                        onPressed: () {},
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const LinearProgressIndicator(
                            value: 0.4,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                          VideoInfo(video: selectedVideo),
                        ],
                      );
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final video = suggestedVideos[index];
                      return VideoCard(
                        video: video,
                        hasPadding: true,
                        onTap: () => _scrollController!.animateTo(
                          0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        ),
                      );
                    },
                    childCount: suggestedVideos.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
