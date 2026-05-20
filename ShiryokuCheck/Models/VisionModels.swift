import Foundation

enum EyeSide: String, Codable {
    case left = "LEFT"
    case right = "RIGHT"
    case both = "BOTH"

    var label: String {
        switch self {
        case .left: return String(localized: "eye_left")
        case .right: return String(localized: "eye_right")
        case .both: return String(localized: "eye_both")
        }
    }

    var icon: String {
        switch self {
        case .left: return "eye.fill"
        case .right: return "eye.fill"
        case .both: return "eyes"
        }
    }
}

enum LandoltDirection: CaseIterable {
    case up, down, left, right

    var rotation: Double {
        switch self {
        case .up: return 0
        case .right: return 90
        case .down: return 180
        case .left: return 270
        }
    }
}

struct VisionResult: Identifiable, Codable {
    let id: UUID
    let date: Date
    let eye: EyeSide
    let acuity: Double // 0.1 - 2.0
    let correctCount: Int
    let totalCount: Int

    init(id: UUID = UUID(), date: Date = Date(), eye: EyeSide, acuity: Double, correctCount: Int, totalCount: Int) {
        self.id = id
        self.date = date
        self.eye = eye
        self.acuity = acuity
        self.correctCount = correctCount
        self.totalCount = totalCount
    }

    var acuityText: String {
        if acuity >= 1.0 {
            return String(format: "%.1f", acuity)
        }
        return String(format: "%.2f", acuity)
    }

    var dateLabel: String {
        let f = DateFormatter()
        f.dateFormat = "M/d HH:mm"
        return f.string(from: date)
    }

    var grade: String {
        switch acuity {
        case 1.0...: return "A"
        case 0.7..<1.0: return "B"
        case 0.3..<0.7: return "C"
        default: return "D"
        }
    }

    var gradeDescription: String {
        switch grade {
        case "A": return String(localized: "grade_a")
        case "B": return String(localized: "grade_b")
        case "C": return String(localized: "grade_c")
        default: return String(localized: "grade_d")
        }
    }
}

// Vision acuity levels: standard Landolt ring sizes
// At 5m distance, 1.0 vision = gap of 1.5mm = ring of 7.5mm
struct VisionLevel {
    let acuity: Double
    let ringSizePt: CGFloat // display size in points at set distance

    // Standard levels used in Japanese vision tests
    static let levels: [VisionLevel] = [
        VisionLevel(acuity: 0.1, ringSizePt: 150),
        VisionLevel(acuity: 0.2, ringSizePt: 100),
        VisionLevel(acuity: 0.3, ringSizePt: 75),
        VisionLevel(acuity: 0.4, ringSizePt: 60),
        VisionLevel(acuity: 0.5, ringSizePt: 50),
        VisionLevel(acuity: 0.6, ringSizePt: 42),
        VisionLevel(acuity: 0.7, ringSizePt: 36),
        VisionLevel(acuity: 0.8, ringSizePt: 32),
        VisionLevel(acuity: 0.9, ringSizePt: 28),
        VisionLevel(acuity: 1.0, ringSizePt: 24),
        VisionLevel(acuity: 1.2, ringSizePt: 20),
        VisionLevel(acuity: 1.5, ringSizePt: 16),
        VisionLevel(acuity: 2.0, ringSizePt: 12),
    ]
}
