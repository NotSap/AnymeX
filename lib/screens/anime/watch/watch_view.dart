import 'package:anymex/controllers/settings/settings.dart';
import 'package:anymex/database/data_keys/keys.dart';
import 'package:anymex/database/isar_models/episode.dart';
import 'package:anymex/database/isar_models/video.dart' as model;
import 'package:anymex/models/Media/media.dart' as anymex;
import 'package:anymex/screens/anime/watch/controller/player_controller.dart';
import 'package:anymex/screens/anime/watch/controls/themes/setup/themed_controls.dart';
import 'package:anymex/screens/anime/watch/controls/widgets/double_tap_seek.dart';
import 'package:anymex/screens/anime/watch/controls/widgets/episodes_pane.dart';
import 'package:anymex/screens/anime/watch/controls/widgets/overlay.dart';
import 'package:anymex/screens/anime/watch/controls/widgets/subtitle_text.dart';
import 'package:anymex/screens/anime/watch/subtitles/subtitle_view.dart';
import 'package:anymex/screens/anime/widgets/media_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';
import 'package:get/get.dart';

class WatchScreen extends StatefulWidget {
  final model.Video episodeSrc;
  final Episode currentEpisode;
  final List<Episode> episodeList;
  final anymex.Media anilistData;
  final List<model.Video> episodeTracks;
  final bool shouldTrack;
  const WatchScreen({
    super.key,
    required this.episodeSrc,
    required this.currentEpisode,
    required this.episodeList,
    required this.anilistData,
    required this.episodeTracks,
    this.shouldTrack = true,
  });

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> with WidgetsBindingObserver {
  late PlayerController controller;
  final settings = Get.find<Settings>();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.put(PlayerController(
        widget.episodeSrc,
        widget.currentEpisode,
        widget.episodeList,
        widget.anilistData,
        widget.episodeTracks,
        shouldTrack: widget.shouldTrack));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive && settings.autoPip) {
      PictureInPicture.updatePiPParams(
        pipParams: const PiPParams(
          pipWindowWidth: 256,
          pipWindowHeight: 144,
          initialCorner: PIPViewCorner.bottomRight,
        ),
      );
      PictureInPicture.startPiP(
        pipWidget: PiPWidget(
          onPiPClose: () {},
          elevation: 8,
          pipBorderRadius: 12,
          child: Obx(() => controller.videoWidget),
        ),
      );
    }
    if (state == AppLifecycleState.resumed) {
      PictureInPicture.stopPiP();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PictureInPicture.stopPiP();
    controller.delete();
    Get.delete<PlayerController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Obx(() {
          return controller.videoWidget;
        }),
        PlayerOverlay(controller: controller),
        if (!PlayerKeys.useLibass.get<bool>(false))
          SubtitleText(controller: controller),
        DoubleTapSeekWidget(
          controller: controller,
        ),
        const Align(
          alignment: Alignment.center,
          child: ThemedCenterControls(),
        ),
        const Align(
          alignment: Alignment.topCenter,
          child: ThemedTopControls(),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: ThemedBottomControls(),
        ),
        MediaIndicatorBuilder(
          isVolumeIndicator: false,
          controller: controller,
        ),
        MediaIndicatorBuilder(
          isVolumeIndicator: true,
          controller: controller,
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          left: 0,
          child: SubtitleSearchBottomSheet(controller: controller),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          left: 0,
          child: EpisodesPane(controller: controller),
        ),
      ],
    ));
  }
}
