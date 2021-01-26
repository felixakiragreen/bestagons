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
	// MARK: - BODY
	var body: some View {
		PortraitView(initiallyVisible: true)
	}
}

