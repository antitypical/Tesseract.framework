//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ImportingTests: XCTestCase {
	func testImporting() {
		if let (name, parsedGraph) = importDOT(exportDOT("absoluteValue", absoluteValue)) {
			let parsedNodes = Set(parsedGraph.nodes.values.array)
			let actualNodes = Set(absoluteValue.nodes.values.array)

			XCTAssertEqual(name, "absoluteValue")
			XCTAssertEqual(parsedNodes, actualNodes)
			XCTAssertEqual(parsedGraph.edges.count, absoluteValue.edges.count)
		} else {
			XCTFail("could not parse the DOT")
		}
	}
	
	func testMapAcrossImportedGraph() {
		let rawGraph = "digraph test {\n\t\"1\" -> \"2\";\n}"
		if let (_, parsedGraph) = importDOT(rawGraph) {
			let graph = parsedGraph.map { $0.toInt() ?? 0 }
			let (a, b) = (Identifier(), Identifier())
			let expectedGraph = Graph(nodes: [a: 1, b: 2], edges: Set([Edge(a, b.input(0))]))
			let parsedNodes = Set(graph.nodes.values.array)
			let expectedNodes = Set(expectedGraph.nodes.values.array)

			XCTAssertEqual(parsedNodes, expectedNodes)
			XCTAssertEqual(parsedGraph.edges.count, expectedGraph.edges.count)
		} else {
			XCTFail("could not parse the DOT")
		}
	}
}


// MARK: - Imports

import TesseractCore
import XCTest
