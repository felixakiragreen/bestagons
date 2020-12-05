//
//  PortraitView.swift
//  Bestagons
//
//  Created by Felix Akira Green on 11/29/20.
//

import SwiftUI

enum AnimationVersion: Int {
	case gradient = 1, blur
}

struct PortraitView: View {
	// MARK: - PROPERTIES

	var initiallyVisible = false

	// MARK: - STATE

	@State var animationTimeIsForward = true
	@State var animationDuration = 2.0
	
	@State var animationVersion = AnimationVersion.blur
	
	
	@State var bgVisible = false
	var bgDelayFraction = 0.0
	var bgDurationFraction = 0.9

	@State var headVisible = false
	var headDelayFraction = 0.3
	var headDurationFraction = 1.2

	@State var chestVisible = false
	var chestDelayFraction = 0.6
	var chestDurationFraction = 1.2

	@State var hairVisible = false
	var hairDelayFraction = 0.9
	var hairDurationFraction = 1.2

	@State var shadowVisible = false
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
			HStack {
				VStack(spacing: 16) {
					Text("Animation Controls")
						.font(.title)
						.onAppear {
							if initiallyVisible {
								self.bgVisible.toggle()
								self.headVisible.toggle()
								self.chestVisible.toggle()
								self.hairVisible.toggle()
								self.shadowVisible.toggle()
							}
						}
					HStack {
						// MARK: - ANIMATION SPECS
						
						Button("withAnimation") {
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
					} //: HSTACK LABELS
					
					Picker(selection: $animationVersion, label: Text("Animation Style")) {
						Text("gradient {v1}").tag(AnimationVersion.gradient)
						Text("blur {v2}").tag(AnimationVersion.blur)
					}.pickerStyle(PopUpButtonPickerStyle())
					
					VStack(alignment: .leading) {
						Text("Animation Duration → \(animationDuration, specifier: "%.2f")")
						Slider(value: $animationDuration, in: 0 ... 10)
					}
				} //: LEFT
				.padding(.horizontal, 16.0)

				GeometryReader { geometry in
					ZStack {
						Background(visible: bgVisible)

						Chest(
							size: geometry.size,
							show: chestVisible,
							showShadow: shadowVisible,
							version: animationVersion
						)

						Bun(
							size: geometry.size,
							show: hairVisible,
							showShadow: shadowVisible,
							version: animationVersion
						)

						Head(
							size: geometry.size,
							show: headVisible,
							showShadow: shadowVisible,
							version: animationVersion
						)

						Hairline(
							size: geometry.size,
							show: hairVisible,
							showShadow: shadowVisible,
							version: animationVersion
						)
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

// MARK: - SUBVIEWS

struct ShadowAnimatedBlur: View {
	let blend: BlendMode
	let show: Bool
	
	var body: some View {
		HStack(spacing: 0.0) {
			Color.white
			Color.black
		}//: HSTACK
		.blur(radius: show ? 0.0 : 100.0)
		.opacity(0.12)
		.blendMode(blend)
	}
}

struct FractionalFrameModifier: ViewModifier {
	let size: CGSize
	let fraction: CGFloat
	
	func body(content: Content) -> some View {
		content
			.frame(
				maxWidth: size.width * fraction,
				maxHeight: size.height * fraction,
				alignment: .center
			)
	}
}

extension View {
	func fractionalFrame(size: CGSize, fraction: CGFloat) -> some View {
		self
//			.modifier(
//				FractionalFrameModifier(size: size, fraction: fraction)
//			)
			.frame(
				maxWidth: size.width * fraction,
				maxHeight: size.height * fraction,
				alignment: .center
			)
	}
}

// MARK: - BACKGROUND

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

// MARK: - CHEST

struct Chest: View {
	let size: CGSize
	let show: Bool
	let showShadow: Bool
	let version: AnimationVersion

	var body: some View {
		ZStack {
			Group {
				Color("grey.900")
				switch version {
				case AnimationVersion.gradient:
					shirtShadow1
				case AnimationVersion.blur:
					ShadowAnimatedBlur(blend: .lighten, show: showShadow)
				}
			}//: SHIRT

			Group {
				Color("grey.200")
				switch version {
				case AnimationVersion.gradient:
					bodyShadow1
				case AnimationVersion.blur:
					ShadowAnimatedBlur(blend: .darken, show: showShadow)
				}
			}//: BODY
			.mask(
				PolygonShape(sides: 6)
					.fractionalFrame(size: size, fraction: 16 / 24)
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
	
	var shirtShadow1: some View {
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
	}

	var bodyShadow1: some View {
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
	}
}

// MARK: - BUN

struct Bun: View {
	let size: CGSize
	let show: Bool
	let showShadow: Bool
	let version: AnimationVersion

	var body: some View {
		ZStack {
			Color("yellow.800")
			switch version {
			case AnimationVersion.gradient:
				bunShadow1
			case AnimationVersion.blur:
				ShadowAnimatedBlur(blend: .darken, show: showShadow)
			}
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
//		.opacity(show ? 1 : 0)
	}
	
	var bunShadow1: some View {
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
	}
}

// MARK: - HEAD

struct Head: View {
	let size: CGSize
	let show: Bool
	let showShadow: Bool
	let version: AnimationVersion

	var body: some View {
		ZStack {
			Color("grey.100")
			switch version {
			case AnimationVersion.gradient:
				headShadow1
			case AnimationVersion.blur:
				ShadowAnimatedBlur(blend: .darken, show: showShadow)
			}
		} //: FACE
		.fractionalFrame(size: size, fraction: 12 / 24)
		.mask(
			PolygonShape(sides: 6)
				.scale(show ? 1 : 0)
		)
	}
	
	var headShadow1: some View {
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
	}
}

// MARK: - HARLINE

struct Hairline: View {
	let size: CGSize
	let show: Bool
	let showShadow: Bool
	let version: AnimationVersion

	var body: some View {
		ZStack {
			Color("yellow.700")
			switch version {
			case AnimationVersion.gradient:
				hairlineShadow1
			case AnimationVersion.blur:
				ShadowAnimatedBlur(blend: .darken, show: showShadow)
			}
		}//: ZSTACK
		.fractionalFrame(size: size, fraction: 12 / 24)
		.mask(
			StretchyHexagon(trunk: 0)
				.frame(
					width: size.width * 6 / 24,
					height: size.height * 6 / 24
				)
				.scaleEffect(show ? 1 : 0)
		)
		.offset(y: show ? -(size.height * 3 / 24) : -(size.height * 6 / 24))
//		.opacity(show ? 1 : 0)
	}
	
	var hairlineShadow1: some View {
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
	}
}

// MARK: - PREVIEW

struct PortraitView_Previews: PreviewProvider {
	static var previews: some View {
		PortraitView(initiallyVisible: true)
	}
}
