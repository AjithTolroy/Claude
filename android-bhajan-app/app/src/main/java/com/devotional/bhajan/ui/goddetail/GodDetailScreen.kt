package com.devotional.bhajan.ui.goddetail

import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Download
import androidx.compose.material.icons.outlined.Favorite
import androidx.compose.material.icons.outlined.FavoriteBorder
import androidx.compose.material3.Card
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.devotional.bhajan.ui.home.BhajanUiModel

@Composable
fun GodDetailScreen(
    state: GodDetailUiState,
    onToggleFavorite: (String, Boolean) -> Unit,
    onDownload: (String) -> Unit,
    onPlay: (String) -> Unit
) {
    LazyColumn(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        item {
            Image(
                painter = painterResource(android.R.drawable.ic_menu_gallery),
                contentDescription = state.godName,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(220.dp),
                contentScale = ContentScale.Crop
            )
            Column(modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp)) {
                Text(state.godName, style = MaterialTheme.typography.headlineMedium, fontWeight = FontWeight.Bold)
                Text(state.description, style = MaterialTheme.typography.bodyLarge)
            }
        }

        items(state.bhajans) { bhajan ->
            Card(modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp)) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(12.dp),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Text(bhajan.title, style = MaterialTheme.typography.titleMedium)
                        Spacer(modifier = Modifier.height(4.dp))
                        Text("${bhajan.singer} • ${bhajan.durationLabel}")
                    }
                    Row {
                        IconButton(onClick = { onToggleFavorite(bhajan.id, !bhajan.isFavorite) }) {
                            Icon(
                                imageVector = if (bhajan.isFavorite) Icons.Outlined.Favorite else Icons.Outlined.FavoriteBorder,
                                contentDescription = "favorite"
                            )
                        }
                        IconButton(onClick = { onDownload(bhajan.id) }) {
                            Icon(Icons.Outlined.Download, contentDescription = "download")
                        }
                        IconButton(onClick = { onPlay(bhajan.id) }) {
                            Text("Play")
                        }
                    }
                }
            }
        }
    }
}

data class GodDetailUiState(
    val godName: String = "",
    val description: String = "",
    val bhajans: List<GodBhajanUiModel> = emptyList()
)

data class GodBhajanUiModel(
    val id: String,
    val title: String,
    val singer: String,
    val durationLabel: String,
    val isFavorite: Boolean,
    val isDownloaded: Boolean
)
