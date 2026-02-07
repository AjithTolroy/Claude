import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    let weekday: Weekday

    @EnvironmentObject private var workoutPlan: WorkoutPlanViewModel
    @EnvironmentObject private var progress: ProgressViewModel

    @State private var restRemaining = 0
    @State private var timerRunning = false
    @State private var showCompletionBanner = false
    @State private var timer: Timer?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                imageStrip

                if let animationURL = exercise.animationURL {
                    Link(destination: animationURL) {
                        Label("View animated demo", systemImage: "play.circle")
                            .font(.headline)
                    }
                }

                detailsSection
                instructionSection
                mistakeSection
                safetySection
                trackingSection

                if showCompletionBanner {
                    Label("Workout completed 🎉", systemImage: "checkmark.seal.fill")
                        .font(.headline)
                        .foregroundStyle(.green)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding()
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { timer?.invalidate() }
    }

    private var imageStrip: some View {
        HStack(spacing: 12) {
            AsyncImage(url: exercise.startImageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .padding(24)
                        .foregroundStyle(.secondary)
                        .background(.gray.opacity(0.15))
                }
            }
            .frame(height: 170)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            AsyncImage(url: exercise.endImageURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .padding(24)
                        .foregroundStyle(.secondary)
                        .background(.gray.opacity(0.15))
                }
            }
            .frame(height: 170)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Muscles")
                .font(.headline)
            Text("Primary: \(exercise.primaryMuscles.joined(separator: ", "))")
            Text("Secondary: \(exercise.secondaryMuscles.joined(separator: ", "))")
            Text("Equipment: \(exercise.equipment.joined(separator: ", "))")
            Text("Alternatives: \(exercise.alternatives.joined(separator: ", "))")
                .foregroundStyle(.secondary)
        }
    }

    private var instructionSection: some View {
        bulletSection(title: "How to perform", items: exercise.instructions)
    }

    private var mistakeSection: some View {
        bulletSection(title: "Common mistakes", items: exercise.commonMistakes)
    }

    private var safetySection: some View {
        bulletSection(title: "Safety tips", items: exercise.safetyTips)
    }

    private var trackingSection: some View {
        let performance = workoutPlan.performance(for: exercise)

        return VStack(alignment: .leading, spacing: 12) {
            Text("Set Tracking")
                .font(.headline)

            HStack {
                Label("\(performance.completedSets)/\(exercise.sets)", systemImage: "checkmark.circle")
                Spacer()
                Button("Mark Set Complete") {
                    workoutPlan.markSetCompleted(for: exercise)
                    progress.markExerciseComplete(day: weekday, exerciseID: exercise.id)
                    if workoutPlan.performance(for: exercise).completedSets == exercise.sets {
                        withAnimation { showCompletionBanner = true }
                    }
                }
                .buttonStyle(.borderedProminent)
            }

            Stepper("Weight: \(Int(performance.weight)) kg", onIncrement: {
                workoutPlan.updateWeight(for: exercise, delta: 2.5)
            }, onDecrement: {
                workoutPlan.updateWeight(for: exercise, delta: -2.5)
            })

            Stepper("Reps achieved: \(performance.achievedReps)", onIncrement: {
                workoutPlan.updateReps(for: exercise, delta: 1)
            }, onDecrement: {
                workoutPlan.updateReps(for: exercise, delta: -1)
            })

            HStack {
                Text(restRemaining > 0 ? "Rest: \(restRemaining)s" : "Ready for next set")
                Spacer()
                Button(timerRunning ? "Pause" : "Start Rest") {
                    toggleRestTimer(defaultDuration: exercise.restSeconds)
                }
            }

            Button {
                workoutPlan.toggleFavorite(for: exercise)
            } label: {
                Label(performance.isFavorite ? "Remove Favorite" : "Save Favorite", systemImage: performance.isFavorite ? "heart.fill" : "heart")
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func bulletSection(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            ForEach(items, id: \.self) { item in
                Label(item, systemImage: "circle.fill")
                    .font(.subheadline)
            }
        }
    }

    private func toggleRestTimer(defaultDuration: Int) {
        if timerRunning {
            timer?.invalidate()
            timerRunning = false
            return
        }

        restRemaining = max(restRemaining, defaultDuration)
        timerRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if restRemaining > 0 {
                restRemaining -= 1
            } else {
                timerRunning = false
                t.invalidate()
            }
        }
    }
}
