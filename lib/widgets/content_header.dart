import 'package:flutter/material.dart';
import 'package:net_clone/models/model.dart';
import 'widgets.dart';
import 'package:video_player/video_player.dart';

class ContentHeader extends StatelessWidget {
  final Content featuredContent;

  const ContentHeader({Key key, @required this.featuredContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: _ContentHeaderMobile(featuredContent: featuredContent),
        desktop: _ContentHeaderDesktop(featuredContent: featuredContent));
  }
}

class _ContentHeaderMobile extends StatefulWidget {
  final Content featuredContent;

  const _ContentHeaderMobile({Key key, this.featuredContent}) : super(key: key);

  @override
  __ContentHeaderMobileState createState() => __ContentHeaderMobileState();
}

class __ContentHeaderMobileState extends State<_ContentHeaderMobile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 500,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(widget.featuredContent.imageUrl),
            fit: BoxFit.cover,
          )),
        ),
        Container(
          height: 500,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
        ),
        Positioned(
          child: SizedBox(
            height: 250,
            child: Image.asset(widget.featuredContent.titleImageUrl),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              VerticalIconButton(
                icon: Icons.add,
                title: 'List',
                onTap: () => print('My List'),
              ),
              _PlayButton(),
              VerticalIconButton(
                icon: Icons.info_outline,
                title: 'info',
                onTap: () => print('Info'),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _ContentHeaderDesktop extends StatefulWidget {
  final Content featuredContent;

  const _ContentHeaderDesktop({Key key, this.featuredContent})
      : super(key: key);

  @override
  __ContentHeaderDesktopState createState() => __ContentHeaderDesktopState();
}

class __ContentHeaderDesktopState extends State<_ContentHeaderDesktop> {
  VideoPlayerController _videoPlayerController;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(widget.featuredContent.videoUrl)
          ..initialize().then((_) => setState(() => {}))
          ..setVolume(0)
          ..play();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _videoPlayerController.value.isPlaying
          ? _videoPlayerController.pause()
          : _videoPlayerController.play(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          AspectRatio(
            aspectRatio: _videoPlayerController.value.initialized
                ? _videoPlayerController.value.aspectRatio
                : 2.344,
            child: _videoPlayerController.value.initialized
                ? VideoPlayer(_videoPlayerController)
                : Image.asset(
                    widget.featuredContent.imageUrl,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -1.0,
            child: AspectRatio(
              aspectRatio: _videoPlayerController.value.initialized
                  ? _videoPlayerController.value.aspectRatio
                  : 2.344,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 60.0,
            right: 60.0,
            bottom: 150.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250.0,
                  child: Image.asset(widget.featuredContent.titleImageUrl),
                ),
                const SizedBox(height: 15.0),
                Text(
                  widget.featuredContent.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2.0, 4.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    _PlayButton(),
                    SizedBox(width: 16.0),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
                      ),
                      onPressed: () => print('More Info'),
                      icon: Icon(
                        Icons.info_outline,
                        size: 30.0,
                        color: Colors.black,
                      ),
                      label: Text(
                        'More Info',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    if (_videoPlayerController.value.initialized)
                      IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                        ),
                        color: Colors.white,
                        iconSize: 30.0,
                        onPressed: () => setState(() {
                          _isMuted
                              ? _videoPlayerController.setVolume(100)
                              : _videoPlayerController.setVolume(0);
                          _isMuted = _videoPlayerController.value.volume == 0;
                        }),
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

class _PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () => print('Play'),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          padding: !Responsive.isDesktop(context)
              ? EdgeInsets.fromLTRB(15, 5, 20, 5)
              : EdgeInsets.fromLTRB(25, 10, 30, 10),
        ),
        icon: Icon(
          Icons.play_arrow,
          size: 30,
          color: Colors.black,
        ),
        label: Text(
          'Play',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ));
  }
}
