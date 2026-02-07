import SwiftUI

struct WorkoutListView: View {
    @EnvironmentObject private var workoutPlan: WorkoutPlanViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Day", selection: $workoutPlan.selectedDay) {
                    ForEach(Weekday.allCases) { day in
                        Text(day.title).tag(day)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List {
                    Section {
                        Text(workoutPlan.selectedDay.focus)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        ProgressView(value: workoutPlan.completionRate(for: workoutPlan.selectedDay))
                    }

                    ForEach(workoutPlan.exercises(for: workoutPlan.selectedDay)) { exercise in
                        NavigationLink {
                            ExerciseDetailView(exercise: exercise, weekday: workoutPlan.selectedDay)
                        } label: {
                            ExerciseCardView(exercise: exercise)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Weekly Split")
        }
    }
}

struct ExerciseCardView: View {
    let exercise: Exercise

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: exercise.startImageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Rectangle().fill(.gray.opacity(0.2))
                }
            }
            .frame(width: 92, height: 92)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 6) {
                Text(exercise.name)
                    .font(.headline)
                Text(exercise.muscleGroup.displayName)
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color(hex: exercise.muscleGroup.colorHex).opacity(0.2))
                    .clipShape(Capsule())

                HStack {
                    Text("\(exercise.sets) × \(exercise.reps)")
                    Text("Target \(exercise.targetRepRange.lowerBound)-\(exercise.targetRepRange.upperBound)")
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                Text("Rest \(exercise.restSeconds)s • \(exercise.difficulty.rawValue)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}
