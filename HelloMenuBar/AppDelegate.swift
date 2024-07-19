//
//  AppDelegate.swift
//  HelloMenuBar
//
//  Created by Jeremy Jones on 7/16/24.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: NSStatusBar!
    var statusItem: NSStatusItem!
    var isMuted: Bool = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // SwiftUI content view & a hosting view
        // Don't forget to set the frame, otherwise it won't be shown.
        //
        let contentViewSwiftUI = VStack {
            Color.blue
            Text("Test Text")
            TextField("foo", text: .constant("bar"))
            Color.white
        }.padding()

        let contentView = NSHostingView(rootView: contentViewSwiftUI)
        contentView.frame = NSRect(x: 0, y: 0, width: 200, height: 200)

        // Status bar icon SwiftUI view & a hosting view.
        //
        let iconSwiftUI = ZStack {
            TimerView(duration: .seconds(60 * 30))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.horizontal, 4)
        }

        let iconView = NSHostingView(rootView: iconSwiftUI)
        iconView.frame = NSRect(x: 0, y: 0, width: 26, height: 22)

        // Creating a menu item & the menu to add them later into the status bar
        //
        let menuItem = NSMenuItem()
        menuItem.view = contentView
        let menu = NSMenu()
        menu.addItem(menuItem)

        // Adding content view to the status bar
        //
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.menu = menu

        // Adding the status bar icon
        //
        statusItem.button?.addSubview(iconView)
        statusItem.button?.frame = iconView.frame

        // StatusItem is stored as a property.
        self.statusItem = statusItem
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
