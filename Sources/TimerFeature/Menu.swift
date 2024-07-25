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

struct MenuButton<Label>: View where Label: View {
    let imageName: String
    let label: Label
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            HStack {
                Image(systemName: imageName)
                    .frame(width: 16, height: 16)
                    .scaleEffect(1.4)
                    .padding(8)
                    .background(.white.opacity(0.2), in: Circle())
                label
                    .padding(.leading, 3)
                Spacer()
            }
            .frame(maxWidth: .infinity)
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
        VStack(alignment: .center, spacing: 0) {
            MenuButton(imageName: "play.fill", label: Text("Start Timer")) {
                store.send(.toggleTimerButtonTapped)
                onClose()
            }
            MenuButton(imageName: "pause.fill", label: Text("Stop Timer")) {
                store.send(.toggleTimerButtonTapped)
                onClose()
            }
            MenuButton(imageName: "trash.fill", label: Text("Reset Timer")) {
//                store.send()
                onClose()
            }
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

#Preview("") {
    MenuView(
        store: Store(initialState: Timer.State()) {
            Timer()
        }
    )
}
