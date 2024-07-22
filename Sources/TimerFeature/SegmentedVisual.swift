//
//  SegmentedVisual.swift
//  HelloMenuBar
//
//  Created by Jeremy Jones on 7/19/24.
//

import SwiftUI

struct SegmentedVisual: View {
    var color: Color = .black
    
    var body: some View {
        Canvas(
            opaque: true,
            rendersAsynchronously: false
        ) { context, size in
            let radius: CGFloat = min(size.width, size.height) * 0.48

            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            context.rotate(by: .degrees(-90))

            let gapWidth = CGFloat(3.0)
            let gapAngle = Angle(radians: Double(atan((gapWidth / 2) / radius)))
            let segment = Angle(degrees: 90)

            var currentAngle = Angle.zero

            for _ in 0 ..< 4 {
                let startAngle = currentAngle + (gapAngle / 2)
                let endAngle = currentAngle + segment - (gapAngle / 2)

                // Move each segment outward along the line from the center to the midpoint of
                // the segment by the distance equal to half of the gap size.
                let midpointAngle = (startAngle + endAngle) / 2

                let gapOffset = CGPoint(
                    x: CGFloat(gapWidth / 2) * cos(CGFloat(midpointAngle.radians)),
                    y: CGFloat(gapWidth / 2) * sin(CGFloat(midpointAngle.radians))
                )

                let path = Path { p in
                    p.move(to: gapOffset)
                    p.addArc(
                        center: .zero,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false
                    )
                    p.closeSubpath()
                }

                context.fill(path, with: .color(color.opacity(0.1)))

                currentAngle += segment
            }
        }
    }
}

#Preview {
    SegmentedVisual()
}
