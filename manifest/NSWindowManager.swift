//
//  NSWindowManager.swift
//  manifest
//
//  Created by Adrian on 28/5/23.
//

import SwiftUI

class NSWindowManager {
    static func updateNSWindowSettings(window: NSWindow?) {
        window?.standardWindowButton(.zoomButton)?.isEnabled = false
        window?.standardWindowButton(.miniaturizeButton)?.isEnabled = false
        window?.standardWindowButton(.closeButton)?.isEnabled = true
        window?.styleMask.remove(.resizable)
        window?.setFrame(NSRect(x: 0, y: 0, width: 300, height: 200), display: true)
    }
}
