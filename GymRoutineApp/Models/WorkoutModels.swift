import Foundation

enum DifficultyLevel: String, Codable, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var id: String { rawValue }
}

enum FitnessLevel: String, Codable, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var id: String { rawValue }

    var setMultiplier: Double {
        switch self {
        case .beginner: return 0.75
        case .intermediate: return 1.0
        case .advanced: return 1.2
        }
    }

    var repAdjustment: Int {
        switch self {
        case .beginner: return -2
        case .intermediate: return 0
        case .advanced: return 2
        }
    }
}

enum MuscleGroup: String, Codable, CaseIterable, Identifiable {
    case chest, triceps, back, biceps, legs, core, shoulders, abs, fullBody, conditioning

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .fullBody: return "Full Body"
        default: return rawValue.capitalized
        }
    }

    var colorHex: String {
        switch self {
        case .chest: return "#FF6B6B"
        case .triceps: return "#F06595"
        case .back: return "#4DABF7"
        case .biceps: return "#748FFC"
        case .legs: return "#69DB7C"
        case .core: return "#FFA94D"
        case .shoulders: return "#845EF7"
        case .abs: return "#FCC419"
        case .fullBody: return "#20C997"
        case .conditioning: return "#339AF0"
        }
    }
}

enum Weekday: String, Codable, CaseIterable, Identifiable {
    case monday, tuesday, wednesday, thursday, friday

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }

    var focus: String {
        switch self {
        case .monday: return "Chest + Triceps"
        case .tuesday: return "Back + Biceps"
        case .wednesday: return "Legs + Core"
        case .thursday: return "Shoulders + Abs"
        case .friday: return "Full Body / Conditioning"
        }
    }
}

struct Exercise: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var muscleGroup: MuscleGroup
    var primaryMuscles: [String]
    var secondaryMuscles: [String]
    var sets: Int
    var reps: Int
    var targetRepRange: ClosedRange<Int>
    var restSeconds: Int
    var difficulty: DifficultyLevel
    var equipment: [String]
    var instructions: [String]
    var commonMistakes: [String]
    var safetyTips: [String]
    var startImageURL: URL
    var endImageURL: URL
    var animationURL: URL?
    var alternatives: [String]
}

struct WorkoutDay: Identifiable, Codable {
    let id: UUID
    var weekday: Weekday
    var exercises: [Exercise]
}

struct ExercisePerformance: Codable {
    var completedSets: Int
    var weight: Double
    var achievedReps: Int
    var isFavorite: Bool
    var personalBestWeight: Double
    var personalBestReps: Int
}

struct WorkoutProgressEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var weekday: Weekday
    var completedExerciseIDs: Set<UUID>
}
