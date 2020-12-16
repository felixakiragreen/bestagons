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
	
	@State var optWidth: Double = 2.0
	@State var optHeight: Double = 2.0
	
	var body: some View {
		let cellSize = 16
		
//		let frameWidth = apparatus.xDim * cellSize
		
		VStack {
			Text("Apparatus")
				.font(.largeTitle)
				.padding()
				.onAppear {
					self.regenerate()
				}
			
			HStack(spacing: 16.0) {
				VStack {
					Text("Options")
						.font(.headline)
				
					GroupBox(label: Text("top level")) {
						VStack {
							Slider(value: $optWidth, in: 1 ... 16, step: 1) {
								Text("width: \(optWidth, specifier: "%.0f")")
									.frame(width: 60, alignment: .leading)
									
							}
							.padding(.horizontal)
							.onChange(of: optWidth, perform: { value in
								self.regenerate()
							})
							Slider(value: $optHeight, in: 1 ... 16, step: 1) {
								Text("height: \(optHeight, specifier: "%.0f")")
									.frame(width: 60, alignment: .leading)
							}
							.padding(.horizontal)
							.onChange(of: optHeight, perform: { value in
								self.regenerate()
							})
						
							
						}
					}
					
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
							let w = CGFloat(rect.w * cellSize + 0)
							let h = CGFloat(rect.h * cellSize + 0)
							let x = CGFloat(rect.x1 * cellSize - 0)
							let y = CGFloat(rect.y1 * cellSize - 0)
							
							Rectangle()
								.foregroundColor(rect.clr.opacity(0.5))
								.frame(width: w, height: h)
								.border(Color.black.opacity(0.5), width: 1)
								.overlay(
									Text("\(rect.id)")
										.font(.caption)
								)
								.offset(x: x, y: y)
						}
					}
					.frame(
						width: CGFloat(apparatus.xDim * cellSize),
						height: CGFloat(apparatus.yDim * cellSize),
						alignment: .topLeading
					)
					.padding([.bottom, .trailing], CGFloat(cellSize))
					.padding(.bottom, CGFloat(cellSize))
					//			.offset(x: 100.0, y: -200.0)
					.animation(.spring())
				}//: VSTACK Apparatus
			}.padding(32.0)
		}
//		.frame(maxWidth: 800, maxHeight: 800)
	}
	
	func regenerate() {
		apparatus = ApparatusGenerator(
			width: optWidth,
			height: optHeight,
			colorMode: .random
		)
		
		let grid = apparatus.generate()
		print(grid)
		rects = convertLineGridToRect(grid: grid)
		print(rects)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
