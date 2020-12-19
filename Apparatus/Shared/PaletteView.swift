//
//  PaletteView.swift
//  Apparatus
//
//  Created by Felix Akira Green on 12/18/20.
//

import SwiftUI

struct PaletteView: View {
	@State var singlePrimary: ColorPrimary = .grey
	@State var severalPrimary: [ColorPrimary] = [.grey, .red]
	@State var singleLuminance: ColorLuminance = .nearWhite
	@State var severalLuminance: [ColorLuminance] = [.nearWhite, .extraLight]
	
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
			VStack {
				singleColor.getLabel()
				HStack {
					PrimarySelectSingle(selection: $singleColor.primary)
						.frame(minWidth: 100)
						.padding()
					LuminanceSelectSingle(selection: $singleColor.luminance, primary: singleColor.primary)
						.frame(minWidth: 100)
						.padding()
				}
			}
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

struct LabelShowingColor<Content: View>: View {
	var color: ColorPreset
	var label: () -> Content
	
	init(primary: ColorPrimary, _ content: @escaping () -> Content) {
		self.color = ColorPreset(primary: primary, luminance: .normal)
		self.label = content
	}
	
	var body: some View {
		Label {
			label()
//			Text(color.primary)
		} icon: {
			RoundedRectangle(cornerRadius: 4, style: .continuous)
				.frame(width: 10, height: 10)
//				.foregroundColor(Color("\(color).400"))
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
//					Label {
//						Text(color.rawValue)
////							.foregroundColor(Color("\(color).300"))
//					} icon: {
//						RoundedRectangle(cornerRadius: 4, style: .continuous)
//							.frame(width: 10, height: 10)
//							.foregroundColor(Color("\(color).400"))
//					}
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
				return HStack {
					ToggleIncludeArray<ColorPrimary, Label>(value: color, array: $selection) {
						Label {
							Text(color.rawValue)
			//					.foregroundColor(Color("\(value).300"))
						} icon: {
							RoundedRectangle(cornerRadius: 4, style: .continuous)
								.frame(width: 10, height: 10)
								.foregroundColor(Color("\(color).400"))
						}
					}
					
				}.tag(color)
			}
		}
	}
}

struct ToggleIncludeArray<Element, Content>: View where Element: Equatable, Content: View {
	var value: Element
	@Binding var array: Array<Element>
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
					Label {
						Text("\(color.rawValue)")
					} icon: {
						RoundedRectangle(cornerRadius: 4, style: .continuous)
							.frame(width: 10, height: 10)
							.foregroundColor(Color("\(primary ?? .grey).\(color.rawValue)"))
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
				return HStack {
					ToggleIncludeArray<ColorLuminance, Label>(value: color, array: $selection) {
						Label {
							Text("\(color.rawValue)")
						} icon: {
							RoundedRectangle(cornerRadius: 4, style: .continuous)
								.frame(width: 10, height: 10)
								.foregroundColor(Color("\(primary ?? .grey).\(color.rawValue)"))
						}
					}
				}.tag(color)
			}
		}
	}
}

// MARK: - MODEL

struct ColorPreset {
	var primary: ColorPrimary
	var luminance: ColorLuminance
	
	init(primary: ColorPrimary, luminance: ColorLuminance) {
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
		Label {
			Text(getString())
		} icon: {
			RoundedRectangle(cornerRadius: 4, style: .continuous)
				.frame(width: 10, height: 10)
				.foregroundColor(getColor())
		}
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
