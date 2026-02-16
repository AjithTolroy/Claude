package com.devotional.bhajan.ui.home

import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp

@Composable
fun HomeScreen(
    state: HomeUiState,
    onSearchQueryChanged: (String) -> Unit,
    onGodClick: (String) -> Unit,
    onBhajanClick: (String) -> Unit
) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Spacer(modifier = Modifier.height(8.dp))
            OutlinedTextField(
                value = state.searchQuery,
                onValueChange = onSearchQueryChanged,
                modifier = Modifier.fillMaxWidth(),
                label = { Text("Search bhajans or gods") }
            )
        }

        item {
            Text("Gods", style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.SemiBold)
            Spacer(modifier = Modifier.height(8.dp))
            LazyVerticalGrid(
                columns = GridCells.Fixed(2),
                modifier = Modifier.height(360.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp),
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                items(state.gods) { god ->
                    Card(modifier = Modifier.clickable { onGodClick(god.id) }) {
                        Column(modifier = Modifier.padding(12.dp)) {
                            Image(
                                painter = painterResource(android.R.drawable.ic_menu_gallery),
                                contentDescription = god.name,
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(84.dp),
                                contentScale = ContentScale.Crop
                            )
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(god.name, style = MaterialTheme.typography.titleMedium)
                        }
                    }
                }
            }
        }

        item {
            Text("Recently Played", style = MaterialTheme.typography.titleLarge)
            LazyRow(contentPadding = PaddingValues(vertical = 8.dp), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                items(state.recentlyPlayed.size) { index ->
                    val bhajan = state.recentlyPlayed[index]
                    Card(modifier = Modifier.clickable { onBhajanClick(bhajan.id) }) {
                        Column(modifier = Modifier.padding(12.dp)) {
                            Text(bhajan.title, style = MaterialTheme.typography.titleMedium)
                            Text(bhajan.singer, style = MaterialTheme.typography.bodyMedium)
                        }
                    }
                }
            }
        }

        item {
            Text("Trending Bhajans", style = MaterialTheme.typography.titleLarge)
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                state.trending.forEach { bhajan ->
                    Card(modifier = Modifier
                        .fillMaxWidth()
                        .clickable { onBhajanClick(bhajan.id) }) {
                        Column(modifier = Modifier.padding(12.dp)) {
                            Text(bhajan.title, style = MaterialTheme.typography.titleMedium)
                            Text("${bhajan.singer} • ${bhajan.durationLabel}")
                        }
                    }
                }
            }
        }

        item { Spacer(modifier = Modifier.height(18.dp)) }
    }
}

data class HomeUiState(
    val searchQuery: String = "",
    val gods: List<GodUiModel> = emptyList(),
    val recentlyPlayed: List<BhajanUiModel> = emptyList(),
    val trending: List<BhajanUiModel> = emptyList()
)

data class GodUiModel(val id: String, val name: String, val imageUrl: String)
data class BhajanUiModel(val id: String, val title: String, val singer: String, val durationLabel: String)
