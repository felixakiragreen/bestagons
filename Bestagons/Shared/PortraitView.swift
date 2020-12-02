//
//  PortraitView.swift
//  Bestagons
//
//  Created by Felix Akira Green on 11/29/20.
//

import SwiftUI

// TODO: I should make a "diamond" shape

struct PortraitView: View {
	// MARK: - PROPERTIES

	@State var allVisible = true

	@State var bgVisible = false
//	@State var duration: CGFloat = 4
	@State var bgDuration = 1.0

	@State var headVisible = false
	@State var headDelay = 1.0

	// MARK: - BODY

	var body: some View {
		ZStack {
			Color.black.edgesIgnoringSafeArea(.all)

			HStack {
				VStack {
					Text("Animation Controls")
						.font(.title)

					Button("Start") {
						allVisible.toggle()
						bgVisible.toggle()
						headVisible.toggle()
					}

					VStack(alignment: .leading) {
						Text("Slidey thing → \(bgDuration)")
						Slider(value: $bgDuration, in: 0 ... 10)
					}
				} //: LEFT
				.padding(.horizontal, 16.0)
				GeometryReader { proxy in
					ZStack {
						// BACKGROUND
						PolygonShape(sides: 6)
							.frame(
								maxWidth: allVisible ? .infinity : 0,
								maxHeight: allVisible ? .infinity : 0,
								alignment: .center
							)
							.foregroundColor(Color("grey.500"))
							.animation(.easeInOut(duration: bgDuration))

						// SHIRT
						PolygonShape(sides: 6)
							.frame(
								maxWidth: allVisible ? proxy.size.width : 0,
								maxHeight: allVisible ? proxy.size.height : 0,
								alignment: .center
							)
							.foregroundColor(Color("grey.900"))
							.offset(y: proxy.size.height * 0.6)
							.clipShape(PolygonShape(sides: 6))

						// BODY
						PolygonShape(sides: 6)
							.frame(
								maxWidth: allVisible ? proxy.size.width : 0,
								maxHeight: allVisible ? proxy.size.height : 0,
								alignment: .center
							)
							.foregroundColor(Color("grey.200"))
							.offset(y: -(proxy.size.height * 4 / 24))
							.mask(
								PolygonShape(sides: 6)
									.offset(y: proxy.size.height * 0.6)
							)

						// BUN
						PolygonShape(sides: 6)
							.frame(
								maxWidth: allVisible ? proxy.size.width * 4 / 24 : 0,
								maxHeight: allVisible ? proxy.size.height * 4 / 24 : 0,
								alignment: .center
							)
							.foregroundColor(Color("yellow.800"))
							.offset(y: -proxy.size.height * 7 / 24)
							.animation(
								Animation
									.easeInOut(duration: bgDuration)
									.delay(headDelay)
							)

						// HEAD
						PolygonShape(sides: 6)
							.frame(
								maxWidth: allVisible ? proxy.size.width * 12 / 24 : 0,
								maxHeight: allVisible ? proxy.size.height * 12 / 24 : 0,
								alignment: .center
							)
							.foregroundColor(Color("grey.100"))
							.animation(
								Animation
									.easeInOut(duration: bgDuration)
									.delay(headDelay)
							)

						// HAIRLINE
//						Hairline(proxy: proxy, visible: allVisible)
//							.animation(
//								Animation
//									.easeInOut(duration: 1.0)
//									.delay(1.0)
//							)
						
					} //: ZSTACK
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				} //: RIGHT
				.frame(width: 320, height: 320)
			}
		}
	}
}

// MARK: - PREVIEW

struct PortraitView_Previews: PreviewProvider {
	static var previews: some View {
		PortraitView()
	}
}

struct Hairline: View {
	let proxy: GeometryProxy
	let visible: Bool
//	let duration: Double
//	let delay: Double
	
	var body: some View {
		let width = proxy.size.width
		let height = proxy.size.height
			
		PolygonShape(sides: 6)
			.frame(
				maxWidth: visible ? width * 6 / 24 : 0,
				maxHeight: visible ? height * 6 / 24 : 0,
				alignment: .center
			)
			.foregroundColor(Color("yellow.700"))
			.offset(y: -height * 6 / 24)
			.mask(
				PolygonShape(sides: 6)
					.frame(
						width: width * 12 / 24,
						height: height * 12 / 24
					)
			)
			
	}
}
