//
//  ContentView.swift
//  Shared
//
//  Created by Felix Akira Green on 11/27/20.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack {
			Text("hello")
			PolygonShape(sides: 6)
		}
	}
}



struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
