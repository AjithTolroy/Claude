package com.devotional.bhajan.player

import android.content.Context
import androidx.media3.common.MediaItem
import androidx.media3.common.Player
import androidx.media3.exoplayer.ExoPlayer
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Inject
import javax.inject.Singleton
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

@Singleton
class ExoPlayerManager @Inject constructor(
    @ApplicationContext private val context: Context
) {
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)

    private val exoPlayer: ExoPlayer by lazy {
        ExoPlayer.Builder(context).build().apply {
            addListener(object : Player.Listener {
                override fun onIsPlayingChanged(isPlaying: Boolean) {
                    _state.update { it.copy(isPlaying = isPlaying) }
                }

                override fun onMediaItemTransition(mediaItem: MediaItem?, reason: Int) {
                    _state.update {
                        it.copy(
                            currentMediaId = mediaItem?.mediaId,
                            title = mediaItem?.mediaMetadata?.title?.toString().orEmpty(),
                            artist = mediaItem?.mediaMetadata?.artist?.toString().orEmpty()
                        )
                    }
                }

                override fun onPlaybackStateChanged(playbackState: Int) {
                    _state.update { it.copy(playbackState = playbackState) }
                }
            })
        }
    }

    private val _state = MutableStateFlow(PlaybackState())
    val state: StateFlow<PlaybackState> = _state.asStateFlow()

    fun setQueue(items: List<MediaItem>, startIndex: Int = 0) {
        exoPlayer.setMediaItems(items, startIndex, 0L)
        exoPlayer.prepare()
        _state.update { it.copy(queueSize = items.size) }
    }

    fun play() = exoPlayer.play()
    fun pause() = exoPlayer.pause()
    fun seekTo(positionMs: Long) = exoPlayer.seekTo(positionMs)
    fun seekForward15() = exoPlayer.seekForward()
    fun seekBack15() = exoPlayer.seekBack()

    fun toggleShuffle() {
        exoPlayer.shuffleModeEnabled = !exoPlayer.shuffleModeEnabled
        _state.update { it.copy(shuffleEnabled = exoPlayer.shuffleModeEnabled) }
    }

    fun cycleRepeatMode() {
        exoPlayer.repeatMode = when (exoPlayer.repeatMode) {
            Player.REPEAT_MODE_OFF -> Player.REPEAT_MODE_ONE
            Player.REPEAT_MODE_ONE -> Player.REPEAT_MODE_ALL
            else -> Player.REPEAT_MODE_OFF
        }
        _state.update { it.copy(repeatMode = exoPlayer.repeatMode) }
    }

    fun startProgressUpdates() {
        scope.launch {
            while (true) {
                _state.update {
                    it.copy(
                        positionMs = exoPlayer.currentPosition,
                        durationMs = exoPlayer.duration.coerceAtLeast(0)
                    )
                }
                kotlinx.coroutines.delay(500)
            }
        }
    }

    fun playerInstance(): ExoPlayer = exoPlayer

    fun release() {
        exoPlayer.release()
    }
}

data class PlaybackState(
    val currentMediaId: String? = null,
    val title: String = "",
    val artist: String = "",
    val isPlaying: Boolean = false,
    val positionMs: Long = 0,
    val durationMs: Long = 0,
    val shuffleEnabled: Boolean = false,
    val repeatMode: Int = Player.REPEAT_MODE_OFF,
    val queueSize: Int = 0,
    val playbackState: Int = Player.STATE_IDLE
)
