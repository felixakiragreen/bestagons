//
//  Nifty.swift
//  FutureUI
//
//  Created by Felix Akira Green on 1/24/21.
//

import Foundation

/// Returns the input value clamped to the lower and upper limits.
func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
	return min(max(value, lower), upper)
}

extension Collection {
	/// This allows for indexes to be fetched safely
	subscript(optional i: Index) -> Iterator.Element? {
		return self.indices.contains(i) ? self[i] : nil
	}
}
