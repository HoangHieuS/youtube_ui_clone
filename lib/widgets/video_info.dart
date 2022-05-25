import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:youtube_ui_clone/data.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fluttericon/font_awesome_icons.dart';

class VideoInfo extends StatelessWidget {
  final Video video;

  const VideoInfo({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    video.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${video.viewCount} views · ${timeago.format(video.timestamp)}',
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(fontSize: 14),
                ),
                const Divider(),
                _ActionsRow(video: video),
                const Divider(),
                _AuthorInfo(user: video.author),
                const Divider(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final Video video;

  const _ActionsRow({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            _buildAction(context, Icons.thumb_up_outlined, video.likes),
            const SizedBox(width: 25),
            _buildAction(context, Icons.thumb_down_outlined, 'Dislikes'),
            const SizedBox(width: 25),
            _buildAction(context, MdiIcons.shareOutline, 'Share'),
            const SizedBox(width: 25),
            _buildAction(context, MdiIcons.arrowCollapseDown, 'Download'),
            const SizedBox(width: 25),
            _buildAction(context, FontAwesome.scissors, 'Create short...'),
            const SizedBox(width: 25),
            _buildAction(context, Icons.library_add_outlined, 'Save'),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _AuthorInfo extends StatefulWidget {
  final User user;

  const _AuthorInfo({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<_AuthorInfo> createState() => _AuthorInfoState();
}

class _AuthorInfoState extends State<_AuthorInfo> {
  bool isSubscribed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage(widget.user.profileImageUrl),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    widget.user.username,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 15),
                  ),
                ),
                Flexible(
                  child: Text(
                    '${widget.user.subscribers} Subscribers',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          _subscribeAction(),
          isSubscribed
              ? IconButton(
                  icon: const Icon(MdiIcons.bellOutline),
                  iconSize: 30,
                  onPressed: () {},
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _subscribeAction() {
    final style = isSubscribed
        ? Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.grey[600])
        : Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.red);
    final label = isSubscribed ? 'SUBSCRIBED' : 'SUBSCRIPTIONED';
    return TextButton(
      onPressed: () {
        setState(() => isSubscribed = !isSubscribed);
      },
      child: Text(
        label,
        style: style,
      ),
    );
  }
}
