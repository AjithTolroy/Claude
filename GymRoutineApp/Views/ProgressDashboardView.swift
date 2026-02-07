import SwiftUI

struct ProgressDashboardView: View {
    @EnvironmentObject private var workoutPlan: WorkoutPlanViewModel
    @EnvironmentObject private var progress: ProgressViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    statCard(
                        title: "Weekly Completion",
                        value: "\(Int(progress.weeklyCompletionPercentage(plan: workoutPlan.workoutDays) * 100))%",
                        systemImage: "chart.pie.fill"
                    )

                    statCard(
                        title: "Workout Streak",
                        value: "\(progress.currentStreak) days",
                        systemImage: "flame.fill"
                    )

                    personalBestList
                    calendarSection
                }
                .padding()
            }
            .navigationTitle("Progress")
        }
    }

    private var personalBestList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Personal Bests")
                .font(.headline)

            ForEach(workoutPlan.workoutDays.flatMap(\.exercises), id: \.id) { exercise in
                let perf = workoutPlan.performance(for: exercise)
                if perf.personalBestWeight > 0 || perf.personalBestReps > 0 {
                    HStack {
                        Text(exercise.name)
                        Spacer()
                        Text("\(Int(perf.personalBestWeight))kg • \(perf.personalBestReps) reps")
                            .foregroundStyle(.secondary)
                    }
                    .font(.subheadline)
                }
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var calendarSection: some View {
        let dates = progress.completedDatesForCurrentMonth()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        return VStack(alignment: .leading, spacing: 10) {
            Text("This Month")
                .font(.headline)

            ForEach(dates, id: \.self) { date in
                Label(formatter.string(from: date), systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }

            if dates.isEmpty {
                Text("No workouts logged yet.")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func statCard(title: String, value: String, systemImage: String) -> some View {
        HStack {
            Label(title, systemImage: systemImage)
            Spacer()
            Text(value)
                .font(.title3.bold())
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
