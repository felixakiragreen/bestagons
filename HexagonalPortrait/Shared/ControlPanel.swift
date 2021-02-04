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
			isAnimating: .constant(true),
			isLooping: .constant(true),
			showControlPanel: .constant(true)
		)
	}
}

struct ControlPanel: View {
	// MARK: - PROPS

	@Binding var isAnimating: Bool
	@Binding var isLooping: Bool
	@Binding var showControlPanel: Bool
	
	@AppStorage("duration") var animationDuration: Double = 5.0
	@AppStorage("pause") var animationPause: Double = 2.0

	// MARK: - BODY

	var body: some View {
		ZStack {
			VisualEffectBlur(material: .hudWindow)
			VStack(spacing: 16) {
				Text("control panel")
					.font(.system(.title, design: .monospaced))
				HStack {
					Toggle(isOn: $isAnimating) {
						Text("isAnimating")
					}
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
					showControlPanel.toggle()
				}
			} //: LEFT
			.padding(.horizontal, 16.0)
		}
		.font(.system(.body, design: .monospaced))
	}
}
