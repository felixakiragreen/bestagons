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
						label: "size"
					)
					Slideridoo(
						value: $options.cellCountX,
						label: "width"
					)
					Slideridoo(
						value: $options.cellCountY,
						label: "height"
					)
//				.onChange(of: optWidth, perform: { value in
//					self.regenerate()
//				})
//				Slider(value: $optHeight, in: 1 ... 16, step: 1) {
//					Text("height: \(optHeight, specifier: "%.0f")")
//						.frame(width: 60, alignment: .leading)
//				}
//				.padding(.horizontal)
//				.onChange(of: optHeight, perform: { value in
//					self.regenerate()
//				})
				}
			}
		}
		.onChange(of: options, perform: { opt in
//			self.regenerate()
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
	var label: String

	var body: some View {
		HStack {
			Slider(value: $value, in: range, step: 1) {
				Text("\(label): \(value, specifier: "%g")")
					.frame(width: 80, alignment: .leading)
			}
//			NumberPi
			Stepper(value: $value, in: 0...99, step: 1, label: {
//				Text("\(label) → \(value, specifier: "%g")")
			})
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
	//	var simplex: ...
	//	var rateOfChange: Double

	var seed: Int

	init(
		cellSize: Double = 10,
		width: Double = 14,
		height: Double = 14,
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
