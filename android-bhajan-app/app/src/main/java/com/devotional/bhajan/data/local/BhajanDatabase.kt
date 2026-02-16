package com.devotional.bhajan.data.local

import androidx.room.Database
import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Index
import androidx.room.PrimaryKey
import androidx.room.RoomDatabase
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Transaction
import kotlinx.coroutines.flow.Flow

@Entity(tableName = "gods")
data class GodEntity(
    @PrimaryKey val id: String,
    val name: String,
    val imageUrl: String,
    val description: String
)

@Entity(
    tableName = "bhajans",
    foreignKeys = [
        ForeignKey(
            entity = GodEntity::class,
            parentColumns = ["id"],
            childColumns = ["godId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index("godId")]
)
data class BhajanEntity(
    @PrimaryKey val id: String,
    val title: String,
    val singer: String,
    val duration: Long,
    val audioUrl: String,
    val localPath: String?,
    val lyrics: String,
    val godId: String,
    val isFavorite: Boolean = false,
    val isDownloaded: Boolean = false,
    val playCount: Int = 0,
    val lastPlayedAt: Long? = null
)

@Entity(tableName = "playlists")
data class PlaylistEntity(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val name: String,
    val createdAt: Long
)

@Entity(
    tableName = "playlist_songs",
    primaryKeys = ["playlistId", "songId"],
    foreignKeys = [
        ForeignKey(
            entity = PlaylistEntity::class,
            parentColumns = ["id"],
            childColumns = ["playlistId"],
            onDelete = ForeignKey.CASCADE
        ),
        ForeignKey(
            entity = BhajanEntity::class,
            parentColumns = ["id"],
            childColumns = ["songId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [Index("songId")]
)
data class PlaylistSongCrossRef(
    val playlistId: Long,
    val songId: String,
    val addedAt: Long
)

@Dao
interface GodDao {
    @Query("SELECT * FROM gods ORDER BY name")
    fun observeGods(): Flow<List<GodEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsertAll(gods: List<GodEntity>)
}

@Dao
interface BhajanDao {
    @Query("SELECT * FROM bhajans WHERE godId = :godId ORDER BY title")
    fun observeByGod(godId: String): Flow<List<BhajanEntity>>

    @Query("SELECT * FROM bhajans WHERE isDownloaded = 1 ORDER BY title")
    fun observeDownloaded(): Flow<List<BhajanEntity>>

    @Query("SELECT * FROM bhajans ORDER BY playCount DESC LIMIT :limit")
    fun observeTrending(limit: Int = 10): Flow<List<BhajanEntity>>

    @Query("SELECT * FROM bhajans WHERE lastPlayedAt IS NOT NULL ORDER BY lastPlayedAt DESC LIMIT :limit")
    fun observeRecent(limit: Int = 10): Flow<List<BhajanEntity>>

    @Query("UPDATE bhajans SET isFavorite = :isFavorite WHERE id = :id")
    suspend fun setFavorite(id: String, isFavorite: Boolean)

    @Query("UPDATE bhajans SET isDownloaded = 1, localPath = :localPath WHERE id = :id")
    suspend fun markDownloaded(id: String, localPath: String)

    @Query("UPDATE bhajans SET playCount = playCount + 1, lastPlayedAt = :playedAt WHERE id = :id")
    suspend fun incrementPlayCount(id: String, playedAt: Long)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun upsertAll(bhajans: List<BhajanEntity>)
}

@Dao
interface PlaylistDao {
    @Query("SELECT * FROM playlists ORDER BY createdAt DESC")
    fun observePlaylists(): Flow<List<PlaylistEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun create(playlist: PlaylistEntity): Long

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun addSong(ref: PlaylistSongCrossRef)

    @Query("DELETE FROM playlist_songs WHERE playlistId = :playlistId AND songId = :songId")
    suspend fun removeSong(playlistId: Long, songId: String)
}

@Database(
    entities = [GodEntity::class, BhajanEntity::class, PlaylistEntity::class, PlaylistSongCrossRef::class],
    version = 1,
    exportSchema = true
)
abstract class BhajanDatabase : RoomDatabase() {
    abstract fun godDao(): GodDao
    abstract fun bhajanDao(): BhajanDao
    abstract fun playlistDao(): PlaylistDao
}
