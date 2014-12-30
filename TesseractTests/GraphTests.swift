//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Tesseract
import XCTest

final class GraphTests: XCTestCase {
	func testIdentityGraph() {
		let graph = Graph(nodes: [ .Parameter(0), .Return(0) ], edges: [ Edge(input: SourceIdentifier(base: nil, index: 0), output: DestinationIdentifier(base: nil, index: 0)) ])
	}

	func testFiltersEdgesOnNodesMutation() {
		let a = SourceIdentifier(base: nil, index: 0)
		let b = DestinationIdentifier(base: nil, index: 0)
		var graph = Graph(nodes: [ .Source(a), .Destination(b) ], edges: [ Edge(input: a, output: b) ])
		graph.nodes.remove(.Source(a))
		XCTAssertEqual(graph.edges.count, 0)
	}
}
