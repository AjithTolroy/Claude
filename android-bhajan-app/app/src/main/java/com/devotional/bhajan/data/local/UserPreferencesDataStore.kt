package com.devotional.bhajan.data.local

import android.content.Context
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Inject
import javax.inject.Singleton
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

private val Context.userPrefs by preferencesDataStore(name = "user_prefs")

@Singleton
class UserPreferencesDataStore @Inject constructor(
    @ApplicationContext private val context: Context
) {
    val language: Flow<String> = context.userPrefs.data.map { it[KEY_LANGUAGE] ?: "English" }
    val theme: Flow<String> = context.userPrefs.data.map { it[KEY_THEME] ?: "Saffron" }
    val reminderTime: Flow<String> = context.userPrefs.data.map { it[KEY_REMINDER_TIME] ?: "06:00" }
    val notificationSoundEnabled: Flow<Boolean> = context.userPrefs.data.map { it[KEY_NOTIFICATION_SOUND] ?: true }

    suspend fun setLanguage(value: String) = context.userPrefs.edit { it[KEY_LANGUAGE] = value }
    suspend fun setTheme(value: String) = context.userPrefs.edit { it[KEY_THEME] = value }
    suspend fun setReminderTime(value: String) = context.userPrefs.edit { it[KEY_REMINDER_TIME] = value }
    suspend fun setNotificationSoundEnabled(enabled: Boolean) = context.userPrefs.edit { it[KEY_NOTIFICATION_SOUND] = enabled }

    private companion object {
        val KEY_LANGUAGE = stringPreferencesKey("language")
        val KEY_THEME = stringPreferencesKey("theme")
        val KEY_REMINDER_TIME = stringPreferencesKey("reminder_time")
        val KEY_NOTIFICATION_SOUND = booleanPreferencesKey("notification_sound")
    }
}
