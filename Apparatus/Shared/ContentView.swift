//
//  ContentView.swift
//  Shared
//
//  Created by Felix Akira Green on 12/14/20.
//

import SwiftUI

struct ContentView: View {
	@State var apparatus = ApparatusGenerator(config: ApparatusConfig())
	@State var rects = [BlockRect]()
	
	@State var options = ApparatusOptions()
	@State var config = ApparatusConfig()
	
	var body: some View {
		let cell = CGFloat(config.cellSize)
		
		ZStack {
			Color("grey.800")
		
			VStack {
				HStack(spacing: 16.0) {
					VStack {
						Text("Options")
							.font(.headline)
					
						ApparatusOptionsView(
							config: $config,
							options: $options,
							onChange: { _ in
								self.update()
							}
						)

						Spacer()
						Button(action: {
							self.regenerate()
						}) {
							Text("Regenerate")
						}
						.padding()
					} //: VSTACK - Options
					.frame(width: 320)
				
					VStack {
						ZStack(alignment: .topLeading) {
							ForEach(rects, id: \.id) { rect in
								let w = CGFloat(rect.w) * cell
								let h = CGFloat(rect.h) * cell
								let x = CGFloat(rect.x1) * cell
								let y = CGFloat(rect.y1) * cell
								
								Rectangle()
									.foregroundColor(rect.clr.opacity(options.showFill ? 0.5 : 0))
									.frame(width: w, height: h)
									.border(Color.black.opacity(0.5), width: options.showStroke ? 1 : 0)
									.overlay(options.showDebug ? Text("\(rect.id)")
										.font(.caption)
										: nil
									)
									.offset(x: x, y: y)
							}
						}
						.frame(
							width: CGFloat(apparatus.xDim) * cell,
							height: CGFloat(apparatus.yDim) * cell,
							alignment: .topLeading
						)
						.padding([.bottom, .trailing], cell)
						.padding(.bottom, cell)
						.animation(.default)
					} //: VSTACK - Apparatus
				} //: VSTACK - Top
				.onAppear {
					self.update()
				}
				.padding(32.0)
			}
		}
	}
	
	func update() {
		apparatus = ApparatusGenerator(config: config)
		//	print(config)
		let grid = apparatus.generate()
//		print(grid)
		rects = convertLineGridToRect(grid: grid)
//		print(rects)
	}
	
	func regenerate() {
		if !options.preserveSeed {
			config.seed = Int.random(in: 0 ... Int.max)
		}
		
		update()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
