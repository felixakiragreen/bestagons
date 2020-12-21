//
//  ColorModel.swift
//  Apparatus
//
//  Created by Felix Akira Green on 12/19/20.
//

import SwiftUI


// MARK: - MODEL

struct ColorPreset: Equatable, Identifiable {
	var id: String
	var primary: ColorPrimary
	var luminance: ColorLuminance
	var fellback: Bool = false
	
	/// Initialization from components
	init(primary: ColorPrimary, luminance: ColorLuminance) {
		self.id = ColorPreset.toString((primary, luminance))
		self.primary = primary
		self.luminance = luminance
	}
	
	/// Initialization from just a string → ("grey.100")
	init(_ from: String) {
		guard let (primary, luminance) = ColorPreset.stringToColorComponents(from) else {
			self.id = "incorrect"
			self.primary = .red
			self.luminance = .extraLight
			self.fellback = true
			return
		}
		
		self.id = ColorPreset.toString((primary, luminance))
		self.primary = primary
		self.luminance = luminance
	}
	
	/// Empty initialization
	init() {
		self.id = "incorrect"
		self.primary = .red
		self.luminance = .extraLight
		self.fellback = true
	}
	
	func getString() -> String {
		if fellback {
			return "incorrect"
		}
		return ColorPreset.toString((primary, luminance))
	}
	
	func getColor() -> Color {
		if fellback {
			return Color.red
		}
		return Color(getString())
	}
	
	func getLabel() -> some View {
//		Label {
//			Text(getString())
//		} icon: {
//			RoundedRectangle(cornerRadius: 4, style: .continuous)
//				.frame(width: 10, height: 10)
//				.foregroundColor(getColor())
//		}
		LabelColorBox(color: self) {
			Text(getString())
		}
	}
	
	static func splitColorString(_ from: String) -> (String, String) {
		let parts = from.components(separatedBy: ".")
		return (parts[0], parts[1])
	}
	
	static func stringToColorComponents(_ from: String) -> (ColorPrimary, ColorLuminance)? {
		let (p, l) = ColorPreset.splitColorString(from)
		
		guard let primary = ColorPrimary(rawValue: p) else {
			return nil
		}
		guard let intLuminance = Int(l) else {
			return nil
		}
		guard let luminance = ColorLuminance(rawValue: intLuminance) else {
			return nil
		}
		
		return (primary, luminance)
	}

	static func toString(_ components: (ColorPrimary, ColorLuminance)) -> String {
		let (primary, luminance) = components
		return "\(primary).\(luminance.rawValue)"
	}
}

// TODO: add a guard that you can't deselect all of them
struct ColorPresetPalette: Equatable {
	var primaries: [ColorPrimary]
	var luminance: [ColorLuminance]
	
	init(primaries: [ColorPrimary], luminance: [ColorLuminance]) {
		
		self.primaries = primaries
		self.luminance = luminance
	}
	
	
	func getColorPresets() -> [ColorPreset] {
		var colors = [ColorPreset]()
		for p in primaries {
			for l in luminance {
				colors.append(ColorPreset(primary: p, luminance: l))
			}
		}

		return colors
	}
}


/**

TODO: add
ColorPresetPalette struct

that takes primaries, luminance

can return an array of all of them

all you have to do it update

*/

enum ColorPrimary: String, CaseIterable {
	case grey, red, orange, yellow, green, blue, purple
}

extension ColorPrimary: Identifiable {
	 var id: String { rawValue }
}

enum ColorLuminance: Int, CaseIterable {
	case nearWhite = 100
	case extraLight = 200
	case light = 300
	case normal = 400
	case medium = 500
	case semiDark = 600
	case dark = 700
	case extraDark = 800
	case nearBlack = 900
}

extension ColorLuminance: Identifiable {
	 var id: Int { rawValue }
}

extension ColorPrimary {
	static var data: [ColorPrimary] {
		[.red, .orange, .yellow, .green, .blue, .purple]
	}
}

extension ColorLuminance {
	static var data: [ColorLuminance] {
		[.normal, .medium, .semiDark]
	}
}

// MARK: - HELPERS

func getColorPalette(
	primaries: [ColorPrimary],
	luminance: [ColorLuminance]
) -> [ColorPreset] {
	var colors = [ColorPreset]()
	for p in primaries {
		for l in luminance {
			colors.append(ColorPreset(primary: p, luminance: l))
		}
	}

	return colors
}

// MISC

let bw: [Color] = [
	Color("grey.100"),
	Color("grey.200"),
	Color("grey.300"),
	Color("grey.400"),
	Color("grey.500"),
	Color("grey.600"),
	Color("grey.700"),
	Color("grey.800"),
	Color("grey.900"),
]

let assortment: [Color] = [
	Color("red.500"),
	Color("orange.500"),
	Color("yellow.500"),
	Color("green.500"),
	Color("blue.500"),
	Color("purple.500"),
	Color("red.400"),
	Color("orange.400"),
	Color("yellow.400"),
	Color("green.400"),
	Color("blue.400"),
	Color("purple.400"),
	Color("red.400"),
	Color("orange.600"),
	Color("yellow.600"),
	Color("green.600"),
	Color("blue.600"),
	Color("purple.600"),
]
