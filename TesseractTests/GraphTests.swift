//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class GraphTests: XCTestCase {
	func testIdentityGraph() {
		let graph = Graph(nodes: [ .Input(0): (), .Output(0): () ], edges: [ Edge(.Input(0), .Output(0)) ])
	}

	func testSanitizesEdgesOnNodesMutation() {
		var graph = Graph(nodes: [ .Input(0): (), .Output(0): () ], edges: [ Edge(.Input(0), .Output(0)) ])
		XCTAssertEqual(graph.edges.count, 1)
		graph.nodes.removeValueForKey(.Input(0))
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testSanitizesEdgesOnEdgesMutation() {
		var graph = Graph<()>()
		XCTAssertEqual(graph.edges.count, 0)
		graph.edges.append(Edge(.Input(0), .Output(0)))
		XCTAssertEqual(graph.edges.count, 0)
	}

	func testAttachingDataToNodes() {
		let graph: Graph<Int> = Graph(nodes: [ .Input(0): 0, .Output(0): 1 ])
	}

	func testAbsoluteValueGraph() {
		let x = SourceIdentifier.Input(0)
		let result = DestinationIdentifier.Output(0)
		let zero = NodeIdentifier()
		let lessThan = NodeIdentifier()
		let iff = NodeIdentifier()
		let unaryMinus = NodeIdentifier()
		let abs = Graph<String>(nodes: [
			x.identifier: "x",
			result.identifier: "result",
			zero.identifier: "0",
			unaryMinus.identifier: "-",
			iff.identifier: "if",
			lessThan.identifier: "<"
		], edges: [
			Edge(x, lessThan.input(0)),
			Edge(zero.output(0), lessThan.input(1)),
			Edge(lessThan.output(0), iff.input(0)),
			Edge(x, unaryMinus.input(0)),
			Edge(unaryMinus.output(0), iff.input(1)),
			Edge(x, iff.input(2)),
			Edge(iff.output(0), result)
		])
		XCTAssertEqual(abs.nodes.count, 6)
		XCTAssertEqual(abs.edges.count, 7)
	}

	func testReductionDoesNotTraverseWithoutEdges() {
		let graph = Graph(nodes: [ .Output(0): "a", .Node(NodeIdentifier()): "b" ])
		let result = graph.reduce(.Output(0), "_") { into, each in into + each.1 }
		XCTAssertEqual(result, "_a")
	}

	func testReductionTraversesEdges() {
		let (a, b, c) = (NodeIdentifier(), NodeIdentifier(), NodeIdentifier())
		let graph = Graph(nodes: [ .Node(a): "a", .Node(b): "b", .Node(c): "c", .Output(0): "!" ], edges: [ Edge(.Node(a, 0), .Output(0)), Edge(.Node(b, 0), .Output(0)), Edge(.Node(c, 0), .Output(0)) ])
		let result = graph.reduce(.Output(0), "_") { into, each in into + each.1 }
		XCTAssertEqual(result, "_abc!")
	}
}
