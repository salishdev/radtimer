//
//  TimerView.swift
//  HelloMenuBar
//
//  Created by Jeremy Jones on 7/19/24.
//

import SwiftUI

struct TimerView: View {
    @State private var timer: Timer!
    var duration: Duration
    let maxDuration: Duration
    @State var remaining: Duration

    init(duration: Duration) {
        self.duration = duration
        self.remaining = duration
        self.maxDuration = .seconds(60 * 60)
    }

    var body: some View {
        Visual(total: CGFloat(maxDuration.components.seconds), remaining: CGFloat(remaining.components.seconds))
            .onAppear {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    remaining -= .seconds(1)
                    if remaining.components.seconds <= 0 {
                        timer.invalidate()
                    }
                }
            }
    }
}

#Preview {
    TimerView(duration: .seconds(60 * 15))
}
