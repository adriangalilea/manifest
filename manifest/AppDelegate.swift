#if os(macOS)
import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView()
            .background(VisualEffect())
        
        window = TranslucentWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.center()
        window.setFrameAutosaveName("Main Window")

        let hostingView = NSHostingView(rootView: contentView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        window.contentView = hostingView

        if let contentView = window.contentView {
            NSLayoutConstraint.activate([
                hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
        
        window.makeKeyAndOrderFront(nil)
    }
}
#endif
