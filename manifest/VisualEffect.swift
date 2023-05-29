import SwiftUI

struct VisualEffect: NSViewRepresentable {

    func makeNSView(context: Self.Context) -> NSView {
        var test = NSVisualEffectView()
        test.state = NSVisualEffectView.State.active  // this state which says transparent all of the time
        return test
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // No updates needed.
    }
}
