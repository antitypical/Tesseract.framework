//  Copyright (c) 2015 Rob Rix. All rights reserved.

private func concat(strings: [String]) -> String {
    return reduce(strings, "", +)
}

public func export<T>(graph: Graph<T>) -> String {
    var result = "digraph tesseract {\n"
    result += concat(map(graph.edges, { edge in "\t" + edge.source.identifier.description + " -> " + edge.destination.identifier.description + ";\n" }))
    result += "}"
    return result
}

public func exportToFile<T>(graph: Graph<T>, filename: String) {
    let result = export(graph)
    let filehandle = NSFileHandle(forWritingAtPath: filename)
    if let data = result.dataUsingEncoding(NSUTF8StringEncoding) {
        filehandle?.writeData(data)
    }
}

// MARK: - Imports
import Prelude
import Foundation
