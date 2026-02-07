import Foundation

final class WorkoutPlanViewModel: ObservableObject {
    @Published var workoutDays: [WorkoutDay] = []
    @Published var selectedDay: Weekday = .monday
    @Published var performanceMap: [UUID: ExercisePerformance]

    init() {
        self.performanceMap = StorageService.shared.loadPerformance()
        refreshPlan(for: StorageService.shared.loadFitnessLevel())
    }

    func refreshPlan(for level: FitnessLevel) {
        workoutDays = WorkoutDataService.shared.weeklySplit(for: level)
        seedMissingPerformanceEntries()
    }

    func exercises(for day: Weekday) -> [Exercise] {
        workoutDays.first(where: { $0.weekday == day })?.exercises ?? []
    }

    func markSetCompleted(for exercise: Exercise) {
        var performance = performanceMap[exercise.id] ?? ExercisePerformance(completedSets: 0, weight: 0, achievedReps: exercise.reps, isFavorite: false, personalBestWeight: 0, personalBestReps: 0)
        performance.completedSets = min(exercise.sets, performance.completedSets + 1)
        performance.personalBestReps = max(performance.personalBestReps, performance.achievedReps)
        performanceMap[exercise.id] = performance
        persistPerformance()
    }

    func updateWeight(for exercise: Exercise, delta: Double) {
        var performance = performanceMap[exercise.id] ?? ExercisePerformance(completedSets: 0, weight: 0, achievedReps: exercise.reps, isFavorite: false, personalBestWeight: 0, personalBestReps: 0)
        performance.weight = max(0, performance.weight + delta)
        performance.personalBestWeight = max(performance.personalBestWeight, performance.weight)
        performanceMap[exercise.id] = performance
        persistPerformance()
    }

    func updateReps(for exercise: Exercise, delta: Int) {
        var performance = performanceMap[exercise.id] ?? ExercisePerformance(completedSets: 0, weight: 0, achievedReps: exercise.reps, isFavorite: false, personalBestWeight: 0, personalBestReps: 0)
        performance.achievedReps = max(1, performance.achievedReps + delta)
        performance.personalBestReps = max(performance.personalBestReps, performance.achievedReps)
        performanceMap[exercise.id] = performance
        persistPerformance()
    }

    func toggleFavorite(for exercise: Exercise) {
        var performance = performanceMap[exercise.id] ?? ExercisePerformance(completedSets: 0, weight: 0, achievedReps: exercise.reps, isFavorite: false, personalBestWeight: 0, personalBestReps: 0)
        performance.isFavorite.toggle()
        performanceMap[exercise.id] = performance
        persistPerformance()
    }

    func completionRate(for day: Weekday) -> Double {
        let exercises = exercises(for: day)
        guard !exercises.isEmpty else { return 0 }
        let completed = exercises.filter {
            (performanceMap[$0.id]?.completedSets ?? 0) >= $0.sets
        }.count
        return Double(completed) / Double(exercises.count)
    }

    func performance(for exercise: Exercise) -> ExercisePerformance {
        performanceMap[exercise.id] ?? ExercisePerformance(completedSets: 0, weight: 0, achievedReps: exercise.reps, isFavorite: false, personalBestWeight: 0, personalBestReps: 0)
    }

    private func seedMissingPerformanceEntries() {
        for day in workoutDays {
            for exercise in day.exercises where performanceMap[exercise.id] == nil {
                performanceMap[exercise.id] = ExercisePerformance(completedSets: 0, weight: 0, achievedReps: exercise.reps, isFavorite: false, personalBestWeight: 0, personalBestReps: 0)
            }
        }
        persistPerformance()
    }

    private func persistPerformance() {
        StorageService.shared.savePerformance(performanceMap)
    }
}
