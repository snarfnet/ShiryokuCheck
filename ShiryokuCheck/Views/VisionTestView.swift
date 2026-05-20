import SwiftUI

struct VisionTestView: View {
    @EnvironmentObject var tm: VisionTestManager
    @State private var showFeedback = false
    @State private var feedbackCorrect = false
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 20) {
                // Header
                HStack {
                    Button {
                        tm.resetTest()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(12)
                    }
                    Spacer()

                    VStack(spacing: 2) {
                        Text(tm.currentEye.label)
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                        Text(tm.progressText)
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Text("\(tm.totalCorrect)/\(tm.totalAttempts)")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.gray)
                        .padding(12)
                }
                .padding(.horizontal)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue)
                            .frame(width: geo.size.width * Double(tm.currentLevelIndex) / Double(VisionLevel.levels.count), height: 6)
                            .animation(.easeInOut, value: tm.currentLevelIndex)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal)

                Spacer()

                // Landolt ring
                LandoltRingView(size: tm.currentLevel.ringSizePt, direction: tm.currentDirection)
                    .offset(dragOffset)
                    .gesture(
                        DragGesture(minimumDistance: 30)
                            .onChanged { value in
                                dragOffset = value.translation
                            }
                            .onEnded { value in
                                let dir = detectSwipeDirection(value.translation)
                                handleAnswer(dir)
                                withAnimation(.spring(duration: 0.3)) {
                                    dragOffset = .zero
                                }
                            }
                    )

                Spacer()

                // Direction buttons (for accessibility)
                Text(String(localized: "test_swipe_hint"))
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.gray.opacity(0.5))

                directionButtons
                    .padding(.bottom, 8)

                // Ad
                BannerAdView(adUnitID: AdMobManager.shared.bannerAdUnitID)
                    .frame(height: 50)
            }

            // Feedback overlay
            if showFeedback {
                feedbackOverlay
            }
        }
    }

    // MARK: - Direction Buttons
    private var directionButtons: some View {
        VStack(spacing: 8) {
            // Up
            Button { handleAnswer(.up) } label: {
                dirButton(icon: "chevron.up")
            }

            HStack(spacing: 40) {
                // Left
                Button { handleAnswer(.left) } label: {
                    dirButton(icon: "chevron.left")
                }

                // Right
                Button { handleAnswer(.right) } label: {
                    dirButton(icon: "chevron.right")
                }
            }

            // Down
            Button { handleAnswer(.down) } label: {
                dirButton(icon: "chevron.down")
            }
        }
    }

    private func dirButton(icon: String) -> some View {
        Image(systemName: icon)
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(.blue)
            .frame(width: 64, height: 64)
            .background(Color.blue.opacity(0.08))
            .cornerRadius(16)
    }

    // MARK: - Logic
    private func detectSwipeDirection(_ translation: CGSize) -> LandoltDirection {
        let absX = abs(translation.width)
        let absY = abs(translation.height)

        if absX > absY {
            return translation.width > 0 ? .right : .left
        } else {
            return translation.height > 0 ? .down : .up
        }
    }

    private func handleAnswer(_ direction: LandoltDirection) {
        feedbackCorrect = direction == tm.currentDirection
        showFeedback = true

        let generator = UIImpactFeedbackGenerator(style: feedbackCorrect ? .light : .heavy)
        generator.impactOccurred()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showFeedback = false
            tm.answer(direction)
        }
    }

    // MARK: - Feedback
    private var feedbackOverlay: some View {
        ZStack {
            Circle()
                .fill(feedbackCorrect ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                .frame(width: 120, height: 120)

            Image(systemName: feedbackCorrect ? "checkmark" : "xmark")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(feedbackCorrect ? .green : .red)
        }
        .transition(.scale.combined(with: .opacity))
    }
}
