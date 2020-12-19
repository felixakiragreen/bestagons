//
//  ContentView.swift
//  Shared
//
//  Created by Felix Akira Green on 12/14/20.
//

import SwiftUI

struct ContentView: View {
	// MARK: - PROPS
	@State var apparatus = ApparatusGenerator(config: ApparatusConfig())
	@State var rects = [BlockRect]()
	
	@State var options = ApparatusOptions()
	@State var config = ApparatusConfig()
	
	// MARK: - BODY
	var body: some View {
		let size = CGFloat(options.sizing)
		let pad = CGFloat(options.padding)
		
		ZStack(alignment: .topLeading) {
			Color("grey.800")
		
			VStack {
				HStack(spacing: 16.0) {
					VStack {
						Text("Options")
							.font(.headline)
					
						OptionsView(
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
						Text("TODO: consider adding shape/color")
					} //: VSTACK - Options
					.frame(width: 320)
				
					VStack {
						Spacer()
						
						ArtView(config: $config, options: $options, rects: rects, size: size, pad: pad)
						.frame(
							width: CGFloat(apparatus.xDim) * (size + pad),
							height: CGFloat(apparatus.yDim) * (size + pad),
							alignment: .topLeading
						)
						.padding([.bottom, .trailing], size)
						.padding(.bottom, size)
						.background(options.colorGround.getColor())
						.animation(.default)
						
						Spacer()
					} //: VSTACK - Apparatus Side
				} //: VSTACK - Top
				.onAppear {
					self.update()
				}
				.padding(32.0)
			}
		}
	}
	
	// MARK: - UPDATE
	func update() {
		apparatus = ApparatusGenerator(config: config)
//		print(config)
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

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
//			.frame(width: 900.0, height: 900.0)
	}
}
