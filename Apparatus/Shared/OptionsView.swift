//
//  ApparatusOptions.swift
//  Apparatus
//
//  Created by Felix Akira Green on 12/16/20.
//

import Combine
import SwiftUI

struct OptionsView: View {
	// MARK: - PROPS
	@Binding var config: ApparatusConfig
	@Binding var options: ApparatusOptions

	var onChange: ((ApparatusConfig) -> Void)?
	
	@State private var popovers = Popovers()
	private struct Popovers {
		var stroke: Bool = false
		var ground: Bool = false
		var main: Bool = false
		var palette: Bool = false
	}

	// MARK: - BODY
	var body: some View {
		VStack {
			GroupBox(label: Text("shape")) {
				VStack {
					Slideridoo(
						value: $config.cellCountX,
						range: 1...16,
						step: 1,
						label: "width"
					)
					Slideridoo(
						value: $config.cellCountY,
						range: 1...16,
						step: 1,
						label: "height"
					)
					HStack {
						Toggle(isOn: $config.hSymmetric) {
							Text("horizontal symmetry")
						}
						Toggle(isOn: $config.vSymmetric) {
							Text("vertical symmetry")
						}
					}.padding(.horizontal)
					Slideridoo(
						value: $config.chanceExtend,
						range: 0...1,
						label: "clump"
					)
					Slideridoo(
						value: $config.chanceVertical,
						range: 0...1,
						label: "verticality"
					)
					HStack {
						Toggle(isOn: $config.simple) {
							Text("keep it simple (square)")
						}
					}.padding(.horizontal)
					Group {
//						if !config.simple {
							Slideridoo(
								value: $config.roundness,
								range: 0...1,
								label: "roundness"
							)
							Slideridoo(
								value: $config.solidness,
								range: 0...1,
								label: "solidness"
							)
							Slideridoo(
								value: $config.chanceNew,
								range: 0...1,
								label: "compact"
							)
//						}
					}.animation(.default)
				}
			} //: GROUPBOX - shape

			GroupBox(label: Text("look")) {
				VStack {
					HStack {
						Toggle(isOn: $options.showStroke) {
							Text("stroke")
						}
						Spacer()
						Toggle(isOn: $options.showFill) {
							Text("fill")
						}
						Spacer()
						Toggle(isOn: $options.showDebug) {
							Text("id")
						}
					}.padding()
					Slideridoo(
						value: $options.sizing,
						range: 1...16,
						step: 1,
						label: "sizing"
					)
					Slideridoo(
						value: $options.padding,
						range: 0...16,
						step: 1,
						label: "padding"
					)
					Slideridoo(
						value: $options.rounding,
						range: 0...16,
						step: 1,
						label: "rounding"
					)
					Slideridoo(
						value: $options.stroking,
						range: 0...16,
						step: 1,
						label: "stroking"
					)
					HStack {
					}
				}
			} //: GROUPBOX - look

			GroupBox(label: Text("randomness")) {
				VStack {
					HStack {
						IntField(value: $config.seed)
						Toggle(isOn: $options.preserveSeed) {
							Text("preserveSeed")
						}
					}
					HStack {
						//
					}
				}.padding()
			} //: GROUPBOX - randomness
			
			GroupBox(label: Text("coloring")) {
				VStack {
					HStack {
						Picker(selection: $config.colorMode, label: Text("mode")) {
							Text("main").tag(ColorMode.main)
							Text("single").tag(ColorMode.single)
							Text("group").tag(ColorMode.group)
							Text("random").tag(ColorMode.random)
						}.pickerStyle(SegmentedPickerStyle())
						
					}
					//.padding(.horizontal)

					VStack {
						ColorSelectPopover(show: self.$popovers.stroke) {
							HStack {
								Text("stroke →")
								options.colorStroke.getLabel()
							}.frame(minWidth: 160)
						} content: {
							ColorPresetSelectSingle(selection: $options.colorStroke)
						}
						ColorSelectPopover(show: self.$popovers.ground) {
							HStack {
								Text("ground →")
								options.colorGround.getLabel()
							}.frame(minWidth: 160)
						} content: {
							ColorPresetSelectSingle(selection: $options.colorGround)
						}
//						ColorSelectPopover(show: self.$popovers.main) {
//							HStack {
//								Text("main →")
//								if let colorMain = config.colorMain {
//									colorMain.getLabel()
//								} else {
//									Text("unset")
//								}
//							}.frame(minWidth: 160)
//						} content: {
//							ColorPresetSelectSingle(selection: $config.colorMain)
//						}
					}
					
					HStack {
						GroupBox {
							
							ColorSelectPopover(show: self.$popovers.palette) {
								VStack {
									Text("Color Palette")
									VStack {
										ForEach(config.colorPalette.primaries) { primary in
											HStack {
												ForEach(config.colorPalette.luminance) { luminance in
													ColorBox(color: ColorPreset(primary: primary, luminance: luminance))
												}
											}
										}
									}
								}
							} content: {
								HStack {
//									LuminanceSelectSeveral(selection: $severalLuminance)
//										.frame(minWidth: 100)
//										.padding()
//									PrimarySelectSeveral(selection: $severalPrimary)
//											.frame(minWidth: 100)
//										 .padding()
									ColorPresetSelectSeveral(selection: $config.colorPalette)
								}
							}
							
						}
					}
					/*
					
					colorMain
					colorStroke
					colorGround
					
					colorPalette
					
					*/
				}.padding()
			} //: GROUPBOX - coloring
			
			Spacer()
		} //: VSTACK
//		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.onChange(of: config, perform: { opt in
//			print(opt)
			if let update = self.onChange {
				update(opt)
			}
		})
	}
}

// MARK: - PREVIEW
struct OptionsView_Previews: PreviewProvider {
	static var previews: some View {
		OptionsView(
			config: .constant(ApparatusConfig()),
			options: .constant(ApparatusOptions())
		)
		.frame(height: 900)
	}
}

// MARK: - SUBVIEWS

struct Slideridoo: View {
	@Binding var value: Double
	var range: ClosedRange<Double> = 1...16
	var step: Double?
	var label: String

	var body: some View {
		HStack {
			if step != nil {
				Slider(value: $value, in: range, step: step!) {
					HStack {
						Text("\(label) →")
							.font(.caption)
							.foregroundColor(Color.secondary)
						// Text("\(value, specifier: "%g")")
					}.frame(width: 64, alignment: .leading)
				}
			} else {
				Slider(value: $value, in: range) {
					HStack {
						Text("\(label) →")
							.font(.caption)
							.foregroundColor(Color.secondary)
						Text("\(value, specifier: "%.2f")")
					}.frame(width: 100, alignment: .leading)
				}
			}
			if step != nil {
				DoubleField(value: $value)
					.frame(width: 60)
				// Stepper(value: $value, in: 0...99, step: step!, label: {})
			}
		}
		.padding(.horizontal)
	}
}

struct IntField: View {
	@Binding var value: Int

	var valueProxy: Binding<String> {
		Binding<String>(
			get: { self.toString(from: self.value) },
			set: {
				if let num = NumberFormatter().number(from: $0) {
					self.value = num.intValue
				}
			}
		)
	}

	var body: some View {
		TextField("", text: valueProxy)
	}

	private func toString(from value: Int) -> String {
		guard let s = NumberFormatter().string(from: NSNumber(value: value)) else {
			return ""
		}
		return s
	}
}

struct DoubleField: View {
	@Binding var value: Double

	var valueProxy: Binding<String> {
		Binding<String>(
			get: { self.toString(from: self.value) },
			set: {
				if let num = NumberFormatter().number(from: $0) {
					self.value = num.doubleValue
				}
			}
		)
	}

	var body: some View {
		TextField("", text: valueProxy)
	}

	private func toString(from value: Double) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .none
		guard let s = formatter.string(from: NSNumber(value: value)) else {
			return ""
		}
		return s
	}
}

struct ColorSelectPopover<ContentLabel, Content>: View where ContentLabel: View, Content: View {
	@Binding var show: Bool

	var label: () -> ContentLabel
	var content: () -> Content
	
	var body: some View {
		GroupBox {
			label()
		}
		.onTapGesture {
			show.toggle()
		}.popover(
			isPresented: self.$show,
			arrowEdge: .bottom
		) {
			VStack {
				content()
			}.padding()
		}
	}
}

// MARK: - MODEL

struct ApparatusConfig: Equatable {
	var cellCountX: Double
	var cellCountY: Double

	var hSymmetric: Bool
	var vSymmetric: Bool
	
	// colors

	var colorPalette: ColorPresetPalette
	var colorMain: ColorPreset?
	var colorMode: ColorMode
	
	var groupSize: Double
	
	// non-square
	
	var simple: Bool
	
	var chanceNew: Double
	var chanceExtend: Double
	var chanceVertical: Double

	var roundness: Double
	var solidness: Double

	
	// randomness
	
	//	var simplex: ...
	//	var rateOfChange: Double
	var seed: Int
	
	
	
	// var seedShape =
	// var seedColor =

	init(
		width: Double = 8,
		height: Double = 8,
		initiateChance: Double = 0.8,
		extensionChance: Double = 0.8,
		verticalChance: Double = 0.5,
		horizontalSymmetry: Bool = false,
		verticalSymmetry: Bool = false,
		roundness: Double = 0.1,
		solidness: Double = 0.5,
//		colorPalette: [Color] = bw,
//		colorPalette: [Color] = assortment,
//		colorPalette: [ColorPreset] = getColorPalette(primaries: [.green, .blue, .purple], luminance: [
//			.nearWhite,
//			.extraLight,
//			.light,
//			.normal,
//			.medium,
//			.semiDark,
//			.dark,
//			.extraDark,
//			.nearBlack
//		]),
		colorPalette: ColorPresetPalette = ColorPresetPalette(primaries: [.green, .blue, .purple], luminance: [
			.nearWhite,
			.extraLight,
			.light,
			.normal,
			.medium,
			.semiDark,
			.dark,
			.extraDark,
			.nearBlack
		]),
		colorMain: ColorPreset? = nil,
		
		colorMode: ColorMode = .random,
		groupSize: Double = 0.8,
		simple: Bool = true,
//		randomSimple: Bool = false,
//		rateOfChange: Double = 0.01
		seed: Int = 0
	) {
		self.cellCountX = width
		self.cellCountY = height
		
		self.hSymmetric = horizontalSymmetry
		self.vSymmetric = verticalSymmetry
		
		self.chanceNew = initiateChance
		self.chanceExtend = extensionChance
		self.chanceVertical = verticalChance
		
		self.colorPalette = colorPalette
		self.colorMode = colorMode
		self.colorMain = colorMain
		self.groupSize = groupSize
		
		self.roundness = roundness
		self.solidness = solidness
		self.simple = simple
		self.seed = seed
	}
}

struct ApparatusOptions: Equatable {
	var showStroke: Bool
	var showFill: Bool
	var showDebug: Bool
	var preserveSeed: Bool
	
	var sizing: Double
	var padding: Double
	var rounding: Double
	var stroking: Double

	var colorStroke: ColorPreset
	var colorGround: ColorPreset

	init(
		stroke: Bool = true,
		fill: Bool = true,
		debug: Bool = false,
		preserveSeed: Bool = true,

		sizing: Double = 8,
		padding: Double = 0,
		rounding: Double = 0,
		stroking: Double = 1,
		
		colorStroke: ColorPreset = ColorPreset("grey.900"),
		colorGround: ColorPreset = ColorPreset("grey.500")
	) {
		self.showStroke = stroke
		self.showFill = fill
		self.showDebug = debug
		self.preserveSeed = preserveSeed

		self.sizing = sizing
		self.padding = padding
		self.rounding = rounding
		self.stroking = stroking
		
		self.colorStroke = colorStroke
		self.colorGround = colorGround
	}
}
