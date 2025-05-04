//
//  Debugger.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation

struct Debugger {
    /// Print function only for debugging a single item on debug environments.
    /// - Parameters:
    ///   - items: The items to print.
    ///   - filename: The filename of file where print originated.
    ///   - function: The function where the print is called.
    ///   - line: The line number within file.
    ///   - separator: The separator to use.
    ///   - terminator: The items terminator to use.
    static func print(_ items: Any...,
                      filename: String = #file,
                      function: String = #function,
                      line: Int = #line,
                      separator: String = " ",
                      terminator: String = "\n") {
        var key: String?
        
#if DEBUG
        key = "Dev"
#elseif QA
        key = "QA"
#endif
        
        guard let key = key else {
            return
        }
        
        let file = URL(fileURLWithPath: filename).lastPathComponent
        let output = items.map { "\n\t-> \($0)" }.joined(separator: separator)
        let pretty = "\(key) - \(file) \(function) at line #\(line)\(output)"
        
        Swift.print(pretty, terminator: terminator)
    }
}
