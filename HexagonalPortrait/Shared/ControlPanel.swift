//
//  ControlPanel.swift
//  HexagonalPortrait
//
//  Created by Felix Akira Green on 1/27/21.
//

import SwiftUI

// MARK: - PREVIEW

struct ControlPanel_Previews: PreviewProvider {
	static var previews: some View {
		ControlPanel(
			isReversing: .constant(false),
			isLooping: .constant(true),
			animationDuration: .constant(2.0),
			animationPause: .constant(1.0),
			showControlPanel: .constant(true)
		)
	}
}

struct ControlPanel: View {
	// MARK: - PROPS

	@Binding var isReversing: Bool
	@Binding var isLooping: Bool
	@Binding var animationDuration: Double
	@Binding var animationPause: Double
	@Binding var showControlPanel: Bool

//	let stepperUnit = 0.05

	// MARK: - BODY

	var body: some View {
		ZStack {
			VisualEffectBlur(material: .hudWindow)
			VStack(spacing: 16) {
				Text("control panel")
					.font(.system(.title, design: .monospaced))
				HStack {
//					Toggle(isOn: $isReversing) {
//						Text("isReversing")
//					}
					Toggle(isOn: $isLooping) {
						Text("isLooping")
					}
				}
				HStack {
					Text("duration")
					DoubleField(value: $animationDuration)
				}
				HStack {
					Text("pause")
					DoubleField(value: $animationPause)
				}
				Button("done") {
					isReversing.toggle()
					showControlPanel.toggle()
				}
			} //: LEFT
			.padding(.horizontal, 16.0)
		}
		.font(.system(.body, design: .monospaced))
	}
}
