//
//  FlowerView.swift
//  Bestagons
//
//  Created by Felix Akira Green on 11/27/20.
//

import SwiftUI

struct FlowerView: View {
	@State private var flowerOut = false

	var body: some View {
		ZStack {
			Color.black.edgesIgnoringSafeArea(.all)

			ZStack {
				ForEach(0 ..< 6) {
					Circle()
						.foregroundColor(Color(red: 0.6, green: 0.9, blue: 0.8))
						.frame(width: 200, height: 200)
						.offset(x: self.flowerOut ? 100 : 0)
						.rotationEffect(.degrees(Double($0) * 60))
						.blendMode(.hardLight)
				}
			}
			.rotationEffect(.degrees(flowerOut ? 120 : 0))
			.scaleEffect(flowerOut ? 1 : 0.25)
			.animation(Animation.easeInOut(duration: 4).delay(0.75).repeatForever(autoreverses: true))
			.onAppear {
				self.flowerOut.toggle()
			}
		}
	}
}

struct FlowerView_Previews: PreviewProvider {
	static var previews: some View {
		FlowerView()
	}
}
