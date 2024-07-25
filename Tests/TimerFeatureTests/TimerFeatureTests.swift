import ComposableArchitecture
@testable import TimerFeature
import XCTest

final class TimerFeatureTests: XCTestCase {
    @MainActor
    func testTimer() async throws {
        let clock = TestClock()
        let soundEffectPlayCount = LockIsolated(0)
        let duration = 2

        let store = TestStore(initialState: Timer.State(duration: duration)) {
            Timer()
        } withDependencies: {
            $0.continuousClock = clock
            $0.soundEffectClient = .noop
            $0.soundEffectClient.play = { soundEffectPlayCount.withValue { $0 += 1 } }
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

        XCTAssertEqual(soundEffectPlayCount.value, 1)
    }

    @MainActor
    func testTimerStartFromExpiredState() async throws {
        let clock = TestClock()
        let soundEffectPlayCount = LockIsolated(0)

        // init store in expired state
        let store = TestStore(initialState: Timer.State(timeRemaining: 0, duration: 1, isTimerExpired: true)) {
            Timer()
        } withDependencies: {
            $0.continuousClock = clock
            $0.soundEffectClient = .noop
            $0.soundEffectClient.play = { soundEffectPlayCount.withValue { $0 += 1 } }
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

        XCTAssertEqual(soundEffectPlayCount.value, 1)
    }

    @MainActor
    func testTimeFormatting() throws {
        let clock = TestClock()

        let store = TestStore(initialState: Timer.State(duration: 9932)) {
            Timer()
        } withDependencies: {
            $0.continuousClock = clock
        }

        XCTAssertEqual(store.state.formattedTimeRemaining, "02:45:32")
    }

    @MainActor
    func testResetExpiredTimer() async throws {
        let clock = TestClock()
        let duration = 10

        // init store in expired state
        let store = TestStore(initialState: Timer.State(timeRemaining: 0, duration: duration, isTimerExpired: true)) {
            Timer()
        } withDependencies: {
            $0.continuousClock = clock
        }

        // reset an expired timer
        await store.send(.resetTimerButtonTapped) {
            $0.isTimerOn = false
            $0.isTimerExpired = false
            $0.timeRemaining = $0.duration
        }
    }

    @MainActor
    func testResetRunningTimer() async throws {
        let clock = TestClock()
        let duration = 10

        // init store in expired state
        let store = TestStore(initialState: Timer.State(timeRemaining: duration, duration: duration)) {
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
            $0.timeRemaining = duration - 1
        }

        // resetting timer also stops it
        await store.send(.resetTimerButtonTapped) {
            $0.isTimerOn = false
            $0.isTimerExpired = false
            $0.timeRemaining = $0.duration
        }
    }
}
