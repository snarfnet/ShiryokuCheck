import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var tm: VisionTestManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.97, green: 0.97, blue: 0.98).ignoresSafeArea()

                if tm.history.isEmpty {
                    Text(String(localized: "history_empty"))
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(tm.history.reversed()) { result in
                                HStack(spacing: 12) {
                                    // Grade circle
                                    ZStack {
                                        Circle()
                                            .fill(gradeColor(result.grade).opacity(0.15))
                                            .frame(width: 50, height: 50)
                                        Text(result.grade)
                                            .font(.system(size: 22, weight: .bold, design: .rounded))
                                            .foregroundColor(gradeColor(result.grade))
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(String(localized: "history_acuity \(result.acuityText)"))
                                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                                .foregroundColor(.black)
                                            Spacer()
                                            Text(result.eye.label)
                                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                                .foregroundColor(.blue)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 3)
                                                .background(Color.blue.opacity(0.1))
                                                .cornerRadius(6)
                                        }
                                        Text(result.dateLabel)
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.03), radius: 4, y: 2)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(String(localized: "history_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "history_done")) { dismiss() }
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
            }
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
