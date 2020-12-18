//
//  ApparatusOptions.swift
//  Apparatus
//
//  Created by Felix Akira Green on 12/16/20.
//

import Combine
import SwiftUI

struct ApparatusOptionsView: View {
	@Binding var config: ApparatusConfig
	@Binding var options: ApparatusOptions

	var onChange: ((ApparatusConfig) -> Void)?

	var body: some View {
		VStack {
			GroupBox(label: Text("shape")) {
				VStack {
					Slideridoo(
						value: $config.cellSize,
						range: 1...16,
						step: 1,
						label: "size"
					)
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
					}.padding(.horizontal)
					HStack {
						Text("TODO: add rounding slider")
						Text("TODO: add padding between shapes")
					}.padding(.horizontal)
				}
			} //: GROUPBOX - look

			GroupBox(label: Text("randomness")) {
				VStack {
					HStack {
						IntField(value: $config.seed)
						Toggle(isOn: $options.preserveSeed) {
							Text("preserveSeed")
						}
					}.padding(.horizontal)
				}
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
						
						Text("TODO: add stroke color")
					}.padding(.horizontal)
				}
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

struct ApparatusOptionsView_Previews: PreviewProvider {
	static var previews: some View {
		ApparatusOptionsView(
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

// MARK: - CONFIG

struct ApparatusConfig: Equatable {
	var cellSize: Double

	var cellCountX: Double
	var cellCountY: Double

	var chanceNew: Double
	var chanceExtend: Double
	var chanceVertical: Double

	var colors: [Color]

	var colorMode: ColorMode
	var groupSize: Double
	var roundness: Double
	var solidness: Double

	var hSymmetric: Bool
	var vSymmetric: Bool

	var simple: Bool
	//	var simplex: ...
	//	var rateOfChange: Double
	var seed: Int

	init(
		cellSize: Double = 8,
		width: Double = 8,
		height: Double = 8,
		initiateChance: Double = 0.8,
		extensionChance: Double = 0.8,
		verticalChance: Double = 0.5,
		horizontalSymmetry: Bool = false,
		verticalSymmetry: Bool = false,
		roundness: Double = 0.1,
		solidness: Double = 0.5,
		colors: [Color] = [
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
		],
		colorMode: ColorMode = .random,
		groupSize: Double = 0.8,
		simple: Bool = true,
//		randomSimple: Bool = false,
//		rateOfChange: Double = 0.01
		seed: Int = 0
	) {
		self.cellSize = cellSize
		self.cellCountX = width
		self.cellCountY = height
		self.chanceNew = initiateChance
		self.chanceExtend = extensionChance
		self.chanceVertical = verticalChance
		self.colors = colors
		self.colorMode = colorMode
		self.groupSize = groupSize
		self.hSymmetric = horizontalSymmetry
		self.vSymmetric = verticalSymmetry
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

	init(
		stroke: Bool = true,
		fill: Bool = true,
		debug: Bool = false,
		preserveSeed: Bool = true
	) {
		self.showStroke = stroke
		self.showFill = fill
		self.showDebug = debug
		self.preserveSeed = preserveSeed
	}
}
