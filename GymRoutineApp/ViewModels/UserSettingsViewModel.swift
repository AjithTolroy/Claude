import SwiftUI

final class UserSettingsViewModel: ObservableObject {
    @Published var fitnessLevel: FitnessLevel {
        didSet { StorageService.shared.saveFitnessLevel(fitnessLevel) }
    }
    @Published var darkModeEnabled: Bool {
        didSet { StorageService.shared.setDarkModeEnabled(darkModeEnabled) }
    }
    @Published var hasCompletedOnboarding: Bool {
        didSet { StorageService.shared.setCompletedOnboarding(hasCompletedOnboarding) }
    }

    init() {
        self.fitnessLevel = StorageService.shared.loadFitnessLevel()
        self.darkModeEnabled = StorageService.shared.darkModeEnabled()
        self.hasCompletedOnboarding = StorageService.shared.hasCompletedOnboarding()
    }

    var preferredColorScheme: ColorScheme? {
        darkModeEnabled ? .dark : .light
    }
}
