//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Either
import TesseractCore
import XCTest

final class TypecheckTests: XCTestCase {
	func testConstantNodesTypecheck() {
		let a = Identifier()
		let symbol = Symbol.Named("true", .Boolean)
		let graph = Graph(nodes: [ a: Node.Symbolic(symbol) ])
		assertEqual(assertRight(typecheck(graph, a, [symbol: Value(constant: true)])), Type.Boolean)
	}
}
