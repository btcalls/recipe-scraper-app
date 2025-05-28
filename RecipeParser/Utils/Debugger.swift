//
//  Debugger.swift
//  RecipeParser
//
//  Created by Jason Jon Carreos on 1/5/2025.
//

import Foundation
import os

struct Debugger {
    enum `Type` {
        case trace
        case notice
        case warning
        case critical
    }
    
    /// Log messages to Xcode's debug console.
    /// - Parameters:
    ///   - message: The message to display.
    ///   - type: The type of log to use.
    ///   - file: The file in which the logger was called.
    ///   - function: The function in which the logger was called.
    ///   - line: The line number in which the logger was called.
    static func log(_ message: String,
                    type: Debugger.`Type` = .notice,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
        var env: String = ""
        
#if DEBUG
        env = "[Dev] "
#elseif QA
        env = "[QA] "
#endif
        
        // Only print at Dev and QA builds
        guard !env.isEmpty else {
            return
        }
        
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                            category: file)
        
        switch type {
        case .trace:
            logger.trace("\(env)At \(function) (line: \(line)):\n -> \(message)")
        
        case .notice:
            logger.notice("\(env)At \(function) (line: \(line)):\n -> \(message)")
            
        case .warning:
            logger.warning("\(env)At \(function) (line: \(line)):\n -> \(message)")
            
        case .critical:
            logger.critical("\(env)At \(function) (line: \(line)):\n -> \(message)")
        }
    }
    
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
        var env: String?
        
#if DEBUG
        env = "Dev"
#elseif QA
        env = "QA"
#endif
        
        guard let env else {
            return
        }
        
        let file = URL(fileURLWithPath: filename).lastPathComponent
        let output = items.map { "\n\t-> \($0)" }.joined(separator: separator)
        let pretty = "\(env) - \(file) \(function) at line #\(line)\(output)"
        
        Swift.print(pretty, terminator: terminator)
    }
}

extension Debugger {
    /// Logs an error to Xcode's debug console.
    /// - Parameter error: `Error` instance to log.
    static func critical(_ error: Error) {
        Self.log(error.localizedDescription, type: .critical)
    }
    
    /// Logs an error to Xcode's debug console.
    /// - Parameter error: `CustomError` instance to log.
    static func critical(_ error: CustomError) {
        Self.log(error.description, type: .critical)
    }
}
