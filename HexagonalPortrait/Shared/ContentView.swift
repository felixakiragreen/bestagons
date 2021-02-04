//
//  ContentView.swift
//  Shared
//
//  Created by Felix Akira Green on 1/25/21.
//

import SwiftUI

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

struct ContentView: View {
	
	// MARK: - PROPS
	
	@State var showControlPanel = false
	@State var isAnimating = true
	@State var isLooping = true

	// MARK: - BODY
	var body: some View {
		VStack {
			if showControlPanel {
				ControlPanel(
					isAnimating: $isAnimating,
					isLooping: $isLooping,
					showControlPanel: $showControlPanel
				)
			} else {
				PortraitView(
					initiallyVisible: true,
					isAnimating: $isAnimating,
					isLooping: $isLooping
				)
			}
			
		}
		.onTapGesture(count: 2) {
			if !showControlPanel {
				withAnimation {
					showControlPanel.toggle()
				}
			}
		}
	}
}
