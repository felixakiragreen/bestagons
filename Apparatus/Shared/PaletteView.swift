//
//  PaletteView.swift
//  Apparatus
//
//  Created by Felix Akira Green on 12/18/20.
//

import SwiftUI

struct PaletteView: View {
	@State var singlePrimary: ColorPrimary = .grey
	@State var severalPrimary: [ColorPrimary] = ColorPrimary.data
	@State var singleLuminance: ColorLuminance = .nearWhite
	@State var severalLuminance: [ColorLuminance] = ColorLuminance.data
	
	@State var singleColor = ColorPreset(primary: .green, luminance: .normal)
//	@State var multipleColor: [ColorPreset] = getColorPalette(primaries: ColorPrimary.data, luminance: ColorLuminance.data)
	@State var multipleColor: ColorPresetPalette = ColorPresetPalette(primaries: ColorPrimary.data, luminance: ColorLuminance.data)
	
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
			ColorPresetSelectSeveral(selection: $multipleColor)
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

struct ColorPresetSelectSeveral: View {
	@Binding var selection: ColorPresetPalette
	
//	var severalPrimary: Binding<[ColorPrimary]> {
//		Binding<[ColorPrimary]>(
//			get: {
//				ColorPrimary.allCases.filter { eachPrimary in
//					self.selection.contains { eachColor in
//						return eachColor.primary == eachPrimary
//					}
//				}
//			},
//			set: { primaries in
//				primaries.forEach { eachPrimary in
//					ColorLuminance.allCases.forEach { eachLuminance in
//						self.selection.append(ColorPreset(primary: eachPrimary, luminance: eachLuminance))
//					}
//				}
//
////				if self.array.contains(value) {
////					self.array = self.array.filter { $0 != value }
////				} else {
////					self.array.append(value)
////				}
//			}
//		)
//	}
	
	var body: some View {
		VStack {
			VStack {
				ForEach(selection.primaries) { primary in
					HStack {
						ForEach(selection.luminance) { luminance in
							ColorBox(color: ColorPreset(primary: primary, luminance: luminance))
						}
					}
				}
			}
			
			HStack(alignment: .top) {
				PrimarySelectSeveral(selection: $selection.primaries)
					.frame(minWidth: 100)
					.padding()
				LuminanceSelectSeveral(selection: $selection.luminance)
					.frame(minWidth: 100)
					.padding()
//				PrimarySelectSingle(selection: $selection.primary)
//					.frame(minWidth: 100)
//					.padding()
//				LuminanceSelectSingle(selection: $selection.luminance, primary: selection.primary)
//					.frame(minWidth: 100)
//					.padding()
			}
		}
	}
}

struct LabelColorBox<Content: View>: View {
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
			ColorBox(color: color)
		}
	}
}

struct ColorBox: View {
	var color: ColorPreset
	
	var body: some View {
		RoundedRectangle(cornerRadius: 4, style: .continuous)
			.frame(width: 12, height: 12)
			.foregroundColor(color.getColor())
	}
}

struct PrimarySelectSingle: View {
	@Binding var selection: ColorPrimary
	
	var body: some View {
		Picker("Primary Colors", selection: $selection) {
			ForEach(ColorPrimary.allCases, id: \.self) { color in
				HStack {
					LabelColorBox(primary: color) {
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
						AnyView(LabelColorBox(primary: color) {
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
					LabelColorBox(luminance: color, primary: primary) {
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
						AnyView(LabelColorBox(luminance: color, primary: primary) {
							Text("\(color.rawValue)")
						})
					}
				}.tag(color)
			}
		}
	}
}
