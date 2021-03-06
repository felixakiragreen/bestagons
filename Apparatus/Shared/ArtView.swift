//
//  ArtView.swift
//  Apparatus
//
//  Created by Felix Akira Green on 12/18/20.
//

import SwiftUI

struct ArtView: View {
	@Binding var config: ApparatusConfig
	@Binding var options: ApparatusOptions
	
	var rects: [BlockRect]
	var size: CGFloat = 8
	var pad: CGFloat = 0

	var body: some View {
		ZStack(alignment: .topLeading) {
			ForEach(rects, id: \.id) { rect in
				let w = CGFloat(rect.w) * (size + pad) - pad
				let h = CGFloat(rect.h) * (size + pad) - pad
				let x = CGFloat(rect.x1) * (size + pad)
				let y = CGFloat(rect.y1) * (size + pad)
				
				RoundedRectangle(cornerRadius: CGFloat(options.rounding), style: .continuous)
					.foregroundColor(rect.color.getColor().opacity(options.showFill ? 1 : 0))
					.frame(width: w, height: h)
//					TODO: Fix the stroke not working with rounding
					.border(options.colorStroke.getColor(), width: options.showStroke ? CGFloat(options.stroking) : 0)
					.overlay(options.showDebug ? Text("\(rect.id)")
						.font(.caption)
						: nil
					)
					.offset(x: x, y: y)
			}
		}//: ZSTACK - Apparatus
	}
}

// MARK: - PREVIEW
struct ArtView_Previews: PreviewProvider {
	static let config = ApparatusConfig()
	static let apparatus = ApparatusGenerator(config: config)
	static let grid = apparatus.generate()
	static let rects = convertLineGridToRect(grid: grid)
	
	static var previews: some View {
		ArtView(
			config: .constant(config),
			options: .constant(ApparatusOptions()),
			rects: rects
		)
	}
}
