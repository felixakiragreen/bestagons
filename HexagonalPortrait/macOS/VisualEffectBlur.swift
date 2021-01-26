//
//  VisualEffectBlur.swift
//  HexagonalPortrait (macOS)
//
//  Created by Felix Akira Green on 1/26/21.
//

import SwiftUI

/**
TODO:
- [ ] add state
- [ ] add blendMode
https://developer.apple.com/documentation/appkit/nsvisualeffectview
*/

// MARK: - VisualEffectBlur

struct VisualEffectBlur: View {
	var material: NSVisualEffectView.Material
	// state
	// blendMode
	
	init(material: NSVisualEffectView.Material = .headerView) {
		self.material = material
	}
	
	var body: some View {
		Representable(material: material)
			.accessibility(hidden: true)
	}
}

// MARK: - Representable

extension VisualEffectBlur {
	struct Representable: NSViewRepresentable {
		var material: NSVisualEffectView.Material
		
		func makeNSView(context: Context) -> NSVisualEffectView {
			context.coordinator.visualEffectView
		}
		
		func updateNSView(_ view: NSVisualEffectView, context: Context) {
			context.coordinator.update(material: material)
		}
		
		func makeCoordinator() -> Coordinator {
			Coordinator()
		}
	}
	
	class Coordinator {
		let visualEffectView = NSVisualEffectView()
		
		init() {
			visualEffectView.blendingMode = .withinWindow
			visualEffectView.state = .active
		}
		
		func update(material: NSVisualEffectView.Material) {
			visualEffectView.material = material
		}
	}
}

// MARK: - Previews

struct VisualEffectView_Previews: PreviewProvider {
	static var previews: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
			
			VStack {
				VisualEffectBlur(material: .contentBackground)
					.frame(height: 40)
				//					.padding()
				VisualEffectBlur(material: .fullScreenUI)
					.frame(height: 40)
				//					.padding()
				VisualEffectBlur(material: .titlebar)
					.frame(height: 40)
				
				VisualEffectBlur(material: .headerView)
					.frame(height: 40)
				
				VisualEffectBlur(material: .windowBackground)
					.frame(height: 40)
				
				VisualEffectBlur(material: .sidebar)
					.frame(height: 40)
			}
			.padding()
			
			Text("Hello World!")
		}
		//		  .frame(width: 200, height: 100)
		.previewLayout(.sizeThatFits)
	}
}
