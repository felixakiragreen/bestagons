//
//  PaletteView.swift
//  Apparatus
//
//  Created by Felix Akira Green on 12/18/20.
//

import SwiftUI

struct PaletteView: View {
	@State var singlePrimary: ColorPrimary = .grey
	@State var severalPrimary: [ColorPrimary] = [.red, .orange, .yellow, .green, .blue, .purple]
	@State var singleLuminance: ColorLuminance = .nearWhite
	@State var severalLuminance: [ColorLuminance] = [.normal, .medium, .semiDark]
	
	@State var singleColor = ColorPreset(primary: .green, luminance: .normal)
	
	var body: some View {
		VStack {
			HStack {
				PrimarySelectSingle(selection: $singlePrimary)
					.frame(minWidth: 100)
					.padding()
				PrimarySelectSeveral(selection: $severalPrimary)
					.frame(minWidth: 100)
					.padding()
			}
			HStack {
				LuminanceSelectSingle(selection: $singleLuminance)
					.frame(minWidth: 100)
					.padding()
				LuminanceSelectSeveral(selection: $severalLuminance)
					.frame(minWidth: 100)
					.padding()
			}
			ColorPresetSelectSingle(selection: $singleColor)
		}
	}
}

// MARK: - PREVIEW

struct PaletteView_Previews: PreviewProvider {
	static var previews: some View {
		PaletteView()
	}
}

// MARK: - SUBVIEWS

struct ColorPresetSelectSingle: View {
	@Binding var selection: ColorPreset
	
	var body: some View {
		VStack {
			RoundedRectangle(cornerRadius: 25.0, style: .continuous)
				.frame(height: 20)
				.frame(maxWidth: .infinity)
				.foregroundColor(selection.getColor())
			
			HStack(alignment: .top) {
				PrimarySelectSingle(selection: $selection.primary)
					.frame(minWidth: 100)
					.padding()
				LuminanceSelectSingle(selection: $selection.luminance, primary: selection.primary)
					.frame(minWidth: 100)
					.padding()
			}
		}
	}
}

struct LabelShowingColor<Content: View>: View {
	var color: ColorPreset
	var label: () -> Content
	
	init(primary: ColorPrimary, _ content: @escaping () -> Content) {
		self.color = ColorPreset(primary: primary, luminance: .normal)
		self.label = content
	}
	
	init(luminance: ColorLuminance, primary: ColorPrimary?, _ content: @escaping () -> Content) {
		self.color = ColorPreset(primary: primary ?? .grey, luminance: luminance)
		self.label = content
	}
	
	init(color: ColorPreset, _ content: @escaping () -> Content) {
		self.color = color
		self.label = content
	}
	
	var body: some View {
		Label {
			label()
		} icon: {
			RoundedRectangle(cornerRadius: 4, style: .continuous)
				.frame(width: 12, height: 12)
				.foregroundColor(color.getColor())
		}
	}
}

struct PrimarySelectSingle: View {
	@Binding var selection: ColorPrimary
	
	var body: some View {
		Picker("Primary Colors", selection: $selection) {
			ForEach(ColorPrimary.allCases, id: \.self) { color in
				HStack {
					LabelShowingColor(primary: color) {
						Text(color.rawValue)
					}
				}.tag(color)
			}
		}
		.pickerStyle(RadioGroupPickerStyle())
		.labelsHidden()
	}
}

struct PrimarySelectSeveral: View {
	@Binding var selection: [ColorPrimary]
	
	var body: some View {
		VStack(alignment: .leading) {
			ForEach(ColorPrimary.allCases, id: \.self) { color in
				HStack {
					ToggleIncludeArray<ColorPrimary, AnyView>(value: color, array: $selection) {
						AnyView(LabelShowingColor(primary: color) {
							Text(color.rawValue)
						})
					}
					
				}.tag(color)
			}
		}
	}
}

struct ToggleIncludeArray<Element, Content>: View where Element: Equatable, Content: View {
	var value: Element
	@Binding var array: [Element]
	var label: () -> Content
	
	var isOnProxy: Binding<Bool> {
		Binding<Bool>(
			get: { self.array.contains(value) },
			set: { _ in
				if self.array.contains(value) {
					self.array = self.array.filter { $0 != value }
				} else {
					self.array.append(value)
				}
			}
		)
	}
	
	var body: some View {
		Toggle(isOn: isOnProxy) {
			label()
		}
	}
}

struct LuminanceSelectSingle: View {
	@Binding var selection: ColorLuminance
	var primary: ColorPrimary?
	
	var body: some View {
		Picker("Color Luminance", selection: $selection) {
			ForEach(ColorLuminance.allCases, id: \.self) { color in
				HStack {
					LabelShowingColor(luminance: color, primary: primary) {
						Text("\(color.rawValue)")
					}
				}.tag(color)
			}
		}
		.pickerStyle(RadioGroupPickerStyle())
		.labelsHidden()
	}
}

struct LuminanceSelectSeveral: View {
	@Binding var selection: [ColorLuminance]
	var primary: ColorPrimary?
	
	var body: some View {
		VStack(alignment: .leading) {
			ForEach(ColorLuminance.allCases, id: \.self) { color in
				HStack {
					ToggleIncludeArray<ColorLuminance, AnyView>(value: color, array: $selection) {
						AnyView(LabelShowingColor(luminance: color, primary: primary) {
							Text("\(color.rawValue)")
						})
					}
				}.tag(color)
			}
		}
	}
}

// MARK: - MODEL

struct ColorPreset: Equatable {
	var primary: ColorPrimary
	var luminance: ColorLuminance
	
	init(primary: ColorPrimary, luminance: ColorLuminance) {
		self.primary = primary
		self.luminance = luminance
	}
	
	init?(_ from: String) {
		guard let (primary, luminance) = ColorPreset.stringToColorComponents(from) else {
			return nil
		}
		
		self.primary = primary
		self.luminance = luminance
	}
	
	// TODO: add init for just string
	
	func getString() -> String {
		return "\(primary).\(luminance.rawValue)"
	}
	
	func getColor() -> Color {
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
		LabelShowingColor(color: self) {
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
}

enum ColorPrimary: String, CaseIterable {
	case grey, red, orange, yellow, green, blue, purple
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

// MARK: - HELPERS

func getColorPalette(
	primaries: [ColorPrimary],
	luminance: [ColorLuminance]
) -> [Color] {
	var colors = [Color]()
	for p in primaries {
		for l in luminance {
			colors.append(Color("\(p).\(l)"))
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
