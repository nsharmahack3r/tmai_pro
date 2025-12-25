import Cocoa

class SplashWindow {

    private static var window: NSWindow?

    static func show() {
        let size = NSSize(width: 800, height: 600)

        let window = NSWindow(
            contentRect: NSRect(origin: .zero, size: size),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.level = .statusBar
        window.isOpaque = false
        window.backgroundColor = .clear
        window.center()

        let imageView = NSImageView(frame: NSRect(origin: .zero, size: size))
        imageView.image = NSImage(named: "Splash")
        imageView.imageScaling = .scaleAxesIndependently

        window.contentView = imageView
        window.makeKeyAndOrderFront(nil)

        self.window = window
    }

    static func close() {
        window?.orderOut(nil)
        window = nil
    }
}