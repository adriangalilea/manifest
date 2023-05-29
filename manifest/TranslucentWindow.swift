//
//  TranslucentWindow.swift
//  manifest
//
//  Created by Adrian on 29/5/23.
//

#if os(macOS)
import AppKit

class TranslucentWindow: NSWindow {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        // Here we include the settings from your NSWindowManager
        standardWindowButton(.zoomButton)?.isEnabled = false
        standardWindowButton(.miniaturizeButton)?.isEnabled = false
        standardWindowButton(.closeButton)?.isEnabled = true
        styleMask.remove(.resizable)
        setFrame(NSRect(x: 0, y: 0, width: 300, height: 200), display: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif

