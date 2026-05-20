import Foundation
import SwiftUI

class VisionTestManager: ObservableObject {
    @Published var currentEye: EyeSide = .right
    @Published var currentLevelIndex = 0
    @Published var currentDirection: LandoltDirection = .up
    @Published var correctInRow = 0
    @Published var wrongInRow = 0
    @Published var totalCorrect = 0
    @Published var totalAttempts = 0
    @Published var isTestActive = false
    @Published var isTestComplete = false
    @Published var lastResult: VisionResult?
    @Published var history: [VisionResult] = []
    @Published var testDistance: Double = 3.0 // meters (adjustable for phone use)

    private let questionsPerLevel = 3
    private let correctToAdvance = 2
    private let wrongToFail = 2

    init() {
        loadHistory()
    }

    var currentLevel: VisionLevel {
        VisionLevel.levels[min(currentLevelIndex, VisionLevel.levels.count - 1)]
    }

    var progressText: String {
        return String(localized: "test_level \(currentLevel.acuity, specifier: "%.1f")")
    }

    // MARK: - Test Flow
    func startTest(eye: EyeSide) {
        currentEye = eye
        currentLevelIndex = 0
        correctInRow = 0
        wrongInRow = 0
        totalCorrect = 0
        totalAttempts = 0
        isTestActive = true
        isTestComplete = false
        lastResult = nil
        nextQuestion()
    }

    func nextQuestion() {
        currentDirection = LandoltDirection.allCases.randomElement()!
    }

    func answer(_ direction: LandoltDirection) {
        totalAttempts += 1
        let isCorrect = direction == currentDirection

        if isCorrect {
            totalCorrect += 1
            correctInRow += 1
            wrongInRow = 0
        } else {
            wrongInRow += 1
            correctInRow = 0
        }

        // Check if we should advance or fail
        if correctInRow >= correctToAdvance {
            // Advance to next level
            correctInRow = 0
            wrongInRow = 0
            if currentLevelIndex < VisionLevel.levels.count - 1 {
                currentLevelIndex += 1
                nextQuestion()
            } else {
                // Completed all levels
                completeTest(acuity: VisionLevel.levels.last!.acuity)
            }
        } else if wrongInRow >= wrongToFail {
            // Failed at this level
            let acuity = currentLevelIndex > 0 ? VisionLevel.levels[currentLevelIndex - 1].acuity : 0.1
            completeTest(acuity: acuity)
        } else {
            nextQuestion()
        }
    }

    private func completeTest(acuity: Double) {
        isTestActive = false
        isTestComplete = true

        let result = VisionResult(
            eye: currentEye,
            acuity: acuity,
            correctCount: totalCorrect,
            totalCount: totalAttempts
        )
        lastResult = result
        history.append(result)
        if history.count > 100 { history.removeFirst() }
        saveHistory()
    }

    func resetTest() {
        isTestActive = false
        isTestComplete = false
        lastResult = nil
    }

    // MARK: - Persistence
    private func saveHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: "vision_history")
        }
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: "vision_history"),
           let decoded = try? JSONDecoder().decode([VisionResult].self, from: data) {
            history = decoded
        }
    }

    func clearHistory() {
        history = []
        saveHistory()
    }
}
