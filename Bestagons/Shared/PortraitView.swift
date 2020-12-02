//
//  PortraitView.swift
//  Bestagons
//
//  Created by Felix Akira Green on 11/29/20.
//

import SwiftUI

/*
FOLLOW UP:
- make a "diamond" shape (for the chest, hair)
- add the shadow
- add sliders for the other fractions
*/

struct PortraitView: View {
	// MARK: - PROPERTIES

	@State var animationTimeIsForward = true
	@State var animationDuration = 3.0

	@State var bgVisible = false
	var bgDelayFraction = 0.0
	var bgDurationFraction = 1.0

	@State var headVisible = false
	var headDelayFraction = 0.5
	var headDurationFraction = 1.0

	@State var chestVisible = false
	var chestDelayFraction = 1.0
	var chestDurationFraction = 1.0

	@State var hairVisible = false
	var hairDelayFraction = 1.5
	var hairDurationFraction = 1.0

	// MARK: - BODY

	var body: some View {
		let fractionalDuration = [
			bgDurationFraction,
			headDurationFraction,
			chestDurationFraction,
			hairDurationFraction
		].reduce(0, +)

		return ZStack {
			Color.black.edgesIgnoringSafeArea(.all)

			HStack {
				VStack(spacing: 16) {
					Text("Animation Controls")
						.font(.title)
					HStack {
						VStack(alignment: .leading) {
							Text("bgVisible → \(String(bgVisible))")
							Text("headVisible → \(String(headVisible))")
							Text("chestVisible → \(String(chestVisible))")
							Text("hairVisible → \(String(hairVisible))")
						}
						Spacer()
					}//: HSTACK LABELS

					// MARK: - ANIMATION SPECS

					Button("toggle") {
						// flip direction
						animationTimeIsForward.toggle()

						// BG
						withAnimation(
							Animation
								.easeInOut(duration: bgDurationFraction / fractionalDuration * animationDuration)
								.delay(bgDelayFraction / fractionalDuration * animationDuration)
						) {
							bgVisible.toggle()
						}

						// HEAD
						withAnimation(
							Animation
								.easeInOut(duration: headDurationFraction / fractionalDuration * animationDuration)
								.delay(headDelayFraction / fractionalDuration * animationDuration)
						) {
							headVisible.toggle()
						}

						// CHEST
						withAnimation(
							Animation
								.easeInOut(duration: chestDurationFraction / fractionalDuration * animationDuration)
								.delay(chestDelayFraction / fractionalDuration * animationDuration)
						) {
							chestVisible.toggle()
						}

						// HAIR
						withAnimation(
							Animation
								.easeInOut(duration: hairDurationFraction / fractionalDuration * animationDuration)
								.delay(hairDelayFraction / fractionalDuration * animationDuration)
						) {
							hairVisible.toggle()
						}
					}

					VStack(alignment: .leading) {
						Text("Animation Duration → \(animationDuration)")
						Slider(value: $animationDuration, in: 0 ... 10)
					}
				} //: LEFT
				.padding(.horizontal, 16.0)

				GeometryReader { proxy in
					ZStack {
						Background(visible: bgVisible)

						Chest(proxy: proxy, visible: chestVisible)

						Bun(proxy: proxy, visible: hairVisible)

						Head(proxy: proxy, visible: headVisible)

						Hairline(proxy: proxy, visible: hairVisible)
					} //: ZSTACK
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				} //: RIGHT
				.frame(width: 320, height: 320)
				.padding(40)
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

// MARK: - SUBVIEWS

struct Background: View {
	let visible: Bool

	var body: some View {
		PolygonShape(sides: 6)
			.frame(
				maxWidth: visible ? .infinity : 0,
				maxHeight: visible ? .infinity : 0,
				alignment: .center
			)
			.foregroundColor(Color("grey.500"))
	}
}

struct Head: View {
	let proxy: GeometryProxy
	let visible: Bool

	var body: some View {
		PolygonShape(sides: 6)
			.frame(
				maxWidth: visible ? proxy.size.width * 12 / 24 : 0,
				maxHeight: visible ? proxy.size.height * 12 / 24 : 0,
				alignment: .center
			)
			.foregroundColor(Color("grey.100"))
	}
}

struct Chest: View {
	let proxy: GeometryProxy
	let visible: Bool

	var body: some View {
		Group {
			// SHIRT
			PolygonShape(sides: 6)
				.frame(
					maxWidth: proxy.size.width,
					maxHeight: proxy.size.height,
					alignment: .center
				)
				.foregroundColor(Color("grey.900"))
				.offset(y: proxy.size.height * 0.6)
				.clipShape(PolygonShape(sides: 6))

			// BODY
			PolygonShape(sides: 6)
				.frame(
					maxWidth: proxy.size.width,
					maxHeight: proxy.size.height,
					alignment: .center
				)
				.foregroundColor(Color("grey.200"))
				.offset(y: -(proxy.size.height * 4 / 24))
				.mask(
					PolygonShape(sides: 6)
						.offset(y: proxy.size.height * 0.6)
				)
		} //: SHIRT & BODY
		.offset(y: visible ? 0 : proxy.size.height * 4 / 24)
		.opacity(visible ? 1 : 0)
	}
}

struct Hairline: View {
	let proxy: GeometryProxy
	let visible: Bool

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
			.opacity(visible ? 1 : 0)
			.mask(
				PolygonShape(sides: 6)
					.frame(
						width: width * 12 / 24,
						height: height * 12 / 24
					)
			)
	}
}

struct Bun: View {
	let proxy: GeometryProxy
	let visible: Bool

	var body: some View {
		PolygonShape(sides: 6)
			.frame(
				maxWidth: visible ? proxy.size.width * 4 / 24 : 0,
				maxHeight: visible ? proxy.size.height * 4 / 24 : 0,
				alignment: .center
			)
			.foregroundColor(Color("yellow.800"))
			.offset(y: visible ? -proxy.size.height * 7 / 24 : -proxy.size.height * 6 / 24)
			.opacity(visible ? 1 : 0)
	}
}
