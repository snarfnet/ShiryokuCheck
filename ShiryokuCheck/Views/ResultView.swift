import SwiftUI

struct ResultView: View {
    @EnvironmentObject var tm: VisionTestManager

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                if let result = tm.lastResult {
                    // Grade circle
                    ZStack {
                        Circle()
                            .stroke(gradeColor(result.grade).opacity(0.2), lineWidth: 16)
                            .frame(width: 180, height: 180)

                        Circle()
                            .trim(from: 0, to: result.acuity / 2.0)
                            .stroke(gradeColor(result.grade), style: StrokeStyle(lineWidth: 16, lineCap: .round))
                            .frame(width: 180, height: 180)
                            .rotationEffect(.degrees(-90))

                        VStack(spacing: 4) {
                            Text(result.acuityText)
                                .font(.system(size: 56, weight: .bold, design: .rounded))
                                .foregroundColor(.black)

                            Text(String(localized: "result_acuity"))
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.gray)
                        }
                    }

                    // Grade badge
                    VStack(spacing: 4) {
                        Text(String(localized: "result_grade \(result.grade)"))
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(gradeColor(result.grade))

                        Text(result.gradeDescription)
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.gray)
                    }

                    // Stats
                    HStack(spacing: 30) {
                        statItem(label: String(localized: "result_eye"), value: result.eye.label)
                        statItem(label: String(localized: "result_correct"), value: "\(result.correctCount)/\(result.totalCount)")
                        statItem(label: String(localized: "result_date"), value: result.dateLabel)
                    }
                    .padding(.top, 10)
                }

                Spacer()

                // Buttons
                Button {
                    tm.resetTest()
                } label: {
                    Text(String(localized: "result_retry"))
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 30)

                Text(String(localized: "result_disclaimer"))
                    .font(.system(size: 10, design: .rounded))
                    .foregroundColor(.gray.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 8)

                Spacer().frame(height: 50)
            }
        }
    }

    private func statItem(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.black)
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(.gray)
        }
    }

    private func gradeColor(_ grade: String) -> Color {
        switch grade {
        case "A": return .green
        case "B": return .blue
        case "C": return .orange
        default: return .red
        }
    }
}
