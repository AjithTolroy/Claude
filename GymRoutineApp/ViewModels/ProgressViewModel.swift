import Foundation

final class ProgressViewModel: ObservableObject {
    @Published var entries: [WorkoutProgressEntry]

    init() {
        self.entries = StorageService.shared.loadProgressEntries()
    }

    func markExerciseComplete(day: Weekday, exerciseID: UUID) {
        let today = Calendar.current.startOfDay(for: Date())

        if let index = entries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) && $0.weekday == day }) {
            entries[index].completedExerciseIDs.insert(exerciseID)
        } else {
            let newEntry = WorkoutProgressEntry(id: UUID(), date: today, weekday: day, completedExerciseIDs: [exerciseID])
            entries.append(newEntry)
        }

        persist()
    }

    func weeklyCompletionPercentage(plan: [WorkoutDay]) -> Double {
        guard !plan.isEmpty else { return 0 }
        let total = plan.reduce(0) { $0 + $1.exercises.count }
        guard total > 0 else { return 0 }

        let startOfWeek = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        let completed = entries
            .filter { $0.date >= startOfWeek }
            .reduce(0) { $0 + $1.completedExerciseIDs.count }

        return min(1.0, Double(completed) / Double(total))
    }

    var currentStreak: Int {
        let days = Set(entries.map { Calendar.current.startOfDay(for: $0.date) })
        guard !days.isEmpty else { return 0 }

        var streak = 0
        var cursor = Calendar.current.startOfDay(for: Date())

        while days.contains(cursor) {
            streak += 1
            guard let prev = Calendar.current.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = prev
        }

        return streak
    }

    func completedDatesForCurrentMonth() -> [Date] {
        let monthInterval = Calendar.current.dateInterval(of: .month, for: Date())
        return entries
            .map { Calendar.current.startOfDay(for: $0.date) }
            .filter { date in
                guard let interval = monthInterval else { return false }
                return interval.contains(date)
            }
    }

    private func persist() {
        StorageService.shared.saveProgressEntries(entries)
    }
}
