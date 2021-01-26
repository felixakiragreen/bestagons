//
//  Hexagon.swift
//  FutureUI
//
//  Created by Felix Akira Green on 1/24/21.
//

import SwiftUI

/// Math for drawing hexagonal angles
let α = CGFloat(Double.pi / 3)

enum HexagonalOrientation {
	case pointy, flat
}

struct Hexagon: InsettableShape {
	var inset: CGFloat = 0
	var regular: Bool = false
	var orientation: HexagonalOrientation?
	
	func inset(by amount: CGFloat) -> some InsettableShape {
		var hex = self
		hex.inset += amount
		return hex
	}
	
	func path(in rect: CGRect) -> Path {
		var o: HexagonalOrientation {
			if let orientation = orientation {
				return orientation
			} else if rect.size.width > rect.size.height {
				return .flat
			} else {
				return .pointy
			}
		}
		
		return HexagonalConstruction(
			rect: rect,
			inset: inset,
			regular: regular,
			orientation: o
		).path()
	}
}

// MARK: - CONSTRUCTION

/**
Wondering if maybe I should have a Hexagonal Construction that's more split up
then have Hexagonal + Inset
then have Hexagonal + Rounded
*/

struct HexagonalConstruction {
	
	// MARK: - 0. Params
	
	var rect: CGRect
	var inset: CGFloat = 0
	var regular: Bool = false
	var orientation: HexagonalOrientation
	var pointy: Bool { orientation == .pointy }
	
	// MARK: - 1. Dimensions
	
	var midX: CGFloat { rect.size.width / 2 } /// midpoint X
	var midY: CGFloat { rect.size.height / 2 } /// midpoint Y
	var half: CGFloat { min(midX, midY) } /// take smaller dimension for fitting a regular hexagon inside
	var side: CGFloat { half / sin(α) } /// the length of a side of a regular hexagon (equivalent to the half height)
	
	// MARK: - 2. Lines
	
	/// where the vertical center is for drawing the points & width (vertical becase it's across X)
	var mX: CGFloat {
		switch (pointy, regular) {
			case (true, true):
				/// pointy + regular
				return half
			case (false, true):
				/// flat + regular
				return side
			default:
				/// pointy,flat + irregular
				return midX
		}
	}
	/// where the horizontal center is for drawing the height (horizontal because it's across Y)
	var mY: CGFloat {
		switch (pointy, regular) {
			case (true, true):
				/// pointy + regular
				return side
			case (false, true):
				/// flat + regular
				return half
			default:
				/// pointy,flat + irregular
				return midY
		}
	}
	/// how long to make the pointy part
	var tip: CGFloat {
		switch (pointy, regular) {
			case (true, false):
				/// pointy + irregular
				return midX / sin(α) / 2
			case (false, false):
				/// flat + irregular
				return midY / sin(α) / 2
			default:
				/// pointy,flat + regular
				return side / 2
		}
	}
	
	// MARK: - 3. Inset
	
	/// {Flat is FLIPPED Pointy}
	var i: CGFloat { inset / sin(α) }
	/// In a 30,60,90 right angle triangle
	/// the long side (hypotenuse) is `i`, the medium side is (b) and the short side is (a)
	/// Pointy → b = `iX`, a = `iY`
	/// Flat → b = `iY`, a = `iX`
	var iX: CGFloat { pointy ? inset : i * cos(α) }
	var iY: CGFloat { pointy ? i * cos(α) : inset }
	/// FYI: don't need to calculate sin() since `inset = i * sin(α)`
	
	
	// MARK: - 4. Corners
	
	/// step 4 → corners (the six vertices) {Flat is FLIPPED Pointy}
	var c1: CGPoint { pointy
		? CGPoint(x: iX, y: tip + iY) /// topLeading
		: CGPoint(x: tip + iX, y: mY * 2 - iY) /// bottomLeading
	}
	var c2: CGPoint { pointy
		? CGPoint(x: mX, y: i) /// top
		: CGPoint(x: i, y: mY) /// leading
	}
	var c3: CGPoint { pointy
		? CGPoint(x: mX * 2 - iX, y: tip + iY) /// topTrailing
		: CGPoint(x: tip + iX, y: iY) /// topLeading
	}
	var c4: CGPoint { pointy
		? CGPoint(x: mX * 2 - iX, y: mY * 2 - tip - iY) /// bottomTrailing
		: CGPoint(x: mX * 2 - tip - iX, y: iY) /// topTrailing
	}
	var c5: CGPoint { pointy
		? CGPoint(x: mX, y: mY * 2 - i) /// bottom
		: CGPoint(x: mX * 2 - i, y: mY) /// trailing
	}
	var c6: CGPoint { pointy
		? CGPoint(x: iX, y: mY * 2 - tip - iY) /// bottomLeading
		: CGPoint(x: mX * 2 - tip - iX, y: mY * 2 - iY) /// bottomTrailing
	}
	
	func path() -> Path {
		Path { path in
			path.addLines([c1, c2, c3, c4, c5, c6])
			path.closeSubpath()
		}
	}
}
