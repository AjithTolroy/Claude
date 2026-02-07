import SwiftUI

@main
struct GymRoutineApp: App {
    @StateObject private var settingsViewModel = UserSettingsViewModel()
    @StateObject private var workoutPlanViewModel = WorkoutPlanViewModel()
    @StateObject private var progressViewModel = ProgressViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(settingsViewModel)
                .environmentObject(workoutPlanViewModel)
                .environmentObject(progressViewModel)
                .preferredColorScheme(settingsViewModel.preferredColorScheme)
        }
    }
}
