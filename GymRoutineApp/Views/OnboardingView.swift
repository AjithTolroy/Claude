import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var settings: UserSettingsViewModel
    @EnvironmentObject private var workoutPlan: WorkoutPlanViewModel

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Welcome to Gym Routine")
                    .font(.largeTitle.weight(.bold))
                Text("Choose your fitness level so sets and reps are auto-adjusted.")
                    .foregroundStyle(.secondary)

                ForEach(FitnessLevel.allCases) { level in
                    Button {
                        settings.fitnessLevel = level
                        workoutPlan.refreshPlan(for: level)
                    } label: {
                        HStack {
                            Text(level.rawValue)
                                .font(.headline)
                            Spacer()
                            if settings.fitnessLevel == level {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)
                }

                Toggle("Enable dark mode", isOn: $settings.darkModeEnabled)
                    .padding(.top)

                Button("Continue") {
                    settings.hasCompletedOnboarding = true
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)

                Spacer()
            }
            .padding()
        }
    }
}
