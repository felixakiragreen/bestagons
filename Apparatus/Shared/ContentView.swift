//
//  ContentView.swift
//  Shared
//
//  Created by Felix Akira Green on 12/14/20.
//

import SwiftUI

struct ContentView: View {
	@State var apparatus = ApparatusGenerator(width: 2, height: 2)
	@State var rects = [BlockRect]()
	
	@State var options = ApparatusOptions()
	
	var body: some View {
		VStack {
			HStack(spacing: 16.0) {
				VStack {
					Text("Options")
						.font(.headline)
				
					ApparatusOptionsView(options: $options, onChange: { _ in
						self.regenerate()
					})

					Spacer()
					Button(action: {
						self.regenerate()
					}) {
						Text("Regenerate")
					}
					.padding()
				}//: VSTACK - Options
				.frame(width: 320)
			
				VStack {
					ZStack(alignment: .topLeading) {
						ForEach(rects, id: \.id) { rect in
							let w = CGFloat(rect.w) * CGFloat(options.cellSize)
							let h = CGFloat(rect.h) * CGFloat(options.cellSize)
							let x = CGFloat(rect.x1) * CGFloat(options.cellSize)
							let y = CGFloat(rect.y1) * CGFloat(options.cellSize)
							
							Rectangle()
								.foregroundColor(rect.clr.opacity(0.5))
								.frame(width: w, height: h)
								.border(Color.black.opacity(0.5), width: 1)
//								.overlay(
//									Text("\(rect.id)")
//										.font(.caption)
//								)
								.offset(x: x, y: y)
						}
					}
					.frame(
						width: CGFloat(Double(apparatus.xDim) * options.cellSize),
						height: CGFloat(Double(apparatus.yDim) * options.cellSize),
						alignment: .topLeading
					)
					.padding([.bottom, .trailing], CGFloat(options.cellSize))
					.padding(.bottom, CGFloat(options.cellSize))
					.animation(.spring())
				}//: VSTACK - Apparatus
			}//: VSTACK - Top
			.onAppear {
				self.regenerate()
			}
			.padding(32.0)
		}
	}
	
	func regenerate() {
		apparatus = ApparatusGenerator(
			width: options.cellCountX,
			height: options.cellCountY,
			colorMode: options.colorMode,
			seed: options.seed
		)
		
		let grid = apparatus.generate()
		// print(grid)
		rects = convertLineGridToRect(grid: grid)
		// print(rects)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
