//  Copyright (c) 2014 Rob Rix. All rights reserved.

final class GraphTests: XCTestCase {
	func testIdentityGraph() {
		let (a, b) = (Identifier(), Identifier())
		let graph = Graph(nodes: [ a: (), b: () ], edges: [ Edge((a, 0), (b, 0)) ])
		XCTAssertEqual(graph.nodes.count, 2)
		XCTAssertEqual(graph.edges.count, 1)
	}

	func testSanitizesEdgesOnNodesMutation() {
		let (a, b) = (Identifier(), Identifier())
		var graph = Graph(nodes: [ a: (), b: () ], edges: [ Edge((a, 0), (b, 0)) ])
		XCTAssertEqual(graph.edges.count, 1)
		graph.nodes.removeValueForKey(a)
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testSanitizesEdgesOnEdgesMutation() {
		var graph = Graph<()>()
		XCTAssertEqual(graph.edges.count, 0)
		graph.edges.insert(Edge((Identifier(), 0), (Identifier(), 0)))
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testAttachingDataToNodes() {
		let graph: Graph<Int> = Graph(nodes: [ Identifier(): 0, Identifier(): 1 ])
	}

	func testAbsoluteValueGraph() {
		XCTAssertEqual(absoluteValue.nodes.count, 6)
		XCTAssertEqual(absoluteValue.edges.count, 7)
	}

	func testMappingAcrossGraph() {
		let (a,b) = (Identifier(), Identifier())
		let graph = Graph(nodes: [a: "1", b: "2"], edges: [Edge(a, b.input(0))])
		let newGraph = graph.map { $0.toInt() ?? 0 }
		let expectedGraph = Graph(nodes: [a: 1, b: 2], edges: [Edge(a, b.input(0))])
		assert(newGraph, ==, expectedGraph)
	}

	func testReductionDoesNotTraverseWithoutEdges() {
		let (a, b) = (Identifier(), Identifier())
		let graph = Graph(nodes: [ a: "a", b: "b" ])
		let result = graph.reduce(a, "_") { into, each in into + each.1 }
		XCTAssertEqual(result, "_a")
	}

	func testReductionTraversesEdges() {
		let (a, b, c, result) = (Identifier(), Identifier(), Identifier(), Identifier())
		let graph = Graph(nodes: [ a: "a", b: "b", c: "c", result: "!" ], edges: [ Edge(a, result.input(0)), Edge(b, result.input(0)), Edge(c, result.input(0)) ])
		let reduced = graph.reduce(result, "_") { into, each in into + each.1 }
		XCTAssertEqual(reduced, "_abc!")
	}
}


// MARK: - Imports

import Assertions
import TesseractCore
import XCTest
