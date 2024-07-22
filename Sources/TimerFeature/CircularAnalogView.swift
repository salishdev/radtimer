import ComposableArchitecture
import SwiftUI

public struct CircularAnalogView: View {
    public init(store: StoreOf<Timer>) {
        self.store = store
    }

    public let store: StoreOf<Timer>

    public var body: some View {
        Canvas(
            opaque: true,
            rendersAsynchronously: false
        ) { context, size in
            let radius: CGFloat = min(size.width, size.height) * 0.48

            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            context.rotate(by: .degrees(-90))

            let bgPath = Path { p in
                p.move(to: .zero)
                p.addArc(
                    center: .zero,
                    radius: radius,
                    startAngle: .zero,
                    endAngle: Angle(degrees: 360),
                    clockwise: false
                )
                p.closeSubpath()
            }

            context.fill(bgPath, with: .color(
                !store.isTimerExpired ? store.color.opacity(0.15) : Color.red.opacity(0.75)
            ))

            let path = Path { p in
                p.move(to: .zero)
                p.addArc(
                    center: .zero,
                    radius: radius,
                    startAngle: .zero,
                    endAngle: Angle(degrees: 360) * CGFloat(store.timeRemaining) / CGFloat(store.duration),
                    clockwise: false
                )
                p.closeSubpath()
            }

            context.fill(path, with: .color(store.color.opacity(0.75)))
        }
    }
}

#Preview("") {
    CircularAnalogView(
        store: Store(initialState: Timer.State()) {
            Timer()
        }
    )
}


#Preview("15min remaining") {
    CircularAnalogView(
        store: Store(initialState: Timer.State(timeRemaining: 60 * 15)) {
            Timer()
        }
    )
}

#Preview("45min remaining") {
    CircularAnalogView(
        store: Store(initialState: Timer.State(timeRemaining: 60 * 45)) {
            Timer()
        }
    )
}

#Preview("Expired") {
    CircularAnalogView(
        store: Store(initialState: Timer.State(timeRemaining: 0, isTimerExpired: true)) {
            Timer()
        }
    )
}
