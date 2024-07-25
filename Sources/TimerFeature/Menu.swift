import ComposableArchitecture
import SwiftUI

struct MyButtonStyle: ButtonStyle {
    @State var isHovering = false

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(2)
            .background(.white.opacity(isHovering ? 0.2 : 0.0))
            .cornerRadius(4.0)
            .contentShape(.rect())
            .onHover(perform: { hovering in
                isHovering = hovering
            })
    }
}

struct MenuButton: View {
    let imageName: String

    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Image(systemName: imageName)
                .imageScale(.large)
                .frame(width: 16, height: 16)
                .padding(6)
                .background(.white.opacity(0.2), in: Circle())
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
        }).buttonStyle(MyButtonStyle())
    }
}

public struct MenuView: View {
    public let store: StoreOf<Timer>
    public let onClose: () -> Void

    public init(store: StoreOf<Timer>, onClose: @escaping () -> Void = {}) {
        self.store = store
        self.onClose = onClose
    }

    public var body: some View {
        VStack(spacing: 5) {
            Text(store.formattedTimeRemaining)
                .font(.system(size: 36, weight: .light, design: .monospaced))
                .minimumScaleFactor(0.01)

            HStack(alignment: .center, spacing: 0) {
                MenuButton(imageName: store.isTimerOn ? "pause.fill" : "play.fill") {
                    store.send(.toggleTimerButtonTapped)
                    onClose()
                }

                MenuButton(imageName: "arrow.counterclockwise") {
                    store.send(.resetTimerButtonTapped)
                    onClose()
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(5)
    }
}

#Preview("") {
    MenuView(
        store: Store(initialState: Timer.State()) {
            Timer()
        }
    )
}
