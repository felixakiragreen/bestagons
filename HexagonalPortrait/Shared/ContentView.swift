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


/**
TODO:
- [ ] add a title & subtitle (like hexis) so I can add labels to it
*/

struct ContentView: View {
	
	// MARK: - PROPS
	
	@State var showControlPanel = false
	@State var isAnimating = false
	@State var isLooping = true
	@State var animationDuration = 5.0
	@State var animationPause = 2.0

	// MARK: - BODY
	var body: some View {
		VStack {
			if showControlPanel {
				ControlPanel(
					isAnimating: $isAnimating,
					isLooping: $isLooping,
					animationDuration: $animationDuration,
					animationPause: $animationPause,
					showControlPanel: $showControlPanel
				)
			} else {
				PortraitView(
					initiallyVisible: true,
					isAnimating: $isAnimating,
					isLooping: $isLooping,
					animationDuration: animationDuration,
					animationPause: animationPause
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

