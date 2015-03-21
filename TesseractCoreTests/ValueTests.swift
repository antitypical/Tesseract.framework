//  Copyright (c) 2015 Rob Rix. All rights reserved.

final class ValueTests: XCTestCase {
	func testConstantValueDestructuresToSomeOfSameType() {
		assert(Value(1).constant(), ==, 1)
	}

	func testConstantValueDestructuresToNoneOfDifferentType() {
		assertNil(Value(1).constant() as ()?)
	}

	func testFunctionValueDestructuresAsConstantToNone() {
		assertNil(Value(function: id as Any -> Any).constant() as Any?)
	}


	func testFunctionValueDestructuresToSomeOfSameType() {
		assertNotNil(Value(function: id as Any -> Any).function() as (Any -> Any)?)
	}

	func testFunctionValueDestructuresToNoneOfDifferentType() {
		assertNil(Value(function: id as Any -> Any).function() as (Int -> Int)?)
	}

	func testConstantValueDestructuresAsFunctionToNone() {
		assertNil(Value(()).function() as (Any -> Any)?)
	}


	func testApplicationOfConstantIsError() {
		let value = Value(())
		assertNotNil(value.apply(value, Identifier(), [:]).left)
	}

	func testApplicationOfIdentityIsArgument() {
		let argument = Value(1)
		let identity = Value(function: id as Any -> Any)
		assertEqual(assertNotNil(identity.apply(argument, Identifier(), [:]).right)?.value.constant(), 1)
	}
}


// MARK: - Imports

import Assertions
import Prelude
import TesseractCore
import XCTest
