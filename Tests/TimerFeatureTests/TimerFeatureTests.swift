import ComposableArchitecture
@testable import TimerFeature
import XCTest

final class TimerFeatureTests: XCTestCase {
    @MainActor
    func testTimer() async throws {
        let clock = TestClock()

        let duration = 2
        let store = TestStore(initialState: Timer.State(duration: duration)) {
            Timer()
        } withDependencies: {
            $0.continuousClock = clock
        }

        // start timer
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerOn = true
            $0.timeRemaining = $0.duration
        }

        await clock.advance(by: .seconds(1))
        await store.receive(.timerTicked) {
            $0.isTimerOn = true
            $0.timeRemaining = duration - 1
        }

        // pause timer
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerOn = false
        }

        // simulate time passing while paused
        await clock.advance(by: .seconds(10))

        // unpause timer
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerOn = true
        }

        await clock.advance(by: .seconds(1))
        await store.receive(.timerTicked) {
            $0.timeRemaining = 0
            $0.isTimerOn = false
            $0.isTimerExpired = true
        }
    }

    @MainActor
    func testTimerStartFromExpiredState() async throws {
        let clock = TestClock()

        // init store in expired state
        let store = TestStore(initialState: Timer.State(timeRemaining: 0, duration: 1, isTimerExpired: true)) {
            Timer()
        } withDependencies: {
            $0.continuousClock = clock
        }

        // start timer
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerOn = true
            $0.isTimerExpired = false
            $0.timeRemaining = $0.duration
        }

        await clock.advance(by: .seconds(1))

        await store.receive(.timerTicked) {
            $0.timeRemaining = 0
            $0.isTimerOn = false
            $0.isTimerExpired = true
        }
    }
}
