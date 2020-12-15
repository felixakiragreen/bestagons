//
//  ApparatusBuilder.swift
//  Apparatus
//
//  Created by Felix Akira Green on 12/14/20.
//

import SwiftUI

struct ApparatusBuilder: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ApparatusBuilder_Previews: PreviewProvider {
    static var previews: some View {
        ApparatusBuilder()
    }
}

/**
TODOs

v1.0 → simplest form workibg
v2.0 → all features from ApparatusGenerator

# v1.0

- all the blockSet functions



v1.1

symmetry

# v2.0

- noise generator
-



*/


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
	
	func getIdAndIncrement() -> Int {
		self.idCounter += 1
		return idCounter
	}
	
	// MARK: - generate
	/// Figured out: purpose of  initialTop + Left is for making sides match (like for a cube or embedded code)
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
		
		for i in 0...yDim + 1 {
			for j in 0...xDim + 1 {
				// Create new block - Line 54
				if i == 0 || j == 0 {
					grid[i][j] = Block()
				}
				// TODO: handle initialTop & initialLeft
				
				
				// TODO: handle hSymmetric & vSymmetric
				else {
					grid[i][j] = nextBlock(
						x: j,
						y: i,
						left: grid[i][j - 1],
						top: grid[i - 1][j]
					)
				}
			}
		}
		
		return grid
	}
	
	
	// MARK: - NEXT BLOCK
	func nextBlock(
		x: Int,
		y: Int,
		left: Block,
		top: Block
	) -> Block {
		
		if !left.ind && !top.ind {
			return blockSet1(x: x, y: y)
		}
		
		//
		
		// TODO: remove
		return Block()
	}
	
	// MARK: - BLOCK SETS

	func blockSet1(
		x: Int,
		y: Int
	) -> Block {
		if startNewFromBlank(x: x, y: y) {
			return newBlock(nX: x, nY: y)
		}
		return Block()
	}
	
//	.. TODO: blockSet1 - 9

	// MARK: - NEW BLOCK
	func newBlock(
		nX: Int, // newX? noiseX?
		nY: Int // TODO
	) -> Block {
		//	TODO: determine color based on noise
		
		var clr: Color {
			switch colorMode {
//			case .random:
//				return // noise func
//			TODO: color group
			case .main:
				// TODO:
				return colorMain
			default:
				return Color.red
			}
		}
		
		let id = getIdAndIncrement()
		
		return Block(h: true, v: true, ind: true, clr: clr, id: id)
	}
	
	
	
	
	// MARK: - DECISIONS
	
	// TODO: rename to shouldStart?
	/// Determines whether a blank should be used?
	func startNewFromBlank(x: Int, y: Int) -> Bool {
		if simple {
			return true
		}
		
		let fuzziness = -1 * (1 - roundness)
		if !activePosition(x: x, y: y, fuzzy: fuzziness) {
			return false
		}
		
		return noise(nX: Double(x), nY: Double(y), nZ: "_blank") <= solidness
	}
	
	func startNew(x: Int, y: Int) -> Bool {
		if simple {
			return true
		}
		
		let fuzziness = 0.0
		if !activePosition(x: x, y: y, fuzzy: fuzziness) {
			return false
		}
		
		return noise(nX: Double(x), nY: Double(y), nZ: "_new") <= chanceNew
	}
	
	func extend(x: Int, y: Int) -> Bool {
		let fuzziness = 1 - roundness
		if !activePosition(x: x, y: y, fuzzy: fuzziness) && !simple {
			return false
		}
		
		return noise(nX: Double(x), nY: Double(y), nZ: "_extend") <= chanceExtend
	}
	
	func verticalDir(x: Int, y: Int) -> Bool {
		return noise(nX: Double(x), nY: Double(y), nZ: "_vert") <= chanceVertical
	}
	
	// TODO: document, not sure what it does
	func activePosition(
		x: Int,
		y: Int,
		fuzzy: Double
	) -> Bool {
		let fuzziness = 1 + noise(nX: Double(x), nY: Double(y), nZ: "_active") * fuzzy
		let xA = pow(Double(x) - Double(xDim / 2), 2) / pow(xRadius * fuzziness, 2)
		let yA = pow(Double(y) - Double(yDim / 2), 2) / pow(yRadius * fuzziness, 2)
		
		return xA + yA < 1
	}
	
	
	// MARK: - NOISE / RANDOMNESS
	
	/// Generates noise / randomness
	func noise(
		nX: Double,
		nY: Double,
		nZ: String
	) -> Double {
		// TODO: use GKNoiseMap (if simplex)
		return Double.random(in: 0.0...1.0)
	}
	
//	func getRandomElement(<#parameters#>) -> <#return type#> {
//		<#function body#>
//	}
//	[].RandomElement
}






// MARK: - CONVERSION

// don't need for now
