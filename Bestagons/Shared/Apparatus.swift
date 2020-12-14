//
//  Apparatus.swift
//  Bestagons
//
//  Created by Felix Akira Green on 12/8/20.
//

import SwiftUI

struct Apparatus: View {
	var body: some View {
		Text("Hello, asdfasdfasdfWorld!")
	}
}

struct Apparatus_Previews: PreviewProvider {
	static var previews: some View {
		Apparatus()
	}
}


// MARK: - asdf

enum ColorMode {
	case single, main, group, random
}

struct Block {
	var h: Bool
	var v: Bool
	var ind: Bool // indent? TODO:
	var clr: Color?
	var id: Int?
	
	init(
		h: Bool = false,
		v: Bool = false,
		ind: Bool = false,
		clr: Color? = nil,
		id: Int? = nil
	) {
		self.h = h
		self.v = v
		self.ind = ind
		
		if let clr = clr {
			self.clr = clr
		}
		if let id = id {
			self.id = id
		}
	}
}

class ApparatusGenerator {
	
	var xDim: Int
	var yDim: Int
	var xRadius: Double
	var yRadius: Double // or CGFloat?
	
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
	
	var globalSeed: Double
	
//	--
	var idX: Int
	var idY: Int
	var colorMain: Color
	var idCounter: Int
//	--
	
	// init
	init(
		width: Double,
		height: Double,
		initiateChance: Double = 0.8,
		extensionChance: Double = 0.8,
		verticalChance: Double = 0.8,
		horizontalSymmetry: Bool = true,
		verticalSymmetry: Bool = false,
		roundness: Double = 0.1,
		solidness: Double = 0.5,
		colors: [Color] = [],
		colorMode: ColorMode = .group,
		groupSize: Double = 0.8,
		simple: Bool = false
//		simplex
//		rateOfChange: Double = 0.01
	) {
		self.xDim = Int(round(width * 2 + 11))
		self.yDim = Int(round(height * 2 + 11))
		self.xRadius = width
		self.yRadius = height
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
		self.globalSeed = Double.random(in: 0.0...1.0)

		//
		self.idX = 0
		self.idY = 0
		self.idCounter = 0
		self.colorMain = Color.blue
	}
	
	// MARK: - generate
	func generate(
		// initialTop: [] = nil
		// initialLeft: [] = nil
		// verbose: Bool = false
		idX: Int = 0,
		idY: Int = 0
	) -> [[Block]] {
		self.idX = idX
		self.idY = idY
		
		self.idCounter = 0
		// TODO: get_random colors
		self.colorMain = Color.blue
		
		var grid = [[Block]]()
		
//		var grid = Array()
		
		for i in 0...yDim + 1 {
			for j in 0...yDim + 1 {
				// Create new block - Line 54
				if i == 0 || j == 0 {
					grid[i][j] = Block()
				}
				// TODO: handle initialTop & initialLeft
				
				// TODO: handle hSymmetric & vSymmetric
				else {
					grid[i][j] = nextBlock()
				}
			}
		}
		
		return grid
	}
	
	
	// MARK: - next block
}

// MARK: - MAIN LOOP



// MARK: - BLOCK SETS

// MARK: - BLOCKS

// MARK: - DECISIONS

// MARK: - CONVERSION
