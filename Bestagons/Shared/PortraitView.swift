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

// Animation Transition Proportion - abbreviating because I'm tired of long names
struct AxP {
	var start: Double // 0.0 - 1.0 ... 0.1 would start 10% of the way into the animation
	var end: Double // 0.0 - 1.0 ... 1.0 would end at the end of the whole animation
}

struct PortraitView: View {
	// MARK: - PROPERTIES

	var initiallyVisible = false

	// MARK: - STATE

	@State var animationTimeIsForward = true
	@State var isReversing = false
	@State var isLooping = false
	@State var animationDuration = 2.0

	@State var animationVersion = AnimationVersion.blur

	@State var bgVisible = false
	@State var bgAxP = AxP(start: 0.0, end: 0.35)

	@State var headVisible = false
	@State var headAxP = AxP(start: 0.15, end: 0.5)

	@State var chestVisible = false
	@State var chestAxP = AxP(start: 0.3, end: 0.65)

	@State var hairVisible = false
	@State var hairAxP = AxP(start: 0.55, end: 0.9)

	@State var shadowVisible = false
	@State var shadowAxP = AxP(start: 0.6, end: 1.0)
	
	let stepperUnit = 0.05

	// MARK: - BODY

	var body: some View {
		let bgAnimation = proportionallyDelayedAx(bgAxP)
		let headAnimation = proportionallyDelayedAx(headAxP)
		let chestAnimation = proportionallyDelayedAx(chestAxP)
		let hairAnimation = proportionallyDelayedAx(hairAxP)
		let shadowAnimation = proportionallyDelayedAx(shadowAxP)

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
						Toggle(isOn: $isReversing) {
							Text("isReversing")
						}
						Toggle(isOn: $isLooping) {
							Text("isLooping")
						}
						Spacer()
					}
					HStack {
						// MARK: - ANIMATION SPECS

						Button("short") {
							animationDuration = 1.5
						}
						Button("long") {
							animationDuration = 3.0
						}
						
						Button("withAnimation") {
							// flip direction
							animationTimeIsForward.toggle()
							isReversing.toggle()

							// BG
							withAnimation(bgAnimation) {
								bgVisible.toggle()
							}

							// HEAD
							withAnimation(headAnimation) {
								headVisible.toggle()
							}

							// CHEST
							withAnimation(chestAnimation) {
								chestVisible.toggle()
							}

							// HAIR
							withAnimation(hairAnimation) {
								hairVisible.toggle()
							}

							// SHADOW
							withAnimation(shadowAnimation) {
								shadowVisible.toggle()
							}

							/*: v1
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
							 */
						}

						Button("without") {
							// flip direction
							animationTimeIsForward.toggle()
							isReversing.toggle()
							//
							bgVisible.toggle()
							headVisible.toggle()
							chestVisible.toggle()
							hairVisible.toggle()
							shadowVisible.toggle()
						}
					} //: HSTACK LABELS

					Picker(selection: $animationVersion, label: Text("Animation version")) {
						Text("gradient {v1}").tag(AnimationVersion.gradient)
						Text("blur {v2}").tag(AnimationVersion.blur)
					}.pickerStyle(SegmentedPickerStyle())

					GroupBox(label: Text("Animation Duration → \(animationDuration, specifier: "%.2f")")) {
						Slider(value: $animationDuration, in: 0 ... 10)
					}
					
					GroupBox(label: Text("Animation Proportions")) {
						AxPConfigView(title: "background", value: $bgAxP)
						AxPConfigView(title: "head", value: $headAxP)
						AxPConfigView(title: "chest", value: $chestAxP)
						AxPConfigView(title: "hair", value: $hairAxP)
						AxPConfigView(title: "shadows", value: $shadowAxP)
					}
				} //: LEFT
				.padding(.horizontal, 16.0)

				GeometryReader { geometry in
					ZStack {
						/* TRANSITION:
						 if bgVisible {
						 	Background()
						 		.transition(.scale)
						 }
						 */

						/* ASYMMETRIC TRANSITION
						 // It's problematic -  not using this because then I can't override it
						 .asymmetric(
						 	insertion: .scale,
						 	removal: AnyTransition
						 		.scale
						 		.animation(Animation.spring().delay(fractionalDuration))
						 )
						 */

						Background(show: bgVisible)

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
//					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.drawingGroup()
				} //: RIGHT
//				.aspectRatio(1, contentMode: .fit)
				.frame(width: 640, height: 640)
				.padding(55)
				.background(Color.black)
				.padding(10)
			}
		}
	}

	func proportionallyDelayedAx(
		_ proportion: AxP
	) -> Animation {
		// start: proportion of 0.0 - 1.0 so 0.1 would start 10% of the way into the animation
		// end: proportion of 0.0 - 1.0 so 1.0 would end at the end of the whole animation

		if isReversing {
			return Animation
				.easeIn(duration: (proportion.end - proportion.start) * animationDuration)
				.asymmetricDelay(
					initial: proportion.start * animationDuration,
					reversal: (1.0 - proportion.end) * animationDuration,
					isReversing: isReversing
				)
		} else {
			return Animation
				.easeOut(duration: (proportion.end - proportion.start) * animationDuration)
				.asymmetricDelay(
					initial: proportion.start * animationDuration,
					reversal: (1.0 - proportion.end) * animationDuration,
					isReversing: isReversing
				)
		}
		
//		return Animation
//			.easeOut(duration: (proportion.end - proportion.start) * animationDuration)
//			.asymmetricDelay(
//				initial: proportion.start * animationDuration,
//				reversal: (1.0 - proportion.end) * animationDuration,
//				isReversing: isReversing
//			)
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
		} //: HSTACK
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

extension Animation {
	func asymmetricDelay(
		initial: Double,
		reversal: Double,
		isReversing: Bool
	) -> Animation {
		delay(isReversing ? reversal : initial)
	}
}

struct AxPConfigView: View {
	let title: String
	@Binding var value: AxP
	
	var body: some View {
		HStack(alignment: .firstTextBaseline) {
			Text(title)
				.font(.caption)
			Spacer()
			Stepper(value: $value.start, in: 0...value.end, step: 0.05, label: {
				Text("start → \(value.start, specifier: "%.2f")")
			})
			Stepper(value: $value.end, in: value.start...1, step: 0.05, label: {
				Text("end → \(value.end, specifier: "%.2f")")
			})
			Text("= \(value.end - value.start, specifier: "%.2f")")
		}
	}
}

// Conditional View Modifier
//extension View {
//  @ViewBuilder
//  func `if`<Transform: View>(
//	 _ condition: Bool,
//	 transform: (Self) -> Transform
//  ) -> some View {
//	 if condition {
//		transform(self)
//	 } else {
//		self
//	 }
//  }
//}
//
//extension Animation {
//	func `if`(
//	  _ condition: Bool,
//	  animation: Animation
//	) -> Animation {
//	  if condition {
//		 return animation
//	  } else {
//		 return self
//	  }
//	}
//}

// MARK: - BACKGROUND

struct Background: View {
	let show: Bool

	var body: some View {
		PolygonShape(sides: 6)
//			.frame(
//				maxWidth: visible ? .infinity : 0,
//				maxHeight: visible ? .infinity : 0,
//				alignment: .center
//			)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.foregroundColor(Color("grey.500"))
			.scaleEffect(show ? 1 : 0)
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
			} //: SHIRT

			Group {
				Color("grey.200")
				switch version {
				case AnimationVersion.gradient:
					bodyShadow1
				case AnimationVersion.blur:
					ShadowAnimatedBlur(blend: .darken, show: showShadow)
				}
			} //: BODY
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
		} //: ZSTACK
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
		} //: ZSTACK
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
