//
//  HotkeyMonitor.swift
//  manifest
//
//  Created by Adrian on 28/5/23.
//

import AppKit
import Carbon

class HotkeyMonitor {
    private var monitor: Any?
    let audioRecorder = AudioRecorder()

    func startMonitoring() {
        let key = kVK_ANSI_S // you can change this to any key you want
        monitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown, .keyUp]) { event in
            if event.keyCode == UInt64(key) {
                if event.type == .keyDown {
                    // key is pressed
                    print("Hotkey pressed")
                    self.audioRecorder.startRecording()
                } else if event.type == .keyUp {
                    // key is released
                    print("Hotkey released")
                    self.audioRecorder.stopRecording()
                }
            }
        }
    }

    func stopMonitoring() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
