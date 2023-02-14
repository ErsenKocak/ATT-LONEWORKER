import 'dart:async';
import 'dart:developer';

import 'package:att_loneworker/bloc/alarm_state/alarm_state_cubit.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

import '../../core/init/locator.dart';
import '../navigation/navigation_helper.dart';

class AudioPlayerHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  bool isPlaying = false;
  final _logger = getIt<Logger>();
  late StreamSubscription<PlayerState> _playerStateStreamSub;
  late AlarmStateCubit _alarmStateCubit;

  AudioPlayerHandler({LoopMode? loopMode}) {
    _player.setAsset("assets/sounds/alarm/alarm.wav");
    _player.setLoopMode(loopMode ?? LoopMode.one);
  }

  initializeStream() {
    if (NavigationHelper.navigatorKey.currentContext != null) {
      _alarmStateCubit =
          BlocProvider.of(NavigationHelper.navigatorKey.currentContext!);
    }
    _playerStateStreamSub = _player.playerStateStream.listen((event) {
      log('playerStateStream $event');
      _alarmStateCubit.emitState(value: event.playing);
    });
  }

  Future<void> play() async {
    // if (isPlaying == false) {
    //   isPlaying = true;
    //   await _player.play();
    //   _logger.wtf('Çalıştı');
    //   isPlaying = false;
    // }

    log('Volume ${_player.volume} ');
    log('LoopMode ${_player.loopMode} ');
    if (_player.playing == true) {
      _player.stop();
    } else {
      await _player.play().then((value) async {
        _player.stop();
        // await setLoopmode(LoopMode.all);
      });
    }
    log('State ${_player.playing}');
    log('Loop Mode${_player.loopMode}');

    // await _player.pause();
  }

  Future<void> playEveryThing() async {
    _player.play();
  }

  Future<void> playerStop() => _player.stop();
  Future<void> setPlayerVolume({required double volume}) =>
      _player.setVolume(volume);

  Future<void> pause() async {
    _player.pause();
    isPlaying = false;
  }

  @override
  PlayerState playerState() => _player.playerState;

  Future setLoopmode(LoopMode mode) async =>
      await _player.setLoopMode(mode).then((value) => Future.value(true));
  playerIsPlaying() => _player.playing;
}
