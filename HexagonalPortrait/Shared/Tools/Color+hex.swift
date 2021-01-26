//
//  Color+hex.swift
//  FutureUI
//
//  Created by Felix Akira Green on 1/24/21.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

typealias ColorComponentsRGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
typealias ColorComponentsHSVA = (hue: CGFloat, saturation: CGFloat, value: CGFloat, alpha: CGFloat)

extension Color {
	
	var rgba: ColorComponentsRGBA {
		#if canImport(AppKit)
		let color = NSColor(self).usingColorSpace(.deviceRGB)!
		#elseif canImport(UIKit)
		let color = UIColor(self)
		#endif
		
		var t = (CGFloat(), CGFloat(), CGFloat(), CGFloat())
		color.getRed(&t.0, green: &t.1, blue: &t.2, alpha: &t.3)
		return t
	}
	
	var hsva: ColorComponentsHSVA {
		#if canImport(AppKit)
		let color = NSColor(self).usingColorSpace(.deviceRGB)!
		#elseif canImport(UIKit)
		let color = UIColor(self)
		#endif
		
		var t = (CGFloat(), CGFloat(), CGFloat(), CGFloat())
		color.getHue(&t.0, saturation: &t.1, brightness: &t.2, alpha: &t.3)
		return t
	}
	
	init?(hex: String) {
		guard let (r, g, b, a) = hexStringToColorComponents(hex) else {
			return nil
		}
		
		self.init(
			.sRGB,
			red: Double(r),
			green: Double(g),
			blue: Double(b),
			opacity: Double(a)
		)
	}
	
	init?(hex: Int) {
		guard let (r, g, b, a) = hexIntToColorComponents(rgba: hex) else {
			return nil
		}
		
		self.init(
			.sRGB,
			red: Double(r),
			green: Double(g),
			blue: Double(b),
			opacity: Double(a)
		)
	}
	
	func toHexString() -> String {
		return hexStringFromColorComponents(self.rgba)
	}
	
	func toHexInt() -> Int {
		return hexIntFromColorComponents(rgba: self.rgba)
	}
}

func hexStringToColorComponents(_ hex: String) -> ColorComponentsRGBA? {
	// print("hexStringToColorComponents → \(hex)")
	var hexString = hex
	
	if hexString.hasPrefix("#") { // Remove the '#' prefix if added.
		let start = hexString.index(hexString.startIndex, offsetBy: 1)
		hexString = String(hexString[start...])
	}
	
	if hexString.lowercased().hasPrefix("0x") { // Remove the '0x' prefix if added.
		let start = hexString.index(hexString.startIndex, offsetBy: 2)
		hexString = String(hexString[start...])
	}
	
	let r, g, b, a: CGFloat
	let scanner = Scanner(string: hexString)
	var hexNumber: UInt64 = 0
	guard scanner.scanHexInt64(&hexNumber) else { return nil } // Make sure the strinng is a hex code.
	
	switch hexString.count {
		case 3, 4: // Color is in short hex format
			var updatedHexString = ""
			hexString.forEach { updatedHexString.append(String(repeating: String($0), count: 2)) }
			hexString = updatedHexString
			return hexStringToColorComponents(hexString)
			
		case 6: // Color is in hex format without alpha
			r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
			g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
			b = CGFloat(hexNumber & 0x0000FF) / 255.0
			a = 1.0
			return ColorComponentsRGBA(red: r, green: g, blue: b, alpha: a)
			
		case 8: // Color is in hex format with alpha
			r = CGFloat((hexNumber & 0xFF000000) >> 24) / 255.0
			g = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255.0
			b = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255.0
			a = CGFloat(hexNumber & 0x000000FF) / 255.0
			return ColorComponentsRGBA(red: r, green: g, blue: b, alpha: a)
			
		default: // Invalid format.
			return nil
	}
}
func hexStringFromColorComponents(_ components: ColorComponentsRGBA) -> String {
	// print("hexStringFromColorComponents → \(components)")
	
	if components.alpha == 1.0 {
		// Color is in hex format without alpha
		let rgb: Int = hexIntFromColorComponents(rgb: components)
		// print("hexString rgb → \(rgb)")
		
		return String(format: "#%06x", rgb)
	} else {
		// Color is in hex format with alpha
		let rgba: Int = hexIntFromColorComponents(rgba: components)
		// print("hexString rgba → \(rgba)")
		
		return String(format: "#%08x", rgba)
	}
}

func hexIntToColorComponents(rgb hex: Int) -> ColorComponentsRGBA? {
	guard hex >= 0, hex <= (256 * 256 * 256) else {
		return nil
	}
	
	let r = CGFloat((hex & 0xff0000) >> 16) / 255.0
	let g = CGFloat((hex & 0xff00) >> 8) / 255.0
	let b = CGFloat((hex & 0xff) >> 0) / 255.0
	return ColorComponentsRGBA(red: r, green: g, blue: b, alpha: 1.0)
}
func hexIntToColorComponents(rgba hex: Int) -> ColorComponentsRGBA? {
	guard hex >= 0, hex <= (256 * 256 * 256 * 256) else {
		return nil
	}
	
	let r = CGFloat((hex & 0xff000000) >> 24) / 255.0
	let g = CGFloat((hex & 0xff0000) >> 16) / 255.0
	let b = CGFloat((hex & 0xff00) >> 8) / 255.0
	let a = CGFloat((hex & 0xff) >> 0) / 255.0
	return ColorComponentsRGBA(red: r, green: g, blue: b, alpha: a)
}

func hexIntFromColorComponents(rgb components: ColorComponentsRGBA) -> Int {
	let (r, g, b, _) = components
	return (Int)(r * 255)<<16 | (Int)(g * 255)<<8 | (Int)(b * 255)<<0
}
func hexIntFromColorComponents(rgba components: ColorComponentsRGBA) -> Int {
	let (r, g, b, a) = components
	return (Int)(r * 255)<<24 | (Int)(g * 255)<<16 | (Int)(b * 255)<<8 | (Int)(a * 255)<<0
}

