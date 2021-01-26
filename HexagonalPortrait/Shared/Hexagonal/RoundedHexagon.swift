//
//  RoundedHexagon.swift
//  FutureUI
//
//  Created by Felix Akira Green on 1/24/21.
//

import SwiftUI

// MARK: - RoundedHexagon

struct RoundedHexagon: InsettableShape {
	let cornerRadius: CGFloat
	var inset: CGFloat = 0
	var regular: Bool = false
	var orientation: HexagonalOrientation?
	
	func inset(by amount: CGFloat) -> some InsettableShape {
		var hex = self
		hex.inset += amount
		return hex
	}
	
	func path(in rect: CGRect) -> Path {
		/// step 0 → orientation
		var o: HexagonalOrientation {
			if let orientation = orientation {
				return orientation
			}
			else if rect.size.width > rect.size.height {
				return .flat
			} else {
				return .pointy
			}
		}
		
		/// step 1 → profit
		if o == .pointy {
			return PointyRoundedHexagon(
				cornerRadius: cornerRadius,
				inset: inset,
				regular: regular
			).path(in: rect)
		} else {
			return FlatRoundedHexagon(
				cornerRadius: cornerRadius,
				inset: inset,
				regular: regular
			).path(in: rect)
		}
	}
}

// MARK: - Rounded ⬢

struct PointyRoundedHexagon: InsettableShape {
	let cornerRadius: CGFloat
	var inset: CGFloat = 0
	var regular: Bool = false
	
	func inset(by amount: CGFloat) -> some InsettableShape {
		var hex = self
		hex.inset += amount
		return hex
	}
	
	func path(in rect: CGRect) -> Path {
		/// step 1 → dimensions
		let midX = rect.size.width / 2 /// midpoint X
		let midY = rect.size.height / 2 /// midpoint Y
		let half = min(midX, midY) /// take smaller dimension for fitting a regular hexagon inside
		let side = half / sin(α) /// the length of a side of a regular hexagon (equivalent to the half height)
		
		/// step 1b → regular / irregular
		/// where the vertical center is for drawing the points & width (vertical becase it's across X)
		var mX: CGFloat { regular ? half : midX }
		var mY: CGFloat { /// where the horizontal center is for drawing the height (horizontal because it's across Y)
			if regular { return side }
			else { return midY }
		}
		var tip: CGFloat { /// how long to make the pointy part
			if regular { return side / 2 }
			else { return midX / sin(α) / 2 }
		}
		
		/// step 2 → inset
		let i = inset / sin(α)
		/// In a 30,60,90 right angle triangle
		/// the long side (hypotenuse) is `i`
		/// the medium side (b) is `iX`, and the short side (a) is `iY`
		let iX = inset // aka: i * sin(α)
		let iY = i * cos(α)
		
		/// step 3 → corners (the six vertices)
		let c1 = CGPoint(x: iX, y: tip + iY) /// topLeading
		let c2 = CGPoint(x: mX, y: i) /// top
		let c3 = CGPoint(x: mX * 2 - iX, y: tip + iY) /// topTrailing
		
		let c4 = CGPoint(x: mX * 2 - iX, y: mY * 2 - tip - iY) /// bottomTrailing
		let c5 = CGPoint(x: mX, y: mY * 2 - i) /// bottom
		let c6 = CGPoint(x: iX, y: mY * 2 - tip - iY) /// bottomLeading
		
		/// step 4 → rounding corners
		let adjustedRadius = (cornerRadius - iY) * 1.162 // compensating for "continuous"
		let r = min(adjustedRadius, tip)
		
		/// > In a 30,60,90 right angle triangle
		/// > the long side (hypotenuse) is `r`
		/// > the medium side (b) is `rX`, and the short side (a) is `rY`
		let rX = r * sin(α)
		let rY = r * cos(α)
		
		/// step 4b → corner vertex offset by corner radius
		/// > `c12` is corner1 (`c1`) transformed by cornerRadius (`rX` & `rY`) towards corner2 (`c2`)
		/// > `c21` is corner2 transformed by cornerRadius towards corner1
		let c12 = CGPoint(x: c1.x + rX, y: c1.y - rY)
		let c16 = CGPoint(x: c1.x, y: c1.y + r)
		
		let c21 = CGPoint(x: c2.x - rX, y: c2.y + rY)
		let c23 = CGPoint(x: c2.x + rX, y: c2.y + rY)
		
		let c32 = CGPoint(x: c3.x - rX, y: c3.y - rY)
		let c34 = CGPoint(x: c3.x, y: c3.y + r)
		
		let c43 = CGPoint(x: c4.x, y: c4.y - r)
		let c45 = CGPoint(x: c4.x - rX, y: c4.y + rY)
		
		let c54 = CGPoint(x: c5.x + rX, y: c5.y - rY)
		let c56 = CGPoint(x: c5.x - rX, y: c5.y - rY)
		
		let c65 = CGPoint(x: c6.x + rX, y: c6.y + rY)
		let c61 = CGPoint(x: c6.x, y: c6.y - r)
		
		return Path { path in
			/// .topLeading
			path.move(to: c16)
			path.addQuadCurve(to: c12, control: c1)
			
			/// .top
			path.addLine(to: c21)
			path.addQuadCurve(to: c23, control: c2)
			
			/// .topTrailing
			path.addLine(to: c32)
			path.addQuadCurve(to: c34, control: c3)
			
			/// .bottomTrailing
			path.addLine(to: c43)
			path.addQuadCurve(to: c45, control: c4)
			
			/// .bottom
			path.addLine(to: c54)
			path.addQuadCurve(to: c56, control: c5)
			
			/// .bottomLeading
			path.addLine(to: c65)
			path.addQuadCurve(to: c61, control: c6)
			
			path.closeSubpath()
		}
	}
}

// MARK: - Rounded ⬣

struct FlatRoundedHexagon: InsettableShape {
	let cornerRadius: CGFloat
	var inset: CGFloat = 0
	var regular: Bool = false
	
	func inset(by amount: CGFloat) -> some InsettableShape {
		var hex = self
		hex.inset += amount
		return hex
	}
	
	func path(in rect: CGRect) -> Path {
		/// step 1 → dimensions
		let midX = rect.size.width / 2 /// midpoint X
		let midY = rect.size.height / 2 /// midpoint Y
		let half = min(midX, midY) /// take smaller dimension for fitting a regular hexagon inside
		let side = half / sin(α) /// the length of a side of a regular hexagon (equivalent to the half height)
		
		/// step 1b → regular / irregular
		var mX: CGFloat { /// where the vertical center is for drawing the points & width (vertical becase it's across X)
			if regular { return side }
			else { return midX }
		}
		var mY: CGFloat { /// where the horizontal center is for drawing the height (horizontal because it's across Y)
			if regular { return half }
			else { return midY }
		}
		var tip: CGFloat { /// how long to make the pointy part
			if regular { return side / 2 }
			else { return midY / sin(α) / 2 }
		}
		
		/// step 2 → inset {Flat is FLIPPED Pointy}
		let i = inset / sin(α)
		/// In a 30,60,90 right angle triangle
		/// the long side (hypotenuse) is `i`
		/// the medium side (b) is `iY`, and the short side (a) is `iX`
		let iX = i * cos(α)
		let iY = inset // aka: i * sin(α)
		
		
		
		/// step 3 → corners (the six vertices) {Flat is FLIPPED Pointy}
		let c1 = CGPoint(x: tip + iX, y: mY * 2 - iY) /// bottomLeading
		let c2 = CGPoint(x: i, y: mY) /// leading
		let c3 = CGPoint(x: tip + iX, y: iY) /// topLeading
		
		let c4 = CGPoint(x: mX * 2 - tip - iX, y: iY) /// topTrailing
		let c5 = CGPoint(x: mX * 2 - i, y: mY) /// trailing
		let c6 = CGPoint(x: mX * 2 - tip - iX, y: mY * 2 - iY) /// bottomTrailing
		
		
		/// step 4 → rounding corners  {Flat is FLIPPED Pointy}
		let adjustedRadius = (cornerRadius - iX) * 1.162 // compensating for "continuous"
		let r = min(adjustedRadius, tip)
		
		/// > In a 30,60,90 right angle triangle
		/// > the long side (hypotenuse) is `r`
		/// > the medium side (b) is `rY`, and the short side (a) is `rX`
		let rX = r * cos(α)
		let rY = r * sin(α)
		
		/// step 4b → corner vertex offset by corner radius {Flat is DIFFERENT Pointy}
		/// > `c12` is corner1 (`c1`) transformed by cornerRadius (`rX` & `rY`) towards corner2 (`c2`)
		/// > `c21` is corner2 transformed by cornerRadius towards corner1
		let c12 = CGPoint(x: c1.x - rX, y: c1.y - rY)
		let c16 = CGPoint(x: c1.x + r, y: c1.y)
		
		let c21 = CGPoint(x: c2.x + rX, y: c2.y + rY)
		let c23 = CGPoint(x: c2.x + rX, y: c2.y - rY)
		
		let c32 = CGPoint(x: c3.x - rX, y: c3.y + rY)
		let c34 = CGPoint(x: c3.x + r, y: c3.y)
		
		let c43 = CGPoint(x: c4.x - r, y: c4.y)
		let c45 = CGPoint(x: c4.x + rX, y: c4.y + rY)
		
		let c54 = CGPoint(x: c5.x - rX, y: c5.y - rY)
		let c56 = CGPoint(x: c5.x - rX, y: c5.y + rY)
		
		let c65 = CGPoint(x: c6.x + rX, y: c6.y - rY)
		let c61 = CGPoint(x: c6.x - r, y: c6.y)
		
		return Path { path in
			/// .topLeading
			path.move(to: c16)
			path.addQuadCurve(to: c12, control: c1)
			
			/// .top
			path.addLine(to: c21)
			path.addQuadCurve(to: c23, control: c2)
			
			/// .topTrailing
			path.addLine(to: c32)
			path.addQuadCurve(to: c34, control: c3)
			
			/// .bottomTrailing
			path.addLine(to: c43)
			path.addQuadCurve(to: c45, control: c4)
			
			/// .bottom
			path.addLine(to: c54)
			path.addQuadCurve(to: c56, control: c5)
			
			/// .bottomLeading
			path.addLine(to: c65)
			path.addQuadCurve(to: c61, control: c6)
			
			path.closeSubpath()
		}
	}
}
