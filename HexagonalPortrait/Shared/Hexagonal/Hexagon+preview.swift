//
//  Hexagon+preview.swift
//  FutureUI
//
//  Created by Felix Akira Green on 1/24/21.
//

import SwiftUI

// MARK: - PREVIEW
struct Hexagon_Previews: PreviewProvider {
	static var previews: some View {
		HexagonView()
	}
}

struct HexagonView: View {
	// MARK: - BODY
	
	var body: some View {
		let s: CGFloat = 80
		
		VStack {
			HStack {
				Hexagon()
					.hexagonalFrame(height: s)
					.foregroundColor(Color("blue.400"))
			}
		}
	}
}
