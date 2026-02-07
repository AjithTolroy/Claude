import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: UserSettingsViewModel
    @EnvironmentObject private var workoutPlan: WorkoutPlanViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Training Level") {
                    Picker("Fitness Level", selection: $settings.fitnessLevel) {
                        ForEach(FitnessLevel.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .onChange(of: settings.fitnessLevel) { _, newValue in
                        workoutPlan.refreshPlan(for: newValue)
                    }
                }

                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $settings.darkModeEnabled)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
