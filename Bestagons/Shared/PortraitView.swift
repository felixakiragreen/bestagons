//
//  PortraitView.swift
//  Bestagons
//
//  Created by Felix Akira Green on 11/29/20.
//

import SwiftUI

struct PortraitView: View {
	// MARK: - PROPERTIES

	@State var animationTimeIsForward = true
	@State var animationDuration = 2.0

	let initialVisible = true

	@State var bgVisible = true
	var bgDelayFraction = 0.0
	var bgDurationFraction = 0.9

	@State var headVisible = true
	var headDelayFraction = 0.3
	var headDurationFraction = 1.2

	@State var chestVisible = true
	var chestDelayFraction = 0.6
	var chestDurationFraction = 1.2

	@State var hairVisible = true
	var hairDelayFraction = 0.9
	var hairDurationFraction = 1.2

	@State var shadowVisible = true
	var shadowDelayFraction = 0.9
	var shadowDurationFraction = 1.8
	
	// MARK: - BODY

	var body: some View {
		let fractionalDuration = [
			bgDurationFraction,
			headDurationFraction,
			chestDurationFraction,
			hairDurationFraction,
		].reduce(0, +)

		return ZStack {
			Color("grey.500").edgesIgnoringSafeArea(.all)
//				.onAppear({
//					bgVisible = false
//					headVisible = false
//					chestVisible = false
//					hairVisible = false
//				})

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
					} //: HSTACK LABELS

					// MARK: - ANIMATION SPECS

					Button("animated") {
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
						
						// SHADOW
						withAnimation(
							Animation
								.easeInOut(duration: shadowDurationFraction / fractionalDuration * animationDuration)
								.delay(shadowDelayFraction / fractionalDuration * animationDuration)
						) {
							shadowVisible.toggle()
						}
					}
					
					Button("instant") {
						// flip direction
						bgVisible.toggle()
						headVisible.toggle()
						chestVisible.toggle()
						hairVisible.toggle()
						shadowVisible.toggle()
					}

					VStack(alignment: .leading) {
						Text("Animation Duration → \(animationDuration)")
						Slider(value: $animationDuration, in: 0 ... 10)
					}
				} //: LEFT
				.padding(.horizontal, 16.0)

				GeometryReader { geometry in
					ZStack {
						Background(visible: bgVisible)

						Chest(size: geometry.size, show: chestVisible, showShadow: shadowVisible)

						Bun(size: geometry.size, show: hairVisible, showShadow: shadowVisible)

						Head(size: geometry.size, show: headVisible, showShadow: shadowVisible)

						Hairline(size: geometry.size, show: hairVisible, showShadow: shadowVisible)
					} //: ZSTACK
					.frame(maxWidth: .infinity, maxHeight: .infinity)
//					.drawingGroup()
				} //: RIGHT
				.aspectRatio(1, contentMode: .fit)
				.padding(40)
				.background(Color.black)
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
	let size: CGSize
	let show: Bool
	let showShadow: Bool

	var body: some View {
		ZStack {
			Color("grey.100")
			LinearGradient(
				gradient: Gradient(colors: [
					Color.white,
					Color.black,
				]),
				startPoint: UnitPoint(x: showShadow ? 0.49999 : 0.0, y: 0.0),
				endPoint: UnitPoint(x: showShadow ? 0.50001 : 1.0, y: 0.0)
			) //: LINEAR GRADIENT
			.opacity(0.12)
			.blendMode(.darken)
		} //: FACE
		.frame(
			maxWidth: size.width * 12 / 24,
			maxHeight: size.height * 12 / 24,
			alignment: .center
		)
		.mask(
			PolygonShape(sides: 6)
				.scale(show ? 1 : 0)
		)
	}
}

struct Chest: View {
	let size: CGSize
	let show: Bool
	let showShadow: Bool

	var body: some View {
		ZStack {
			Group {
				Color("grey.900")
				LinearGradient(
					gradient: Gradient(colors: [
						Color.white,
						Color.black,
					]),
					startPoint: UnitPoint(x: showShadow ? 0.49999 : 0.0, y: 0.0),
					endPoint: UnitPoint(x: showShadow ? 0.50001 : 1.0, y: 0.0)
				) //: LINEAR GRADIENT
				.opacity(0.12)
				.blendMode(.lighten)
			}//: SHIRT

			Group {
				Color("grey.200")
				LinearGradient(
					gradient: Gradient(colors: [
						Color.white,
						Color.black,
					]),
					startPoint: UnitPoint(x: showShadow ? 0.49999 : 0.0, y: 0.0),
					endPoint: UnitPoint(x: showShadow ? 0.50001 : 1.0, y: 0.0)
				) //: LINEAR GRADIENT
				.opacity(0.12)
				.blendMode(.darken)
			}//: BODY
			.mask(
				PolygonShape(sides: 6)
					.frame(
						maxWidth: size.width * 16 / 24,
						maxHeight: size.height * 16 / 24,
						alignment: .center
					)
					.foregroundColor(.black)
			)
		} //: ZSTACK → SHIRT & BODY
		.mask(
			PolygonShape(sides: 6)
				.offset(y: size.height * 15 / 24)
		)
		.mask(
			PolygonShape(sides: 6)
				.scale(show ? 1 : 0)
		)
		.offset(y: show ? 0 : -(size.height * 3 / 24))
		.opacity(show ? 1 : 0)
	}
}

struct Hairline: View {
	let size: CGSize
	let show: Bool
	let showShadow: Bool

	var body: some View {
		ZStack {
			Color("yellow.700")
			LinearGradient(
				gradient: Gradient(colors: [
					Color.white,
					Color.black,
				]),
				startPoint: UnitPoint(x: showShadow ? 0.49999 : 0.0, y: 0.0),
				endPoint: UnitPoint(x: showShadow ? 0.50001 : 1.0, y: 0.0)
			) //: LINEAR GRADIENT
			.opacity(0.12)
			.blendMode(.darken)
		}//: ZSTACK
		.frame(
			maxWidth: size.width * 12 / 24,
			maxHeight: size.height * 12 / 24,
			alignment: .center
		)
		.mask(
			StretchyHexagon(trunk: 0)
				.frame(
					width: size.width * 6 / 24,
					height: size.height * 6 / 24
				)
				.scaleEffect(show ? 1 : 0)
		)
		.offset(y: show ? -(size.height * 3 / 24) : -(size.height * 6 / 24))
		.opacity(show ? 1 : 0)
	}
}

struct Bun: View {
	let size: CGSize
	let show: Bool
	let showShadow: Bool

	var body: some View {
		ZStack {
			Color("yellow.800")
			LinearGradient(
				gradient: Gradient(colors: [
					Color.white,
					Color.black,
				]),
				startPoint: UnitPoint(x: showShadow ? 0.49999 : 0.0, y: 0.0),
				endPoint: UnitPoint(x: showShadow ? 0.50001 : 1.0, y: 0.0)
			) //: LINEAR GRADIENT
			.opacity(0.12)
			.blendMode(.darken)
		}//: ZSTACK
		.frame(
			maxWidth: show ? size.width * 4 / 24 : 0,
			maxHeight: show ? size.height * 4 / 24 : 0,
			alignment: .center
		)
		.mask(
			PolygonShape(sides: 6)
				.frame(
					maxWidth: show ? size.width * 4 / 24 : 0,
					maxHeight: show ? size.height * 4 / 24 : 0,
					alignment: .center
				)
		)
		.offset(y: show ? -(size.height * 7 / 24) : -(size.height * 6 / 24))
		.opacity(show ? 1 : 0)
	}
}
