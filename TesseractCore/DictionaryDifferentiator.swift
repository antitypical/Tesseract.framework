//  Copyright (c) 2015 Rob Rix. All rights reserved.

public struct DictionaryDifferentiator<Key: Hashable, Value> {
	public static func differentiate(#before: Dictionary<Key, Value>, after: Dictionary<Key, Value>, equals: (Value, Value) -> Bool) -> UnorderedDifferential<(Key, Value)> {
		let (beforeKeys, afterKeys) = (Set(before.keys), Set(after.keys))
		let changedKeys = Set(lazy(beforeKeys.intersect(afterKeys))
			.filter { !((before[$0] &&& after[$0]).map(equals) ?? (before[$0] == nil && after[$0] == nil)) })

		return UnorderedDifferential(inserted: after[afterKeys.subtract(beforeKeys).union(changedKeys)], deleted: before[beforeKeys.subtract(afterKeys).union(changedKeys)])
	}
}


import Prelude
