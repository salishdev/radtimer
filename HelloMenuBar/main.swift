import AppKit

let app = NSApplication.shared
app.delegate = AppDelegate()
app.setActivationPolicy(.accessory)
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
