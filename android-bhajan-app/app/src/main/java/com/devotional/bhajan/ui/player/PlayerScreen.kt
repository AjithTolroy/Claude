package com.devotional.bhajan.ui.player

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Pause
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.outlined.Forward10
import androidx.compose.material.icons.outlined.Loop
import androidx.compose.material.icons.outlined.Replay10
import androidx.compose.material.icons.outlined.Shuffle
import androidx.compose.material.icons.outlined.Timer
import androidx.compose.material3.Button
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Slider
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp

@Composable
fun PlayerScreen(
    state: PlayerUiState,
    onPlayPause: () -> Unit,
    onSeek: (Float) -> Unit,
    onForward15: () -> Unit,
    onBack15: () -> Unit,
    onToggleShuffle: () -> Unit,
    onCycleRepeat: () -> Unit,
    onAddToPlaylist: () -> Unit,
    onSleepTimerClick: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Image(
            painter = painterResource(android.R.drawable.ic_menu_gallery),
            contentDescription = state.title,
            modifier = Modifier
                .fillMaxWidth()
                .height(280.dp),
            contentScale = ContentScale.Crop
        )
        Spacer(modifier = Modifier.height(12.dp))
        Text(state.title, style = MaterialTheme.typography.headlineSmall, textAlign = TextAlign.Center)
        Text(state.singer, style = MaterialTheme.typography.titleMedium)

        Spacer(modifier = Modifier.height(14.dp))
        Slider(
            value = state.progress,
            onValueChange = onSeek,
            modifier = Modifier.fillMaxWidth()
        )
        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Text(state.elapsedLabel)
            Text(state.durationLabel)
        }

        Spacer(modifier = Modifier.height(6.dp))
        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            IconButton(onClick = onToggleShuffle) { Icon(Icons.Outlined.Shuffle, contentDescription = "shuffle") }
            IconButton(onClick = onBack15) { Icon(Icons.Outlined.Replay10, contentDescription = "back 15") }
            IconButton(onClick = onPlayPause) {
                Icon(
                    imageVector = if (state.isPlaying) Icons.Default.Pause else Icons.Default.PlayArrow,
                    contentDescription = "play pause"
                )
            }
            IconButton(onClick = onForward15) { Icon(Icons.Outlined.Forward10, contentDescription = "forward 15") }
            IconButton(onClick = onCycleRepeat) { Icon(Icons.Outlined.Loop, contentDescription = "repeat") }
        }

        Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            Button(onClick = onAddToPlaylist) {
                Icon(Icons.Default.Add, contentDescription = null)
                Text(" Playlist")
            }
            Button(onClick = onSleepTimerClick) {
                Icon(Icons.Outlined.Timer, contentDescription = null)
                Text(" Sleep timer")
            }
        }

        Spacer(modifier = Modifier.height(18.dp))
        Text("Lyrics", style = MaterialTheme.typography.titleLarge)
        Text(
            state.lyrics,
            style = MaterialTheme.typography.bodyLarge,
            modifier = Modifier.fillMaxWidth()
        )
    }
}

data class PlayerUiState(
    val title: String = "",
    val singer: String = "",
    val isPlaying: Boolean = false,
    val progress: Float = 0f,
    val elapsedLabel: String = "00:00",
    val durationLabel: String = "00:00",
    val lyrics: String = ""
)
