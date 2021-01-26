//
//  AppDelegate.swift
//  HexagonalPortrait (macOS)
//
//  Created by Felix Akira Green on 1/26/21.
//

import Cocoa
import SwiftUI

//@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {
	var window: NSWindow!
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		
		let contentView = ContentView()
			.edgesIgnoringSafeArea(.top) // to extend entire content under titlebar
		
		// Create the window and set the content view.
		window = NSWindow(
			contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
			styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
			backing: .buffered, defer: false)
		window.center()
//		window.setFrameAutosaveName("Main Window")
		
//		window.titlebarAppearsTransparent = true
//		window.titleVisibility = .hidden
		
	
		
		
//		let visualEffect = NSVisualEffectView()
//		visualEffect.translatesAutoresizingMaskIntoConstraints = false
//		visualEffect.material = .windowBackground
//		visualEffect.state = .active
//		visualEffect.wantsLayer = true
//		visualEffect.layer?.cornerRadius = 16.0
		
//		window.titleVisibility = .hidden
//		window.styleMask.remove(.titled)
		window.titlebarAppearsTransparent = true
		window.styleMask.insert(.fullSizeContentView)
		
		window.backgroundColor = NSColor(Color.clear)
		window.isMovableByWindowBackground = true
		
//		window.contentView?.addSubview(visualEffect)
//		window.contentView = visualEffect
		
//		guard let constraints = window.contentView else {
//			return
//		}
		
//		WindowController
		
//		visualEffect.leadingAnchor.constraint(equalTo: constraints.leadingAnchor).isActive = true
//		visualEffect.trailingAnchor.constraint(equalTo: constraints.trailingAnchor).isActive = true
//		visualEffect.topAnchor.constraint(equalTo: constraints.topAnchor).isActive = true
//		visualEffect.bottomAnchor.constraint(equalTo: constraints.bottomAnchor).isActive = true
		
		window.contentView = NSHostingView(rootView: contentView)
		window.makeKeyAndOrderFront(nil)
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
}
