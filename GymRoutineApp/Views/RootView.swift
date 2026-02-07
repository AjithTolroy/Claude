import SwiftUI

struct RootView: View {
    @EnvironmentObject private var settings: UserSettingsViewModel

    var body: some View {
        Group {
            if settings.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            WorkoutListView()
                .tabItem {
                    Label("Workouts", systemImage: "figure.strengthtraining.traditional")
                }

            ProgressDashboardView()
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}
