//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class EvaluationTests: XCTestCase {
	func createGraph(symbol: Symbol) -> (Identifier, Graph<Node>) {
		let a = Identifier()
		return (a, Graph(nodes: [ a: .Symbolic(symbol) ]))
	}

	func node(symbolName: String) -> Node {
		return .Symbolic(Prelude[symbolName]!.0)
	}

	var constantGraph: (Identifier, Graph<Node>) {
		return createGraph(Prelude["true"]!.0)
	}

	func testConstantNodeEvaluatesToConstant() {
		let (a, graph) = constantGraph
		let evaluated = evaluate(graph, a)

		assertEqual(assertNotNil(evaluated.right?.value.constant()), true)
	}

	func testFunctionNodeWithNoBoundInputsEvaluatesToFunction() {
		let (a, graph) = createGraph(Prelude["identity"]!.0)
		let evaluated = evaluate(graph, a)

		assertEqual(assertNotNil(evaluated.right?.value.function() as (Any -> Any)?).map { $0(1) as! Int }, 1)
	}

	func testFunctionNodeWithBoundInputAppliesInput() {
		let (a, b) = (Identifier(), Identifier())
		let graph = Graph(nodes: [ a: node("true"), b: node("identity") ], edges: [ Edge((a, 0), (b, 0)) ])
		let evaluated = evaluate(graph, b)

		assertEqual(assertNotNil(evaluated.right?.value.constant()), true)
	}

	func testGraphNodeWithNoBoundInputsEvaluatesToGraph() {
		let (a, b) = (Identifier(), Identifier())
		let constant = Graph<Node>(nodes: [ a: node("true"), b: .Return(.Named("return", .Bool)) ], edges: [ Edge((a, 0), (b, 0)) ])

		let truthy = Symbol.Named("truthy", .Bool)
		let (c, graph) = createGraph(truthy)
		let evaluated = evaluate(graph, c, [truthy: Value(graph: constant)])
		let right = evaluated.right?.value.graph.map { $0 == constant }
		assertEqual(right ?? false, true)
	}

	func testGraphNodeWithBoundInputsAppliesInput() {
		let (a, b) = (Identifier(), Identifier())
		let identity = Graph<Node>(nodes: [ a: .Parameter(.Parameter(0, Term(0))), b: .Return(.Named("return", Term(0))) ], edges: [ Edge((a, 0), (b, 0)) ])

		let identitySymbol = Symbol.Named("identity", Term.forall([ 0 ], .function(Term(0), Term(0))))
		let (c, d) = (Identifier(), Identifier())
		let graph = Graph(nodes: [ c: node("true"), d: .Symbolic(identitySymbol) ], edges: [ Edge((c, 0), (d, 0)) ])
		let evaluated = evaluate(graph, d, Prelude + (identitySymbol, Value(graph: identity)))
		assertEqual(assertNotNil(evaluated.right?.value.constant()), true)
	}
}


// MARK: - Imports

import Assertions
import Manifold
import TesseractCore
import XCTest
