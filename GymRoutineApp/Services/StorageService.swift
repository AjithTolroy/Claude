import Foundation

final class StorageService {
    static let shared = StorageService()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let fitnessLevel = "fitnessLevel"
        static let preferredDarkMode = "preferredDarkMode"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let performance = "exercisePerformance"
        static let progressEntries = "progressEntries"
    }

    private init() {}

    func saveFitnessLevel(_ level: FitnessLevel) {
        defaults.set(level.rawValue, forKey: Keys.fitnessLevel)
    }

    func loadFitnessLevel() -> FitnessLevel {
        guard let raw = defaults.string(forKey: Keys.fitnessLevel),
              let level = FitnessLevel(rawValue: raw) else {
            return .beginner
        }
        return level
    }

    func setDarkModeEnabled(_ enabled: Bool) {
        defaults.set(enabled, forKey: Keys.preferredDarkMode)
    }

    func darkModeEnabled() -> Bool {
        defaults.bool(forKey: Keys.preferredDarkMode)
    }

    func setCompletedOnboarding(_ value: Bool) {
        defaults.set(value, forKey: Keys.hasCompletedOnboarding)
    }

    func hasCompletedOnboarding() -> Bool {
        defaults.bool(forKey: Keys.hasCompletedOnboarding)
    }

    func savePerformance(_ map: [UUID: ExercisePerformance]) {
        let serializable = map.reduce(into: [String: ExercisePerformance]()) { acc, pair in
            acc[pair.key.uuidString] = pair.value
        }
        if let data = try? JSONEncoder().encode(serializable) {
            defaults.set(data, forKey: Keys.performance)
        }
    }

    func loadPerformance() -> [UUID: ExercisePerformance] {
        guard let data = defaults.data(forKey: Keys.performance),
              let decoded = try? JSONDecoder().decode([String: ExercisePerformance].self, from: data) else {
            return [:]
        }
        return decoded.reduce(into: [UUID: ExercisePerformance]()) { acc, pair in
            if let id = UUID(uuidString: pair.key) {
                acc[id] = pair.value
            }
        }
    }

    func saveProgressEntries(_ entries: [WorkoutProgressEntry]) {
        if let data = try? JSONEncoder().encode(entries) {
            defaults.set(data, forKey: Keys.progressEntries)
        }
    }

    func loadProgressEntries() -> [WorkoutProgressEntry] {
        guard let data = defaults.data(forKey: Keys.progressEntries),
              let decoded = try? JSONDecoder().decode([WorkoutProgressEntry].self, from: data) else {
            return []
        }
        return decoded
    }
}
