//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class InferenceTests: XCTestCase {
	// MARK: Types

	func testGraphsWithoutReturnsHaveUnitType() {
		assert(constraints(Graph()).0, ==, .Unit)
	}

	func testGraphsWithOneReturnArePolymorphic() {
		assert(constraints(Graph(nodes: [Identifier(): .Return(0, nil)])).0, ==, .forall([ 0 ], 0))
	}

	func testGraphsWithOneParameterAndNoReturnsHaveFunctionTypeReturningUnit() {
		assert(constraints(Graph(nodes: [Identifier(): .Parameter(0, nil)])).0, ==, Term.function(0, .Unit).generalize())
	}

	func testGraphsWithOneParameterAndOneReturnHavePolymorphicFunctionType() {
		assert(constraints(Graph(nodes: [Identifier(): .Parameter(0, nil), Identifier(): .Return(0, nil)])).0, ==, Term.function(0, 1).generalize())
	}

	func testGraphsWithMultipleParametersHaveCurriedFunctionType() {
		assert(constraints(Graph(nodes: [Identifier(): .Parameter(0, nil), Identifier(): .Parameter(1, nil)])).0, ==, Term.function(0, .function(1, .Unit)).generalize())
	}

	func testGraphsWithMultipleReturnsHaveProductType() {
		assert(constraints(Graph(nodes: [Identifier(): .Return(0, nil), Identifier(): .Return(1, nil)])).0, ==, Term.product(0, 1).generalize())
	}

	func testGraphsWithMultipleParametersAndMultipleReturnsHaveCurriedFunctionTypeProducingProductType() {
		assert(constraints(Graph(nodes: [Identifier(): .Parameter(0, nil), Identifier(): .Parameter(1, nil), Identifier(): .Return(0, nil), Identifier(): .Return(1, nil)])).0, ==, Term.function(0, .function(1, .product(2, 3))).generalize())
	}
}


// MARK: Fixtures

private let identity: Graph<Node> = {
	let (a, b) = (Identifier(), Identifier())
	return Graph(nodes: [ a: .Parameter(0, nil), b: .Return(0, nil) ], edges: [ Edge((a, 0), (b, 0)) ])
}()


import Assertions
import Manifold
import Prelude
import TesseractCore
import XCTest
