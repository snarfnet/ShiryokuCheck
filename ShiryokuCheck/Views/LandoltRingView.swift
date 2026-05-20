import SwiftUI

struct LandoltRingView: View {
    let size: CGFloat
    let direction: LandoltDirection

    var body: some View {
        Canvas { context, canvasSize in
            let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
            let radius = size / 2
            let strokeWidth = size / 5
            let gapAngle: Double = 45 // degrees

            // Ring path with gap
            let gapHalf = gapAngle / 2
            let startAngle = Angle.degrees(-90 + direction.rotation + gapHalf)
            let endAngle = Angle.degrees(-90 + direction.rotation + 360 - gapHalf)

            var path = Path()
            path.addArc(center: center, radius: radius - strokeWidth / 2,
                       startAngle: startAngle, endAngle: endAngle, clockwise: false)

            context.stroke(path, with: .color(.black), lineWidth: strokeWidth)
        }
        .frame(width: size, height: size)
    }
}
