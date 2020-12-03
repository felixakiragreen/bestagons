//
//  HexagonShape.swift
//  Bestagons
//
//  Created by Felix Akira Green on 12/2/20.
//

import SwiftUI

struct HexagonShapeView: View {
	
	
	// MARK: - BODY
	var body: some View {
		VStack {
			HStack {
				ManualHexagon(fill: Color("blue.400"))
				RegularHexagon(fill: Color("orange.400"))
				StretchyHexagon(fill: Color("purple.400"), trunk: 0)
				StretchyHexagon(fill: Color("green.400"), trunk: .infinity)
			}
			HStack {
				ManualHexagonalRightBevel()
			}
		}
	}
}

// MARK: - CONSTRUCTIONS

// Math for drawing hexagonal angles
let α = CGFloat(Double.pi / 3)

//TODO: remove all the offsets
//and just do them via .offset()

struct HexParams {
	var width: CGFloat // width
	var height: CGFloat // height
	var offsetX: CGFloat // translate X
	var offsetY: CGFloat // translate Y
//	CGPoint?
	var side: CGFloat // length of a side (radius of circumcircle)
	var midX: CGFloat // mid point
	var midTopY: CGFloat // length of tip
	var midBotY: CGFloat // length of tip + body
}

func getHexagonParams(
	height: CGFloat,
	offset: CGPoint = .zero,
	midTopY: CGFloat? = nil,
	midBotY: CGFloat? = nil
) -> HexParams {
	let w = height * sin(α)
	let m = w / 2
	let s = m / sin(α)
	let a = midTopY ?? s / 2
	let b = midBotY ?? a + s
	
	return HexParams(
		width: w,
		height: height,
		offsetX: offset.x,
		offsetY: offset.y,
		side: s,
		midX: m,
		midTopY: a,
		midBotY: b
	)
}
 
struct ManualHexagon: View {
	var fill = Color("green.felix")

	var body: some View {
		GeometryReader { geometry in
			Path { path in
				let width = min(geometry.size.width, geometry.size.height)
				let height = width / sin(α)
				let midPoint = width / 2
				let side = midPoint / sin(α)
				let tip = side / 2

				path.addLines([
					CGPoint(x: midPoint, y: 0),
					CGPoint(x: width, y: tip),
					CGPoint(x: width, y: tip + side),
					CGPoint(x: midPoint, y: height),
					CGPoint(x: 0, y: tip + side),
					CGPoint(x: 0, y: tip)
				])
			}
			.fill(fill)
		}
	}
}

struct RegularHexagon: View {
	var fill = Color("green.felix")

	var body: some View {
		GeometryReader { geometry in
			let center = min(geometry.size.width, geometry.size.height) / 2
			let side = center / sin(α)
			let tip = side / 2

			HexagonalShape(
				offset: .zero,
				center: center,
				tip: tip,
				trunk: side
			)
			.fill(fill)
		}
	}
}

struct StretchyHexagon: View {
	var fill = Color("green.felix")
	var trunk: CGFloat?

	var body: some View {
		GeometryReader { geometry in
			let center = min(geometry.size.width, geometry.size.height) / 2
			let side = center / sin(α)
			let tip = side / 2
			let trunkHeight = trunk ?? side

			HexagonalShape(
				offset: .zero,
				center: center,
				tip: tip,
				trunk: trunkHeight == .infinity
					? geometry.size.height - side // stretch to fill available space
					: trunkHeight
			)
			.fill(fill)
		}
	}
}

struct HexagonalShape: Shape {
	let offset: CGPoint
	let center: CGFloat // midline, on X axis for vertical hexagons
	let tip: CGFloat // height of tip (half of side length)
	let trunk: CGFloat // regularly the length of a side, but specificying 0 makes a diamond

	func path(in rect: CGRect) -> Path {
		var p = Path()

		p.addLines([
			CGPoint(x: offset.x + center, y: offset.y), // top
			CGPoint(x: offset.x + center * 2, y: offset.y + tip), // top right
			CGPoint(x: offset.x + center * 2, y: offset.y + tip + trunk), // bot right
			CGPoint(x: offset.x + center, y: offset.y + tip + trunk + tip), // bot
			CGPoint(x: offset.x, y: offset.y + tip + trunk), // bot left
			CGPoint(x: offset.x, y: offset.y + tip) // top left
		])

		return p
	}
}

struct ManualHexagonalRightBevel: View {
	var fill = Color("green.felix")
	var bevelWidth: CGFloat = 10.0

	var body: some View {
		GeometryReader { geometry in
			Path { path in
				let width = min(geometry.size.width, geometry.size.height)
				let height = width / sin(α)
				let center = width / 2
				let side = center / sin(α)
				let tip = side / 2
				let trunk = side
				
				let offset: CGPoint = .zero
				
				let bevelInset = bevelWidth / sin(α)
				
				let insetHexagon = getHexagonParams(
					height: height - bevelInset * 2,
					offset: CGPoint(x: offset.x + bevelWidth, y: offset.y + bevelInset)
				)

				path.addLines([
					CGPoint(x: offset.x + center, y: offset.y), // top
					//CGPoint(x: offset.x + center, y: offset.y + bevelInset), // top inset
					CGPoint(x: offset.x + center, y: insetHexagon.offsetY), // top inset
					
					/*CGPoint(
						x: offset.x + center * 2 - bevelWidth,
						y: offset.y + bevelInset
					), // top inset right
					*/
					CGPoint(
						x: insetHexagon.offsetX + insetHexagon.midX * 2,
						y: insetHexagon.offsetY + insetHexagon.midTopY
					), // top inset right
					CGPoint(
						x: insetHexagon.offsetX + insetHexagon.midX * 2,
						y: insetHexagon.offsetY + insetHexagon.midBotY
					), // bot inset right
					
					CGPoint(
						x: offset.x + center,
						y: insetHexagon.offsetY + insetHexagon.height
					), // bot inset
					
					CGPoint(x: offset.x + center, y: offset.y + tip + trunk + tip), // bot
					
					CGPoint(x: offset.x + center * 2, y: offset.y + tip + trunk), // bot right
					
					
					CGPoint(x: offset.x + center * 2, y: offset.y + tip), // top right
//					CGPoint(x: offset.x, y: offset.y + tip + trunk), // bot left
//					CGPoint(x: offset.x, y: offset.y + tip) // top left
				])
				
//				path.addLines([
//					CGPoint(x: midPoint, y: 0),
//					CGPoint(x: width, y: tip),
//					CGPoint(x: width, y: tip + side),
//					CGPoint(x: midPoint, y: height),
//					CGPoint(x: 0, y: tip + side),
//					CGPoint(x: 0, y: tip)
//				])
			}
			.fill(fill)
		}
	}
}

// MARK: - PREVIEW

struct HexagonShape_Previews: PreviewProvider {
	static var previews: some View {
		HexagonShapeView()
	}
}
