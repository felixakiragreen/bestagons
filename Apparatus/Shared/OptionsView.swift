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
	
	@State private var showPopover: Bool = true

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
						if !config.simple {
							Slideridoo(
								value: $config.roundness,
								range: 0...1,
								label: "round-y"
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
						}
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
					Text("TODO: add stroke color")
//					Button("Show popover") {
//						 self.showPopover = true
//					}
					GroupBox {
						Label {
							Text("color.rawValue")
						} icon: {
							RoundedRectangle(cornerRadius: 4, style: .continuous)
								.frame(width: 10, height: 10)
								.foregroundColor(Color("grey.100"))
						}
					}.onTapGesture {
						self.showPopover.toggle()
					}.popover(
						isPresented: self.$showPopover,
						arrowEdge: .bottom
					) {
						VStack {
							
						}.padding()

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
						Text("\(value, specifier: "%g")")
					}.frame(width: 80, alignment: .leading)
				}
			} else {
				Slider(value: $value, in: range) {
					HStack {
						Text("\(label) →")
							.font(.caption)
							.foregroundColor(Color.secondary)
						Text("\(value, specifier: "%.2f")")
					}.frame(width: 120, alignment: .leading)
				}
			}
			if step != nil {
				Stepper(value: $value, in: 0...99, step: step!, label: {})
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

// MARK: - MODEL

struct ApparatusConfig: Equatable {
	var cellCountX: Double
	var cellCountY: Double

	var hSymmetric: Bool
	var vSymmetric: Bool
	
	// colors

	var colorPalette: [Color]
	var colorMain: Color?
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
		colorPalette: [Color] = bw,
		colorMain: Color? = nil,
//		colors: [Color] = colorPalette(primaries: [], luminance: <#T##[ColorLuminance]#>)
//		colors: [Color] = [
//			Color("red.500"),
//			Color("orange.500"),
//			Color("yellow.500"),
//			Color("green.500"),
//			Color("blue.500"),
//			Color("purple.500"),
//			Color("red.400"),
//			Color("orange.400"),
//			Color("yellow.400"),
//			Color("green.400"),
//			Color("blue.400"),
//			Color("purple.400"),
//			Color("red.400"),
//			Color("orange.600"),
//			Color("yellow.600"),
//			Color("green.600"),
//			Color("blue.600"),
//			Color("purple.600"),
//		],
		
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

	var colorStroke: Color
	var colorGround: Color

	init(
		stroke: Bool = false,
		fill: Bool = true,
		debug: Bool = false,
		preserveSeed: Bool = true,

		sizing: Double = 8,
		padding: Double = 0,
		rounding: Double = 0,
		
		colorStroke: Color = Color("grey.900"),
		colorGround: Color = Color("grey.500")
	) {
		self.showStroke = stroke
		self.showFill = fill
		self.showDebug = debug
		self.preserveSeed = preserveSeed

		self.sizing = sizing
		self.padding = padding
		self.rounding = rounding
		
		self.colorStroke = colorStroke
		self.colorGround = colorGround
	}
}
