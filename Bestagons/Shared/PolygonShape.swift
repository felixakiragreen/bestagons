//
//  PolygonShape.swift
//  Bestagons
//
//  Created by Felix Akira Green on 11/27/20.
//

import SwiftUI

struct PolygonShape: Shape {
	var sides: Int
	
	func path(in rect: CGRect) -> Path {
		
		// hypotenuse (diameter / 2)
		let hypotenuse = Double(min(rect.width, rect.height)) / 2.0
		
		var path = Path()
		
		for i in 0..<sides {
			let startAngle = Angle.radians((Double(i) * (360.0 / Double(sides))) * Double.pi / 180)
			
			// Adjustment to start at top instead of to the right
			let rotationAdjustment = Angle.degrees(90)
			let angle = startAngle - rotationAdjustment
			
			// Calculate vertex position
			let pt = CGPoint(
				x: rect.midX + CGFloat(cos(angle.radians) * hypotenuse),
				y: rect.midY + CGFloat(sin(angle.radians) * hypotenuse)
			)
			
			if i == 0 {
				path.move(to: pt) // move to first vertex
			} else {
				path.addLine(to: pt) // draw line to next vertex
			}
		}
		
		path.closeSubpath()
		
		return path
			
	}
		
}

struct PolygonShape_Previews: PreviewProvider {
    static var previews: some View {
        PolygonShape(sides: 6)
    }
}
