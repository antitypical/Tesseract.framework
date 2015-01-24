//  Copyright (c) 2014 Rob Rix. All rights reserved.

public struct Edge: Hashable {
	public init(_ source: SourceIdentifier, _ destination: DestinationIdentifier) {
		self.source = source
		self.destination = destination
	}

	public let source: SourceIdentifier
	public let destination: DestinationIdentifier


	// MARK: Hashable

	public var hashValue: Int {
		return source.hashValue ^ destination.hashValue
	}
}

public func == (left: Edge, right: Edge) -> Bool {
	return left.source == right.source && left.destination == right.destination
}


public struct Graph<T> {
	public init(nodes: [Identifier: T] = [:], edges: Set<Edge> = []) {
		self.nodes = nodes
		self.edges = edges
		sanitize(edges)
	}


	// MARK: Primitive methods

	public var nodes: [Identifier: T] {
		willSet {
			let removed = Set(nodes.keys) - Set(newValue.keys)
			if removed.count == 0 { return }
			edges = edges.filter {
				!removed.contains($0.source.identifier) && !removed.contains($0.destination.identifier)
			}
		}
	}

	public var edges: Set<Edge> {
		didSet {
			sanitize(edges - oldValue)
		}
	}

	
	// MARK: Higher-order methods.

	public func filter(includeNode: (Identifier, T) -> Bool) -> Graph {
		return Graph(nodes: nodes.filter(includeNode), edges: edges)
	}

	public func filter(includeEdge: Edge -> Bool) -> Graph {
		return Graph(nodes: nodes, edges: edges.filter(includeEdge))
	}

	public func filter(includeNode: (Identifier, T) -> Bool = const(true), includeEdge: Edge -> Bool = const(true)) -> Graph {
		return Graph(nodes: nodes.filter(includeNode), edges: edges.filter(includeEdge))
	}


	// MARK: Private

	private mutating func sanitize(added: Set<Edge>) {
		if added.count == 0 { return }
		let keys = nodes.keys
		edges -= added.filter {
			!contains(keys, $0.source.identifier) && !contains(keys, $0.destination.identifier)
		}
	}
}


// MARK: - Imports

import Set
import Prelude
