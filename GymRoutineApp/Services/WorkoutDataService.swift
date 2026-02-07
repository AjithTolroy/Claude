import Foundation

final class WorkoutDataService {
    static let shared = WorkoutDataService()

    private init() {}

    func weeklySplit(for level: FitnessLevel) -> [WorkoutDay] {
        Weekday.allCases.map { day in
            WorkoutDay(id: UUID(), weekday: day, exercises: adjustedExercises(for: day, level: level))
        }
    }

    private func adjustedExercises(for day: Weekday, level: FitnessLevel) -> [Exercise] {
        baseExercises(for: day).map { exercise in
            var copy = exercise
            copy.sets = max(2, Int(Double(exercise.sets) * level.setMultiplier))
            copy.reps = max(6, exercise.reps + level.repAdjustment)
            return copy
        }
    }

    private func baseExercises(for day: Weekday) -> [Exercise] {
        switch day {
        case .monday:
            return [
                makeExercise(name: "Barbell Bench Press", muscle: .chest, sets: 4, reps: 10, range: 8...12, rest: 90, difficulty: .intermediate, equipment: ["Barbell", "Bench"], alternatives: ["Machine Chest Press", "Dumbbell Bench Press"]),
                makeExercise(name: "Incline Dumbbell Press", muscle: .chest, sets: 3, reps: 12, range: 10...12, rest: 75, difficulty: .beginner, equipment: ["Dumbbells", "Incline Bench"], alternatives: ["Incline Smith Press"]),
                makeExercise(name: "Cable Triceps Pushdown", muscle: .triceps, sets: 3, reps: 12, range: 10...15, rest: 60, difficulty: .beginner, equipment: ["Cable Machine", "Rope Attachment"], alternatives: ["EZ Bar Pushdown", "Dips"])
            ]
        case .tuesday:
            return [
                makeExercise(name: "Lat Pulldown", muscle: .back, sets: 4, reps: 10, range: 8...12, rest: 90, difficulty: .beginner, equipment: ["Lat Pulldown Machine"], alternatives: ["Assisted Pull-Up"]),
                makeExercise(name: "Seated Cable Row", muscle: .back, sets: 3, reps: 12, range: 10...12, rest: 75, difficulty: .intermediate, equipment: ["Cable Machine", "V Bar"], alternatives: ["Chest-Supported Row"]),
                makeExercise(name: "Alternating Dumbbell Curl", muscle: .biceps, sets: 3, reps: 12, range: 10...15, rest: 60, difficulty: .beginner, equipment: ["Dumbbells"], alternatives: ["Cable Curl", "Machine Curl"])
            ]
        case .wednesday:
            return [
                makeExercise(name: "Back Squat", muscle: .legs, sets: 4, reps: 8, range: 6...10, rest: 120, difficulty: .advanced, equipment: ["Barbell", "Rack"], alternatives: ["Hack Squat", "Leg Press"]),
                makeExercise(name: "Romanian Deadlift", muscle: .legs, sets: 3, reps: 10, range: 8...12, rest: 90, difficulty: .intermediate, equipment: ["Barbell"], alternatives: ["Dumbbell RDL"]),
                makeExercise(name: "Plank", muscle: .core, sets: 3, reps: 1, range: 1...1, rest: 45, difficulty: .beginner, equipment: ["Bodyweight"], alternatives: ["Dead Bug", "Stir the Pot"])
            ]
        case .thursday:
            return [
                makeExercise(name: "Seated Dumbbell Shoulder Press", muscle: .shoulders, sets: 4, reps: 10, range: 8...12, rest: 90, difficulty: .intermediate, equipment: ["Dumbbells", "Bench"], alternatives: ["Machine Shoulder Press"]),
                makeExercise(name: "Lateral Raise", muscle: .shoulders, sets: 3, reps: 15, range: 12...20, rest: 60, difficulty: .beginner, equipment: ["Dumbbells"], alternatives: ["Cable Lateral Raise"]),
                makeExercise(name: "Cable Crunch", muscle: .abs, sets: 3, reps: 15, range: 12...20, rest: 45, difficulty: .beginner, equipment: ["Cable Machine"], alternatives: ["Machine Crunch", "Reverse Crunch"])
            ]
        case .friday:
            return [
                makeExercise(name: "Kettlebell Swing", muscle: .conditioning, sets: 4, reps: 15, range: 12...20, rest: 60, difficulty: .intermediate, equipment: ["Kettlebell"], alternatives: ["Battle Ropes"]),
                makeExercise(name: "Walking Lunge", muscle: .fullBody, sets: 3, reps: 12, range: 10...14, rest: 75, difficulty: .intermediate, equipment: ["Dumbbells"], alternatives: ["Reverse Lunge"]),
                makeExercise(name: "Push-Up", muscle: .fullBody, sets: 3, reps: 15, range: 10...20, rest: 60, difficulty: .beginner, equipment: ["Bodyweight"], alternatives: ["Incline Push-Up", "Machine Chest Press"])
            ]
        }
    }

    private func makeExercise(name: String,
                              muscle: MuscleGroup,
                              sets: Int,
                              reps: Int,
                              range: ClosedRange<Int>,
                              rest: Int,
                              difficulty: DifficultyLevel,
                              equipment: [String],
                              alternatives: [String]) -> Exercise {
        Exercise(
            id: UUID(),
            name: name,
            muscleGroup: muscle,
            primaryMuscles: [muscle.displayName],
            secondaryMuscles: ["Stabilizers"],
            sets: sets,
            reps: reps,
            targetRepRange: range,
            restSeconds: rest,
            difficulty: difficulty,
            equipment: equipment,
            instructions: [
                "Set up with a neutral spine and engaged core.",
                "Move with control through the full range of motion.",
                "Exhale during the effort phase and inhale on return."
            ],
            commonMistakes: [
                "Using momentum instead of muscle control.",
                "Cutting range of motion short.",
                "Losing trunk tension."
            ],
            safetyTips: [
                "Start with a manageable load and progress gradually.",
                "Stop if you feel sharp pain.",
                "Ask for a spotter for heavy compounds."
            ],
            startImageURL: URL(string: "https://images.pexels.com/photos/4162487/pexels-photo-4162487.jpeg")!,
            endImageURL: URL(string: "https://images.pexels.com/photos/3838389/pexels-photo-3838389.jpeg")!,
            animationURL: URL(string: "https://cdn.dribbble.com/users/1292677/screenshots/6139167/media/2f7f9f31a36f6b2e2b2f5c89b17d95f3.gif"),
            alternatives: alternatives
        )
    }
}
