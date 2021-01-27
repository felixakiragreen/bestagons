//
//  DoubleField.swift
//  Hexis
//
//  Created by Felix Akira Green on 12/21/20.
//

import SwiftUI

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
		formatter.numberStyle = .decimal
		guard let s = formatter.string(from: NSNumber(value: value)) else {
			return ""
		}
		return s
	}
}

struct DoubleField_Previews: PreviewProvider {
	static var previews: some View {
		DoubleField(value: .constant(6.0))
	}
}
