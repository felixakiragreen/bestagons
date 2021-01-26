//
//  RoundedHexagon+preview.swift
//  FutureUI
//
//  Created by Felix Akira Green on 1/24/21.
//

import SwiftUI

struct RoundedHexagon_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			RoundedHexagonView()
				.preferredColorScheme(.dark)
		}
	}
}

struct RoundedHexagonView: View {
	// MARK: - BODY
	var body: some View {
		let s: CGFloat = 80
		
		VStack(spacing: 0) {
			HStack(spacing: 20) {
				PointyRoundedHexagon(cornerRadius: 8)
					.frame(width: s, height: s*2)
					.foregroundColor(Color("blue.400"))
					.overlay(
						ZStack {
							PointyRoundedHexagon(cornerRadius: 8)
								.inset(by: 2)
								.strokeBorder(Color("blue.200"), lineWidth: 2)
							PointyRoundedHexagon(cornerRadius: 8)
								.inset(by: -4)
								.strokeBorder(Color("blue.500"), lineWidth: 2)
							PointyRoundedHexagon(cornerRadius: 8)
								.inset(by: -8)
								.strokeBorder(Color("blue.600"), lineWidth: 2)
						}
					)
				FlatRoundedHexagon(cornerRadius: 8)
					.frame(width: s*2, height: s)
					.foregroundColor(Color("blue.400"))
					.overlay(
						ZStack {
							FlatRoundedHexagon(cornerRadius: 8)
								.inset(by: 2)
								.strokeBorder(Color("blue.200"), lineWidth: 2)
							FlatRoundedHexagon(cornerRadius: 8)
								.inset(by: -4)
								.strokeBorder(Color("blue.500"), lineWidth: 2)
							FlatRoundedHexagon(cornerRadius: 8)
								.inset(by: -8)
								.strokeBorder(Color("blue.600"), lineWidth: 2)
						}
					)
			}
//			HStack(spacing: 20) {
//				RoundedRectangle(cornerRadius: 8)
//					.frame(width: s*2, height: s)
//					.foregroundColor(Color("purple.400"))
//					.overlay(
//						ZStack {
//							RoundedRectangle(cornerRadius: 8)
//								.inset(by: 2)
//								.strokeBorder(Color("purple.200"), lineWidth: 2)
//							RoundedRectangle(cornerRadius: 8)
//								.inset(by: -4)
//								.strokeBorder(Color("purple.500"), lineWidth: 2)
//							RoundedRectangle(cornerRadius: 8)
//								.inset(by: -8)
//								.strokeBorder(Color("purple.600"), lineWidth: 2)
//						}
//					)
//				RoundedRectangle(cornerRadius: 8)
//					.frame(width: s, height: s*2)
//					.foregroundColor(Color("purple.400"))
//					.overlay(
//						ZStack {
//							RoundedRectangle(cornerRadius: 8)
//								.inset(by: 2)
//								.strokeBorder(Color("purple.200"), lineWidth: 2)
//							RoundedRectangle(cornerRadius: 8)
//								.inset(by: -4)
//								.strokeBorder(Color("purple.500"), lineWidth: 2)
//							RoundedRectangle(cornerRadius: 8)
//								.inset(by: -8)
//								.strokeBorder(Color("purple.600"), lineWidth: 2)
//						}
//					)
//
//			}
			let c: CGFloat = 0
			HStack(spacing: 20) {
				
				RoundedHexagon(cornerRadius: 6)
					.frame(width: s*2, height: s)
					.foregroundColor(Color("green.400"))
					.overlay(
						ZStack {
							RoundedHexagon(cornerRadius: 6)
								.inset(by: 2)
								.strokeBorder(Color("green.200"), lineWidth: 2)
							RoundedHexagon(cornerRadius: 6)
								.inset(by: -4)
								.strokeBorder(Color("green.500"), lineWidth: 2)
							RoundedHexagon(cornerRadius: 6)
								.inset(by: -8)
								.strokeBorder(Color("green.600"), lineWidth: 2)
						}
					)
				RoundedHexagon(cornerRadius: c)
					.fill(
						LinearGradient(gradient:
												Gradient(colors: [ Color("green.400"), Color("green.600") ]),
											startPoint: .top,
											endPoint: .bottom
						)
					)
					//					.hexagonalFrame(width: s)
					.frame(width: s, height: s*2)
					.overlay(
						ZStack {
							RoundedHexagon(cornerRadius: 2)
								.inset(by: 2)
								.strokeBorder(Color("green.200").opacity(0.5), lineWidth: 2)
							RoundedHexagon(cornerRadius: c)
								.inset(by: -4)
								.strokeBorder(Color("green.500"), lineWidth: 2)
							RoundedHexagon(cornerRadius: c)
								.inset(by: -8)
								.strokeBorder(Color("green.600"), lineWidth: 2)
						}
					)
			}
		}
	}
}
