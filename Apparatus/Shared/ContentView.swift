//
//  ContentView.swift
//  Shared
//
//  Created by Felix Akira Green on 12/14/20.
//

import SwiftUI

struct ContentView: View {
	let apparatus = ApparatusGenerator(
		width: 8, height: 8, colorMode: .random
	)
	
//	TODO: add options
	
	@State var rects: [BlockRect] = [BlockRect]()
	
	var body: some View {
		
		
		let cellSize = 8
		
		VStack(alignment: .leading) {
			HStack(alignment: .top) {
				Text("Apparatus")
					.padding()
					
				Button(action: {
					self.regenerate()
				}) {
					Text("regenerate")
				}
				.padding()
				Spacer()
			}
			.onAppear {
				self.regenerate()
			}
			Spacer()
			
			ZStack {
				ForEach(rects, id: \.id) { rect in
					Rectangle()
						.frame(width: CGFloat(cellSize * rect.w + 1), height: CGFloat(cellSize * rect.h + 1), alignment: .center)
						.foregroundColor(rect.clr.opacity(0.5))
						.border(Color.black, width: 1)
						.offset(x: CGFloat(cellSize * 2 * rect.x1 - 1), y: CGFloat(cellSize * 2 * rect.y1 - 1))
				}
			}.offset(x: 0.0, y: -300.0)
			.animation(.spring())
		}.frame(maxWidth: 800, maxHeight: 800)
	}
	
	func regenerate() -> Void {
		let grid = apparatus.generate()
		rects = convertLineGridToRect(grid: grid)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
