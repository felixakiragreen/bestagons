//
//  ApparatusOptions.swift
//  Apparatus
//
//  Created by Felix Akira Green on 12/16/20.
//

import SwiftUI

struct ApparatusOptionsView: View {
	@Binding var options: ApparatusOptions
	
	var onChange: ((ApparatusOptions) -> Void)?

//	func onChanged(perform action: (ApparatusOptions) -> ApparatusOptions) {
//		return action
//	}
	
	var body: some View {
		VStack {
			GroupBox(label: Text("shape")) {
				VStack {
					Slideridoo(
						value: $options.cellSize,
						range: 1...16,
						step: 1,
						label: "size"
					)
					Slideridoo(
						value: $options.cellCountX,
						range: 1...16,
						step: 1,
						label: "width"
					)
					Slideridoo(
						value: $options.cellCountY,
						range: 1...16,
						step: 1,
						label: "height"
					)
					HStack {
						Toggle(isOn: $options.simple) {
							Text("square")
						}
						Spacer()
						Toggle(isOn: $options.hSymmetric) {
							Text("h_symm")
						}
						Spacer()
						Toggle(isOn: $options.vSymmetric) {
							Text("v symm")
						}
					}.padding(.horizontal)
					Slideridoo(
						value: $options.roundness,
						range: 0...1,
//						step: 0.1,
						label: "round-y"
					)
					Slideridoo(
						value: $options.solidness,
						range: 0...1,
						label: "solid-y"
					)
					Slideridoo(
						value: $options.chanceNew,
						range: 0...1,
						label: "compact-y"
					)
					Slideridoo(
						value: $options.chanceExtend,
						range: 0...1,
						label: "expand-y"
					)
					Slideridoo(
						value: $options.chanceVertical,
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
		.onChange(of: options, perform: { opt in
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

struct ApparatusOptions: Equatable {
	var cellSize: Double

	var cellCountX: Double
	var cellCountY: Double

	var chanceNew: Double
	var chanceExtend: Double
	var chanceVertical: Double

	var colors: [Color]

	var colorMode: ColorMode
	var groupSize: Double

	var hSymmetric: Bool
	var vSymmetric: Bool

	var roundness: Double
	var solidness: Double

	var simple: Bool
	var showStroke: Bool
	var showFill: Bool
	var showDebug: Bool
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
		stroke: Bool = false,
		fill: Bool = true,
		debug: Bool = false,
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
		self.showStroke = stroke
		self.showFill = fill
		self.showDebug = debug
		self.seed = seed
	}
}
