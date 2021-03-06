//
//  ApparatusBuilder.swift
//  Apparatus
//
//  Created by Felix Akira Green on 12/14/20.
//

import SwiftUI
import GameplayKit

/**
TODOs

all features from ApparatusGenerator

noise

initialTop & Left

*/

// MARK: - GENERATOR

class ApparatusGenerator {
	
	// TODO: reorganize :)
	
	var xDim: Int
	var yDim: Int
	var xRadius: Double
	var yRadius: Double
	
	var chanceNew: Double
	var chanceExtend: Double
	var chanceVertical: Double
	
	var colors: [ColorPreset]
	var colorPalette: ColorPresetPalette
	
	var colorMode: ColorMode
	var groupSize: Double
	
	var hSymmetric: Bool
	var vSymmetric: Bool
	
	var roundness: Double
	var solidness: Double
	
	var simple: Bool

	// TODO: rename
//	var simplex: ...
//	var rateOfChange: Double
	
	var seed: Int
	
//	--
	var idX: Int
	var idY: Int
	var colorMain: ColorPreset
	var idCounter: Int
//	--
	
	init(
		config: ApparatusConfig
	) {
		self.xDim = Int(round(config.cellCountX * 2 + 11))
		self.yDim = Int(round(config.cellCountY * 2 + 11))
		self.xRadius = config.cellCountX
		self.yRadius = config.cellCountY
		self.chanceNew = config.chanceNew
		self.chanceExtend = config.chanceExtend
		self.chanceVertical = config.chanceVertical
		self.colors = config.colorPalette.getColorPresets()
		self.colorPalette = config.colorPalette
		self.colorMode = config.colorMode
		self.groupSize = config.groupSize
		self.hSymmetric = config.hSymmetric
		self.vSymmetric = config.vSymmetric
		self.roundness = config.roundness
		self.solidness = config.solidness
		self.simple = config.simple
		self.seed = config.seed

		//
		self.idX = 0
		self.idY = 0
		self.idCounter = 0
		self.colorMain = config.colorPalette.getColorPresets().randomElement() ?? ColorPreset()
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
		idX: Int = 0,
		idY: Int = 0
	) -> [[Block]] {
		self.idX = idX
		self.idY = idY
		
		self.idCounter = 0
		// TODO: get_random colors
//		self.colorMain = ColorPreset.blue
		
//		var grid = [[Block]]()
		
		var grid = Array(
			repeating: Array(
				repeating: Block(), count: xDim
			),
			count: yDim + 1
		)
		
		for i in grid.indices {
			for j in grid[i].indices {
				// Create new block - Line 54
				if i == 0 || j == 0 {
//					grid[i][j] = Block()
				}
				// TODO: handle initialTop & initialLeft

				else if hSymmetric && i > grid.count / 2 {
					grid[i][j] = Block(
						block: grid[grid.count - i][j],
						h: grid[grid.count - i + 1][j].h,
						id: getIdAndIncrement()
					)
				}
				else if vSymmetric && j > grid[i].count / 2 {
					grid[i][j] = Block(
						block: grid[i][grid[i].count - j],
						v: grid[i][grid[i].count - j + 1].v,
						id: getIdAndIncrement()
					)
				}
				
				
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
		
//		grid[0...yDim + 1] =
		
//		let rects = convertLineGridToRect(grid: grid)
		
		return grid
	}
	
	
	// MARK: - NEXT BLOCK
	func nextBlock(
		x: Int,
		y: Int,
		left: Block,
		top: Block
	) -> Block {
		
		if !left.inside && !top.inside {
			return blockSet1(x: x, y: y, left: left, top: top)
		}
		
		if left.inside && !top.inside {
			if left.h {
				return blockSet3(x: x, y: y, left: left, top: top)
			}
			return blockSet2(x: x, y: y, left: left, top: top)
		}
		
		if !left.inside && top.inside {
			if top.v {
				return blockSet5(x: x, y: y, left: left, top: top)
			}
			return blockSet4(x: x, y: y, left: left, top: top)
		}
		
		if left.inside && top.inside {
			if !left.h && !top.v {
				return blockSet6(left: left)
			}
			if left.h && !top.v {
				return blockSet7(x: x, y: y, left: left, top: top)
			}
			if !left.h && top.v {
				return blockSet8(x: x, y: y, left: left, top: top)
			}
			return blockSet9(x: x, y: y, left: left, top: top)
		}
		
//		// TODO: remove
//		guard never?
		return Block()
	}
	
	// MARK: - BLOCK SETS

	func blockSet1(x: Int, y: Int, left: Block, top: Block) -> Block {
		if startNewFromBlank(x: x, y: y) {
			return newBlock(nX: x, nY: y, left: left, top: top)
		}
		return Block()
	}
	
	func blockSet2(x: Int, y: Int, left: Block, top: Block) -> Block {
		if startNewFromBlank(x: x, y: y) {
			return newBlock(nX: x, nY: y, left: left, top: top)
		}
		return Block(v: true)
	}
	
	func blockSet3(x: Int, y: Int, left: Block, top: Block) -> Block {
		if extend(x: x, y: y) {
			return Block(h: true, inside: true, color: left.color, id: left.id)
		}
		return blockSet2(x: x, y: x, left: left, top: top)
	}
	
	func blockSet4(x: Int, y: Int, left: Block, top: Block) -> Block {
		if startNewFromBlank(x: x, y: y) {
			return newBlock(nX: x, nY: y, left: left, top: top)
		}
		return Block(h: true)
	}
	
	func blockSet5(x: Int, y: Int, left: Block, top: Block) -> Block {
		if extend(x: x, y: y) {
			return Block(v: true, inside: true, color: top.color, id: top.id)
		}
		return blockSet4(x: x, y: x, left: left, top: top)
	}
	
	func blockSet6(left: Block) -> Block {
		return Block(inside: true, color: left.color, id: left.id)
	}
	
	func blockSet7(x: Int, y: Int, left: Block, top: Block) -> Block {
		if extend(x: x, y: y) {
			return Block(h: true, inside: true, color: left.color, id: left.id)
		}
		if startNew(x: x, y: y) {
			return newBlock(nX: x, nY: y, left: left, top: top)
		}
		return Block(h: true, v: true)
	}
	
	func blockSet8(x: Int, y: Int, left: Block, top: Block) -> Block {
		if extend(x: x, y: y) {
			return Block(v: true, inside: true, color: top.color, id: top.id)
		}
		if startNew(x: x, y: y) {
			return newBlock(nX: x, nY: y, left: left, top: top)
		}
		return Block(h: true, v: true)
	}
	
	func blockSet9(x: Int, y: Int, left: Block, top: Block) -> Block {
		if verticalDir(x: x, y: y) {
			return Block(v: true, inside: true, color: top.color, id: top.id)
		}
		return Block(h: true, inside: true, color: left.color, id: left.id)
	}

	// MARK: - NEW BLOCK
	func newBlock(
		nX: Int, // newX? noiseX?
		nY: Int, // TODO
		left: Block,
		top: Block
	) -> Block {
		//	TODO: determine color based on noise
		
		let x = Double(nX)
		let y = Double(nY)
		
		let randomColor: ColorPreset = getRandomElement(array: colors, nX: x, nY: y)
		
		var color: ColorPreset {
			switch colorMode {
			case .random:
				return randomColor
//				return colors.randomElement() ?? ColorPreset.red
			case .main:
				return noise(nX: x, nY: y, nZ: "_main") > 0.75 ? randomColor : colorMain
			case .group:
				let keep = noise(nX: x, nY: y, nZ: "_keep") > 0.5 ? left.color : top.color
				//
				if noise(nX: x, nY: y, nZ: "_group") > groupSize {
					colorMain = randomColor
				} else if keep != nil {
					colorMain = keep!
				}
				return colorMain
//				 =  ? randomColor : (keep || colorMain)
			default:
				return ColorPreset()
			}
		}
		
		let id = getIdAndIncrement()
		
		return Block(h: true, v: true, inside: true, color: color, id: id)
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
	func activePosition(x: Int, y: Int, fuzzy: Double) -> Bool {
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
		
//		TODO: if ...
		
		let randomSeed = "\(seed)\(nX)\(nY)\(nZ)".data(using: .utf8)!
		
		let randomSource = GKARC4RandomSource.init(seed: randomSeed)
		
		return Double(randomSource.nextUniform())
		
//		return Double.random(in: 0.0...1.0)
	}
	
	func getRandomElement<T>(array: Array<T>, nX: Double, nY: Double) -> T {
		return array[Int(floor(noise(nX: nX, nY: nY, nZ: "_array") * Double(array.count)))]
	}
}


// MARK: - MODEL

enum ColorMode {
	case single, main, group, random
}

struct Block {
	var h: Bool
	var v: Bool
	var inside: Bool
	var color: ColorPreset?
	var id: Int?
	
	init(
		h: Bool = false,
		v: Bool = false,
		inside: Bool = false,
		color: ColorPreset? = nil,
		id: Int? = nil
	) {
		self.h = h
		self.v = v
		self.inside = inside
		
		if let color = color {
			self.color = color
		}
		if let id = id {
			self.id = id
		}
	}

	init(block: Block, h: Bool? = nil, v: Bool? = nil, id: Int? = nil) {
		self.h = h ?? block.h
		self.v = v ?? block.v
		self.inside = block.inside
		
		if let color = block.color {
			self.color = color
		}
		if let id = id ?? block.id {
			self.id = id
		}
	}
}

struct BlockCorner {
	var x1: Int
	var y1: Int
	var color: ColorPreset
	var id: Int
}

struct BlockRect {
	var x1: Int
	var y1: Int
	var w: Int
	var h: Int
	var color: ColorPreset
	var id: Int
}


// MARK: - HELPERS (conversion)

func convertLineGridToRect(grid: [[Block]]) -> [BlockRect] {
	let nwCorners = getNWCorners(grid: grid)
	return extendCornersToRect(grid: grid, corners: nwCorners)
}

func getNWCorners(grid: [[Block]]) -> [BlockCorner] {
	var nwCorners = [BlockCorner]()
	
//	for column in grid {
//		for cell in column {
//			if cell.h && cell.v && cell.ind {
//				nwCorners.append(BlockRect(x1: cell, y1: <#T##Int#>, color: <#T##ColorPreset#>, id: <#T##Int#>))
//			}
//		}
//	}
	for i in grid.indices {
		for j in grid[i].indices {
			let cell = grid[i][j]
			if cell.h && cell.v && cell.inside {
				nwCorners.append(BlockCorner(x1: j, y1: i, color: cell.color ?? ColorPreset(), id: cell.id ?? 9999))
			}
		}
	}
	
	return nwCorners
}

func extendCornersToRect(grid: [[Block]], corners: [BlockCorner]) -> [BlockRect] {
	return corners.map { c in
		var accX = 0
		repeat {
			accX += 1
		} while c.x1 + accX < grid[c.y1].count && !grid[c.y1][c.x1 + accX].v
		
		var accY = 0
		repeat {
			accY += 1
		} while c.y1 + accY < grid.count && !grid[c.y1 + accY][c.x1].h
		
		return BlockRect(x1: c.x1, y1: c.y1, w: accX, h: accY, color: c.color, id: c.id)
	}
}
