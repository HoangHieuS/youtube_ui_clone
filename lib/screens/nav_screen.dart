import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_ui_clone/data.dart';
import 'package:youtube_ui_clone/screens/screens.dart';

final selectedVideoProvider = StateProvider<Video?>((ref) => null);

final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
  (ref) => MiniplayerController(),
);

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  static const double _playerMinHeight = 60;

  int _selectedIndex = 0;

  final _screens = [
    const HomeScreen(),
    const Scaffold(
      body: Center(
        child: Text('Shorts'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('Add'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('Subscriptions'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('Library'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          final selectedVideo = ref.watch(selectedVideoProvider);
          final miniPlayerController = ref.watch(miniPlayerControllerProvider);
          return Stack(
            children: _screens
                .asMap()
                .map((i, screen) => MapEntry(
                      i,
                      Offstage(
                        offstage: _selectedIndex != i,
                        child: screen,
                      ),
                    ))
                .values
                .toList()
              ..add(
                Offstage(
                  offstage: selectedVideo == null,
                  child: Miniplayer(
                    controller: miniPlayerController,
                    maxHeight: MediaQuery.of(context).size.height,
                    minHeight: _playerMinHeight,
                    builder: (height, percentage) {
                      if (selectedVideo == null) return const SizedBox.shrink();

                      if (height <= _playerMinHeight + 50) {
                        return Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    selectedVideo.thumbnailUrl,
                                    height: _playerMinHeight - 4,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              selectedVideo.title,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            selectedVideo.author.username,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      ref
                                          .read(selectedVideoProvider.state)
                                          .state = null;
                                    },
                                  ),
                                ],
                              ),
                              const LinearProgressIndicator(
                                value: 0.4,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            ],
                          ),
                        );
                      }
                      return const VideoScreen();
                    },
                  ),
                ),
              ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Typicons.flash_outline),
            activeIcon: Icon(Typicons.flash),
            label: 'Shorts',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              size: 40,
            ),
            activeIcon: Icon(
              Icons.add_circle,
              size: 40,
            ),
            label: ' ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_outlined),
            activeIcon: Icon(Icons.subscriptions),
            label: 'Subscriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            activeIcon: Icon(Icons.video_library),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
