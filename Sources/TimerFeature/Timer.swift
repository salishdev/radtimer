import ComposableArchitecture
import SoundEffectClient
import SwiftUI

@Reducer
public struct Timer {
    public init() {}

    @ObservableState
    public struct State: Equatable {
        public var timeRemaining: Int
        @Shared public var duration: Int
        public var isTimerOn: Bool
        public var isTimerExpired: Bool
        public var color: Color

        public var durationAsDouble: Double {
            Double(duration)
        }

        public var formattedTimeRemaining: String {
            var rem = timeRemaining

            let hours = rem / 3600
            rem %= 3600
            let minutes = rem / 60
            rem %= 60
            let seconds = rem

            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }

        public init(timeRemaining: Int? = nil,
                    duration: @escaping @autoclosure () -> Int = 60 * 60,
                    isTimerOn: Bool = false,
                    isTimerExpired: Bool = false,
                    color: Color = Color.primary)
        {
            self._duration = Shared(wrappedValue: duration(), .appStorage("duration"))
            self.timeRemaining = min(timeRemaining ?? Int.max, _duration.wrappedValue)

            self.isTimerOn = isTimerOn
            self.isTimerExpired = isTimerExpired
            self.color = color
        }
    }

    public enum Action: Equatable {
        case toggleTimerButtonTapped
        case resetTimerButtonTapped
        case timerTicked
        case durationChanged(Double)
    }

    private enum CancelID {
        case timer
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.soundEffectClient) var soundEffectClient

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .toggleTimerButtonTapped:
                state.isTimerOn.toggle()

                if state.isTimerOn {
                    if state.isTimerExpired {
                        // reset timer duration if expired
                        state.timeRemaining = state.duration
                        state.isTimerExpired = false
                    }

                    return .run { send in
                        for await _ in self.clock.timer(interval: .seconds(1)) {
                            await send(.timerTicked)
                        }
                    }.cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }

            case .resetTimerButtonTapped:
                print(state.duration)
                state.timeRemaining = state.duration
                state.isTimerExpired = false
                state.isTimerOn = false

                return .cancel(id: CancelID.timer)

            case .timerTicked:
                state.timeRemaining -= 1

                if state.timeRemaining == 0 {
                    state.isTimerOn = false
                    state.isTimerExpired = true

                    soundEffectClient.play()

                    return .cancel(id: CancelID.timer)
                }

                return .none

            case let .durationChanged(value):
                state.duration = Int(value)
                state.timeRemaining = state.duration
                state.isTimerExpired = false
                state.isTimerOn = false

                return .cancel(id: CancelID.timer)
            }
        }
    }
}
