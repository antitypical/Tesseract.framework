//  Copyright (c) 2014 Rob Rix. All rights reserved.

public enum Symbol: Hashable, Printable {
	public init(_ name: String, _ type: Term) {
		self = Named(name, type)
	}

	public init(_ index: Int, _ type: Term) {
		self = Parameter(index, type)
	}


	case Named(String, Term)
	case Parameter(Int, Term)


	public var name: String {
		switch self {
		case let Named(name, _):
			return name
		case let Parameter(index, _):
			return index.description
		}
	}

	public var type: Term {
		switch self {
		case let Named(_, type):
			return type
		case let Parameter(_, type):
			return type
		}
	}


	// MARK: Hashable

	public var hashValue: Int {
		return
			name.hashValue
		^	type.hashValue
	}


	// MARK: Printable

	public var description: String {
		let comma = ", "
		return "\(name) :: \(type)"
	}
}

public func == (left: Symbol, right: Symbol) -> Bool {
	return
		left.name == right.name
	&&	left.type == right.type
}


// MARK: - Imports

import Manifold
