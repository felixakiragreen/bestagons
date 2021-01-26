//
//  View+hexagonalFrame.swift
//  FutureUI
//
//  Created by Felix Akira Green on 1/24/21.
//

import SwiftUI

extension View {
	func hexagonalFrame(width: CGFloat, orientation: HexagonalOrientation = .pointy) -> some View {
		frame(
			width: width,
			height: orientation == .pointy ? width / sin(α) : width * sin(α),
			alignment: .center
		)
	}
	
	func hexagonalFrame(height: CGFloat, orientation: HexagonalOrientation = .pointy) -> some View {
		frame(
			width: orientation == .pointy ? height * sin(α) : height / sin(α),
			height: height,
			alignment: .center
		)
	}
}
