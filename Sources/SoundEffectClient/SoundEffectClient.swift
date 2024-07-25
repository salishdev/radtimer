import AppKit
import AVFoundation
import Dependencies
import DependenciesMacros

@DependencyClient
public struct SoundEffectClient {
    public var load: @Sendable (_ sound: Sound) -> Void
    public var play: @Sendable () -> Void

    public struct Sound {
        public let name: String

        public init(_ name: String) {
            self.name = name
        }

        public static let update = Self("Update.caf")
    }
}

extension SoundEffectClient: DependencyKey {
    public static var liveValue: Self {
        let player = LockIsolated(AVPlayer())

        return Self(
            load: { sound in
                player.withValue {
                    guard let url = Bundle.main.url(forResource: sound.name, withExtension: "")
                    else { return }
                    $0.replaceCurrentItem(with: AVPlayerItem(url: url))
                }
            },
            play: {
                player.withValue {
                    $0.seek(to: .zero)
                    $0.play()
                }
            }
        )
    }

    public static let testValue = Self()

    public static let noop = Self(
        load: { _ in },
        play: {}
    )
}

public extension DependencyValues {
    var soundEffectClient: SoundEffectClient {
        get { self[SoundEffectClient.self] }
        set { self[SoundEffectClient.self] = newValue }
    }
}
