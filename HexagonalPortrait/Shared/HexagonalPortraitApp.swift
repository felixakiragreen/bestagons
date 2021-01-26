//
//  HexagonalPortraitApp.swift
//  Shared
//
//  Created by Felix Akira Green on 1/25/21.
//

import SwiftUI

@main
struct HexagonalPortraitApp: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
	
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
		.windowStyle(HiddenTitleBarWindowStyle())
		.windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
	}
}
