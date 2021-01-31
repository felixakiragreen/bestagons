//
//  PortraitView.swift
//  HexagonalPortrait
//
//  Created by Felix Akira Green on 1/25/21.
//

import SwiftUI
import Combine

// MARK: - PREVIEW

struct PortraitView_Previews: PreviewProvider {
	static var previews: some View {
		PortraitView(
			initiallyVisible: true,
			isReversing: .constant(true),
			isLooping: .constant(true),
			animationDuration: 2.0,
			animationPause: 1.0
		)
	}
}

// Animation Transition Proportion - abbreviating because I'm tired of long names
struct AxP {
	var start: Double // 0.0 - 1.0 ... 0.1 would start 10% of the way into the animation
	var end: Double // 0.0 - 1.0 ... 1.0 would end at the end of the whole animation
}

/**


TODO:
- [ ] performance isn't great
- [ ] doubleTap to flip for controls (duration, looping)

DONE:
- [x] isReversing not working
- [x] make window transparent
https://github.com/lukakerr/NSWindowStyles
https://github.com/martinlexow/SwiftUIWindowStyles

*/

struct PortraitView: View {
	// MARK: - PROPS
	
	var initiallyVisible = false
	var initiallyAnimating = true
	
	// MARK: - STATE
	
	@Binding var isReversing: Bool
	@Binding var isLooping: Bool
	var animationDuration: Double
	var animationPause: Double
	
//	@State var timer: Timer.TimerPublisher = Timer.publish(every: 5, on: .main, in: .common)
//	@State var timer: Publishers.Autoconnect<Timer.TimerPublisher>
	
	@State var bgVisible = false
	@State var bgAxP = AxP(start: 0.0, end: 0.35)
	
	@State var headVisible = false
	@State var headAxP = AxP(start: 0.15, end: 0.5)
	
	@State var chestVisible = false
	@State var chestAxP = AxP(start: 0.3, end: 0.65)
	
	@State var hairVisible = false
	@State var hairAxP = AxP(start: 0.55, end: 0.9)
	
	@State var shadowVisible = true
//	@State var shadowAxP = AxP(start: 0.6, end: 1.0)
	
	let stepperUnit = 0.05
	
	let materials: [NSVisualEffectView.Material] = [
		.titlebar,
		.selection,
		.menu,
		.popover,
		.sidebar,
		.headerView,
		.sheet,
		.windowBackground,
		.hudWindow, // ooh
		.fullScreenUI,
		.toolTip,
		.contentBackground,
		.underWindowBackground,
		.underPageBackground
	]
	let materialNames: [String] = [
		".titlebar",
		".selection",
		".menu",
		".popover",
		".sidebar",
		".headerView",
		".sheet",
		".windowBackground",
		".hudWindow",
		".fullScreenUI",
		".toolTip",
		".contentBackground",
		".underWindowBackground",
		".underPageBackground"
	]
	
	@State var material: Int = 8
	
	var bgAnimation: Animation { return proportionallyDelayedAx(bgAxP) }
	var headAnimation: Animation { return proportionallyDelayedAx(headAxP) }
	var chestAnimation: Animation { return proportionallyDelayedAx(chestAxP) }
	var hairAnimation: Animation { return proportionallyDelayedAx(hairAxP) }
		

	// MARK: - BODY
	
	var body: some View {
		let timer = Timer.publish(every: animationDuration + animationPause, on: .main, in: .common).autoconnect()
		
		return ZStack {
			if let blurMaterial = materials[optional: material] {
				VisualEffectBlur(material: blurMaterial)
			}
			Color.clear
				.onAppear {
					if initiallyVisible {
						self.bgVisible.toggle()
						self.headVisible.toggle()
						self.chestVisible.toggle()
						self.hairVisible.toggle()
					}
					if initiallyAnimating {
						animate()
					}
				}
				.onReceive(timer) { _ in
					if isLooping {
						animate()
					}
				}
			
				GeometryReader { geometry in
					ZStack {
						
						Background(
							size: geometry.size,
							show: bgVisible
						)
						
						Chest(
							size: geometry.size,
							show: chestVisible,
							showShadow: shadowVisible
						)
						
						Bun(
							size: geometry.size,
							show: hairVisible,
							showShadow: shadowVisible
						)

						Head(
							size: geometry.size,
							show: headVisible,
							showShadow: shadowVisible
						)
						
						Hairline(
							size: geometry.size,
							show: hairVisible,
							showShadow: shadowVisible
						)
					} //: ZSTACK
//					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.drawingGroup()
					.onTapGesture {
//						if material < materials.count {
//							material += 1
//						} else {
//							material = 0
//						}
//						print("bla", materialNames[optional: material])
//						animate()
					}
				} //: RIGHT
				.aspectRatio(1, contentMode: .fit)
//				.frame(width: 640, height: 640)
				.padding(24)
//				.background(Color.black)
//				.padding(10)
		}

	}
	
	// MARK: - FUNCS

	private func animate() -> Void {
		print("ANIMATING")
		isReversing.toggle()
		
		withAnimation(bgAnimation) {
			bgVisible.toggle()
		}
		
		withAnimation(headAnimation) {
			headVisible.toggle()
		}
		
		withAnimation(chestAnimation) {
			chestVisible.toggle()
		}
		
		withAnimation(hairAnimation) {
			hairVisible.toggle()
		}
	}
	
	private func proportionallyDelayedAx(_ proportion: AxP) -> Animation {
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
		}//: HSTACK
//		.blur(radius: show ? 0.0 : 100.0)
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

// MARK: - BACKGROUND

struct Background: View {
	let size: CGSize
	let show: Bool
	
	var body: some View {
		Hexagon(regular: true)
			.scale(show ? 1 : 0)
			.hexagonalFrame(height: size.height)
//			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.foregroundColor(Color("grey.500"))
	}
}

// MARK: - CHEST

struct Chest: View {
	let size: CGSize
	let show: Bool
	let showShadow: Bool
	
	var body: some View {
		ZStack {
			Group {
				Color("grey.900")
				ShadowAnimatedBlur(blend: .lighten, show: showShadow)
			} //: SHIRT
			
			Group {
				Color("grey.200")
				ShadowAnimatedBlur(blend: .darken, show: showShadow)
			} //: BODY
			.mask(
				Hexagon(orientation: .pointy)
					.fractionalFrame(size: size, fraction: 16 / 24)
					.foregroundColor(.black)
			)
		} //: ZStack → SHIRT & BODY
		.mask(
			Hexagon()
				.offset(y: size.height * 15 / 24)
		)
		.mask(
			Hexagon()
				.scale(show ? 1 : 0)
		)
		.offset(y: show ? 0 : -(size.height * 3 / 24))
		.opacity(show ? 1 : 0)
	}
}

// MARK: - BUN

struct Bun: View {
	let size: CGSize
	let show: Bool
	let showShadow: Bool
	
	var body: some View {
		ZStack {
			Color("yellow.800")
			ShadowAnimatedBlur(blend: .darken, show: showShadow)
		} //: ZStack
		.frame(
			maxWidth: show ? size.width * 4 / 24 : 0,
			maxHeight: show ? size.height * 4 / 24 : 0,
			alignment: .center
		)
		.mask(
			Hexagon()
				.hexagonalFrame(height: show ? size.height * 4 / 24 : 0)
				.frame(
					maxWidth: show ? size.width * 4 / 24 : 0,
					maxHeight: show ? size.height * 4 / 24 : 0,
					alignment: .center
				)
		)
		.offset(y: show ? -(size.height * 7 / 24) : -(size.height * 6 / 24))
//		.opacity(show ? 1 : 0)
	}
}

// MARK: - HEAD

struct Head: View {
	let size: CGSize
	let show: Bool
	let showShadow: Bool
	
	var body: some View {
		ZStack {
			Color("grey.100")
			ShadowAnimatedBlur(blend: .darken, show: showShadow)
		} //: FACE
		.fractionalFrame(size: size, fraction: 12 / 24)
		.mask(
			Hexagon(orientation: .pointy)
				.scale(show ? 1 : 0)
				.hexagonalFrame(height: size.height * 12 / 24)
		)
	}
}

// MARK: - HARLINE

struct Hairline: View {
	let size: CGSize
	let show: Bool
	let showShadow: Bool
	
	var body: some View {
		ZStack {
			Color("yellow.700")
			ShadowAnimatedBlur(blend: .darken, show: showShadow)
		} //: ZSTACK
		.fractionalFrame(size: size, fraction: 12 / 24)
		.mask(
			Hexagon(orientation: .pointy)
//				.hexagonalFrame(height: size.height * 3 / 24)
				.scale(show ? 1 : 0)
				.frame(
					width: size.width * 6 / 24,
					height: size.height * 6 / 24
				)
				
		)
		.mask(
			Hexagon(orientation: .pointy)
				.offset(y: -size.height * 6 / 24)
		)
		.offset(y: show ? -(size.height * 3 / 24) : -(size.height * 6 / 24))
		//		.opacity(show ? 1 : 0)
	}
}

