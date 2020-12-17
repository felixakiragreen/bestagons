//
//  ApparatusOptions.swift
//  Apparatus
//
//  Created by Felix Akira Green on 12/16/20.
//

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
						Toggle(isOn: $config.simple) {
							Text("square")
						}
						Spacer()
						Toggle(isOn: $config.hSymmetric) {
							Text("h_symm")
						}
						Spacer()
						Toggle(isOn: $config.vSymmetric) {
							Text("v symm")
						}
					}.padding(.horizontal)
					Slideridoo(
						value: $config.roundness,
						range: 0...1,
//						step: 0.1,
						label: "round-y"
					)
					Slideridoo(
						value: $config.solidness,
						range: 0...1,
						label: "solid-y"
					)
					Slideridoo(
						value: $config.chanceNew,
						range: 0...1,
						label: "compact-y"
					)
					Slideridoo(
						value: $config.chanceExtend,
						range: 0...1,
						label: "expand-y"
					)
					Slideridoo(
						value: $config.chanceVertical,
						range: 0...1,
						label: "vertical-y"
					)
				}
			}//: GROUPBOX - shape
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
				}
			}//: GROUPBOX - look
			
			GroupBox(label: Text("randomness")) {
				VStack {
					HStack {
						Text("TODO")
//						SEED
						//			TODO: TOGGLE preverse Seed on regenerate
					}.padding(.horizontal)
				}
			}//: GROUPBOX - randomness
		}
		.onChange(of: config, perform: { opt in
			print(opt)
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
					Text("\(label)\n\(value, specifier: "%g")")
						.frame(width: 60, alignment: .leading)
				}
			} else {
				Slider(value: $value, in: range) {
					Text("\(label)\n\(value, specifier: "%.2f")")
						.frame(width: 80, alignment: .leading)
				}
			}
			
//			Stepper(value: $value, in: 0...99, step: 1, label: {})
		}
		.padding(.horizontal)
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
		verticalChance: Double = 0.8,
		horizontalSymmetry: Bool = true,
		verticalSymmetry: Bool = false,
		roundness: Double = 0.1,
		solidness: Double = 0.5,
		colors: [Color] = [
			Color.blue,
			Color.purple,
			Color.green,
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

	init(
		stroke: Bool = true,
		fill: Bool = true,
		debug: Bool = false
	) {
		self.showStroke = stroke
		self.showFill = fill
		self.showDebug = debug
	}
}

