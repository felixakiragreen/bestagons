//
//  FlowerView.swift
//  Bestagons
//
//  Created by Felix Akira Green on 11/27/20.
//

import SwiftUI

struct FlowerView: View {
	@State private var flowerOut = false

	var sides = 6	
	
	var flower: some View {
		ZStack {
			ForEach(0..<sides) { n in
				PolygonShape(sides: sides)
					.frame(width: 180, height: 180)
					.offset(x: self.flowerOut ? 78 : 0)
					.rotationEffect(.degrees(Double(n) * 60))
					.blendMode(.hardLight)
			}
		}
	}
	
	var body: some View {
		ZStack {
			Color.black.edgesIgnoringSafeArea(.all)
			
//			flower
//				.blendMode(.hardLight)
//				.foregroundColor(.blue)
//				.opacity(flowerOut ? 1.0 : 0.0)
//				.blur(radius: flowerOut ? 0.1 : 20)
//				.scaleEffect(flowerOut ? 1.0 : 2.0)
//				.rotationEffect(.degrees(flowerOut ? 120 : 0))
//				.animation(Animation.easeInOut(duration: 3).delay(0.5)
//					.repeatForever(autoreverses: false)
//				)
			
			LinearGradient(
				gradient: Gradient(
					colors: [Color("blue.600"), Color("yellow.600")]
				),
				startPoint: UnitPoint(x: -0.0, y: -0.0),
				endPoint: UnitPoint(x: 1.0, y: 1.0)
			)
			.opacity(0.5)
			.blendMode(.luminosity)
			
			.mask(
				flower
//					.blendMode(.hardLight)
//					.blur(radius: 3)
					.scaleEffect(flowerOut ? 1 : 0.33)
					.rotationEffect(.degrees(flowerOut ? 120 : 0))
					.animation(Animation.easeInOut(duration: 3.0).delay(1.0)
						.repeatForever(autoreverses: true)
					)
			)
			
			ZStack {
				ForEach(0..<sides) { n in
//					let colors = n.isMultiple(of: 2)
//						? [Color.blue.opacity(0.5), Color("felixGreen")]
//						: [Color.yellow.opacity(0.05), Color("felixGreen")]

					PolygonShape(sides: sides)
						.foregroundColor(Color.white.opacity(0.5))
						.blendMode(.overlay)
//						.fill(
//							LinearGradient(
//								gradient: Gradient(colors: colors),
//								startPoint: UnitPoint(x: 0.00, y: 0.00),
//								endPoint: UnitPoint(x: 1.00, y: 1.00)
//							)
//						)
						.frame(width: 180, height: 180)
						.offset(x: self.flowerOut ? 78 : 0)
						.rotationEffect(.degrees(Double(n) * 60))
//						.opacity(0.5)
//						.blendMode(.overlay)
				}
			}
//			.opacity(0.5)
//			.blendMode(.softLight)
			.scaleEffect(flowerOut ? 1 : 0.33)
			.rotationEffect(.degrees(flowerOut ? 120 : 0))
//			.blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
			
			.animation(Animation.easeInOut(duration: 3.0).delay(1.0).repeatForever(autoreverses: true))
//			.animation(
//				Animation.spring(response: 1.0, dampingFraction: 1.0, blendDuration: 0.05)
////					.delay(1.0)
////					.repeatForever(autoreverses: true)
////					.repeatForever()
//					.repeatCount(3)
//			)
//
//			.animation(Animation.spring().delay(0.75).repeatForever(autoreverses: true))
			.onAppear {
				self.flowerOut.toggle()
			}
//			.onTapGesture {
//				flowerOut.toggle()
//			}
			
			
		}
//		.frame(width: 600, height: 600)
//		.drawingGroup()
		
		
		
	}



}

struct FlowerView_Previews: PreviewProvider {
	static var previews: some View {
		FlowerView()
	}
}
