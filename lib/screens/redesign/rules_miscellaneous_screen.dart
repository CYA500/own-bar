import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../../platform/livebridge_platform.dart';
import '../../theme/livebridge_tokens.dart';
import '../../utils/livebridge_haptics.dart';
import '../../widgets/redesign/lb_detail_screen.dart';
import '../../widgets/redesign/lb_list_component.dart';

class RulesMiscellaneousScreen extends StatefulWidget {
  const RulesMiscellaneousScreen({super.key});

  @override
  State<RulesMiscellaneousScreen> createState() =>
      _RulesMiscellaneousScreenState();
}

class _RulesMiscellaneousScreenState extends State<RulesMiscellaneousScreen> {
  bool _navigationEnabled = true;
  bool _callsEnabled = true;
  bool _mediaPlaybackEnabled = true;
  bool _showMediaOnLock = false;
  bool _useSymbolsInMediaPlayer = false;
  bool _weatherEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_loadState());
    });
  }

  Future<void> _loadState() async {
    try {
      final Future<bool> navigationFuture =
          LiveBridgePlatform.getSmartNavigationEnabled();
      final Future<bool> callsFuture =
          LiveBridgePlatform.getSmartCallsEnabled();
      final Future<bool> mediaPlaybackFuture =
          LiveBridgePlatform.getSmartMediaPlaybackEnabled();
      final Future<bool> showMediaOnLockFuture =
          LiveBridgePlatform.getSmartMediaPlaybackShowOnLockScreen();
      final Future<bool> useSymbolsInMediaPlayerFuture =
          LiveBridgePlatform.getSmartMediaPlaybackUseSymbolsInPlayer();
      final Future<bool> weatherFuture =
          LiveBridgePlatform.getSmartWeatherEnabled();

      final bool navigationEnabled = await navigationFuture;
      final bool callsEnabled = await callsFuture;
      final bool mediaPlaybackEnabled = await mediaPlaybackFuture;
      final bool showMediaOnLock = await showMediaOnLockFuture;
      final bool useSymbolsInMediaPlayer = await useSymbolsInMediaPlayerFuture;
      final bool weatherEnabled = await weatherFuture;

      if (!mounted) {
        return;
      }

      setState(() {
        _navigationEnabled = navigationEnabled;
        _callsEnabled = callsEnabled;
        _mediaPlaybackEnabled = mediaPlaybackEnabled;
        _showMediaOnLock = showMediaOnLock;
        _useSymbolsInMediaPlayer = useSymbolsInMediaPlayer;
        _weatherEnabled = weatherEnabled;
      });
    } catch (_) {}
  }

  Future<void> _setNavigationEnabled(bool value) async {
    if (value == _navigationEnabled) {
      return;
    }
    setState(() => _navigationEnabled = value);
    await LiveBridgePlatform.setSmartNavigationEnabled(value);
  }

  Future<void> _setCallsEnabled(bool value) async {
    if (value == _callsEnabled) {
      return;
    }
    setState(() => _callsEnabled = value);
    await LiveBridgePlatform.setSmartCallsEnabled(value);
  }

  Future<void> _setMediaPlaybackEnabled(bool value) async {
    if (value == _mediaPlaybackEnabled) {
      return;
    }
    setState(() => _mediaPlaybackEnabled = value);
    await LiveBridgePlatform.setSmartMediaPlaybackEnabled(value);
  }

  Future<void> _setShowMediaOnLock(bool value) async {
    if (!_mediaPlaybackEnabled || value == _showMediaOnLock) {
      return;
    }
    setState(() => _showMediaOnLock = value);
    await LiveBridgePlatform.setSmartMediaPlaybackShowOnLockScreen(value);
  }

  Future<void> _setUseSymbolsInMediaPlayer(bool value) async {
    if (!_mediaPlaybackEnabled || value == _useSymbolsInMediaPlayer) {
      return;
    }
    setState(() => _useSymbolsInMediaPlayer = value);
    await LiveBridgePlatform.setSmartMediaPlaybackUseSymbolsInPlayer(value);
  }

  Future<void> _setWeatherEnabled(bool value) async {
    if (value == _weatherEnabled) {
      return;
    }
    setState(() => _weatherEnabled = value);
    await LiveBridgePlatform.setSmartWeatherEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings strings = AppStrings.of(context);
    final List<LbListItemData> mediaItems = <LbListItemData>[
      LbListItemData(
        title: strings.mediaPlaybackRedesignTitle,
        description: strings.mediaPlaybackDescription,
        showChevron: false,
        toggleValue: _mediaPlaybackEnabled,
        onToggle: (bool value) {
          unawaited(_setMediaPlaybackEnabled(value));
        },
        onTap: () {
          final bool nextValue = !_mediaPlaybackEnabled;
          unawaited(LiveBridgeHaptics.toggle(nextValue));
          unawaited(_setMediaPlaybackEnabled(nextValue));
        },
      ),
      LbListItemData(
        title: strings.showMediaOnLockTitle,
        description: strings.showMediaOnLockDescription,
        showChevron: false,
        toggleValue: _showMediaOnLock,
        enabled: _mediaPlaybackEnabled,
        onToggle: (bool value) {
          unawaited(_setShowMediaOnLock(value));
        },
        onTap: () {
          if (!_mediaPlaybackEnabled) {
            return;
          }
          final bool nextValue = !_showMediaOnLock;
          unawaited(LiveBridgeHaptics.toggle(nextValue));
          unawaited(_setShowMediaOnLock(nextValue));
        },
      ),
      LbListItemData(
        title: strings.useSymbolsInMediaPlayerTitle,
        description: strings.useSymbolsInMediaPlayerDescription,
        showChevron: false,
        toggleValue: _useSymbolsInMediaPlayer,
        enabled: _mediaPlaybackEnabled,
        onToggle: (bool value) {
          unawaited(_setUseSymbolsInMediaPlayer(value));
        },
        onTap: () {
          if (!_mediaPlaybackEnabled) {
            return;
          }
          final bool nextValue = !_useSymbolsInMediaPlayer;
          unawaited(LiveBridgeHaptics.toggle(nextValue));
          unawaited(_setUseSymbolsInMediaPlayer(nextValue));
        },
      ),
    ];

    final List<LbListItemData> otherItems = <LbListItemData>[
      LbListItemData(
        title: strings.callsTitle,
        description: strings.callsDescription,
        showChevron: false,
        toggleValue: _callsEnabled,
        onToggle: (bool value) {
          unawaited(_setCallsEnabled(value));
        },
        onTap: () {
          final bool nextValue = !_callsEnabled;
          unawaited(LiveBridgeHaptics.toggle(nextValue));
          unawaited(_setCallsEnabled(nextValue));
        },
      ),
      LbListItemData(
        title: strings.navigationMapsTitle,
        description: strings.navigationMapsDescription,
        showChevron: false,
        toggleValue: _navigationEnabled,
        onToggle: (bool value) {
          unawaited(_setNavigationEnabled(value));
        },
        onTap: () {
          final bool nextValue = !_navigationEnabled;
          unawaited(LiveBridgeHaptics.toggle(nextValue));
          unawaited(_setNavigationEnabled(nextValue));
        },
      ),
      LbListItemData(
        title: strings.weatherBroadcastsTitle,
        description: strings.weatherBroadcastsDescription,
        showChevron: false,
        toggleValue: _weatherEnabled,
        onToggle: (bool value) {
          unawaited(_setWeatherEnabled(value));
        },
        onTap: () {
          final bool nextValue = !_weatherEnabled;
          unawaited(LiveBridgeHaptics.toggle(nextValue));
          unawaited(_setWeatherEnabled(nextValue));
        },
      ),
    ];

    return LbDetailScreen(
      title: strings.miscellaneousTitle,
      children: <Widget>[
        LbListComponent(
          items: mediaItems,
          rowHeight: LbSpacing.recentRowHeight,
          extendDividersToEnd: true,
        ),
        const SizedBox(height: LbSpacing.md),
        LbListComponent(
          items: otherItems,
          rowHeight: LbSpacing.recentRowHeight,
          extendDividersToEnd: true,
        ),
      ],
    );
  }
}
