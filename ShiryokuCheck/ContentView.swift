import SwiftUI

struct ContentView: View {
    @EnvironmentObject var tm: VisionTestManager
    @State private var showHistory = false

    var body: some View {
        Group {
            if tm.isTestActive {
                VisionTestView()
            } else if tm.isTestComplete {
                ResultView()
            } else {
                homeView
            }
        }
    }

    // MARK: - Home
    private var homeView: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // App icon area
                VStack(spacing: 12) {
                    // Sample Landolt ring
                    LandoltRingView(size: 80, direction: .right)

                    Text(String(localized: "app_title"))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.black)

                    Text(String(localized: "app_subtitle"))
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.gray)
                }

                Spacer()

                // Eye selection buttons
                VStack(spacing: 12) {
                    Text(String(localized: "home_select_eye"))
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)

                    ForEach([EyeSide.right, .left, .both], id: \.rawValue) { eye in
                        Button {
                            tm.startTest(eye: eye)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: eye.icon)
                                    .font(.system(size: 22))
                                Text(eye.label)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(eyeColor(eye))
                            )
                        }
                    }
                }
                .padding(.horizontal, 30)

                // History button
                if !tm.history.isEmpty {
                    Button {
                        showHistory = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "clock.arrow.circlepath")
                            Text(String(localized: "home_history"))
                        }
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                    }
                    .padding(.top, 8)
                }

                // Instructions
                Text(String(localized: "home_instruction"))
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.gray.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 4)

                Spacer()

                Spacer().frame(height: 50)
            }
        }
        .sheet(isPresented: $showHistory) {
            HistoryView()
        }
    }

    private func eyeColor(_ eye: EyeSide) -> Color {
        switch eye {
        case .right: return .blue
        case .left: return Color(red: 0.3, green: 0.7, blue: 0.4)
        case .both: return .orange
        }
    }
}
