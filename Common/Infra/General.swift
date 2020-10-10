//
//  General.swift
//  AppReviews
//
//  Created by Max Chuquimia on 27/2/19.
//  Copyright © 2019 Chuquimian Productions. All rights reserved.
//

import Foundation

func Copy(_ key: String) -> String {
    return NSLocalizedString(key, tableName: "Copy", bundle: Bundle.main, comment: key)
}

func Copy(_ key: String, _ value: String...) -> String {
    let format = NSLocalizedString(key, tableName: "Copy", bundle: Bundle.main, comment: key)
    return String(format: format, arguments: value)
}

func die(_ message: String = "???", file: String = #file, function: String = #function, line: Int = #line) -> Never {
    LogError(message)
    fatalError("\(message) -- \(file):\(function):\(line)")
}

func Log(_ items: Any..., highlighted: Bool = false, file: String = #file) {
    #if DEBUG
    let icon = highlighted ? "🔵" : "⚪️"
    print(items.reduce(icon + logPrefix(file: file), { $0 + " \($1)" }))
    #endif
}

func LogFunction(file: String = #file, function: String = #function, _ args: Any...) {
    #if DEBUG
    let log = function
        .components(separatedBy: ":")
        .enumerated()
        .reduce("") { (log, arg1) -> String in
            let (idx, chunk) = arg1

            if idx == args.count - 1 {
                return log + "\(chunk): \(args[idx])"
            } else if idx < args.count {
                return log + "\(chunk): \(args[idx]), "
            } else {
                return log + "\(chunk)"
            }
    }
    print("🟠", filename(file: file) + "." + log)
    #endif
}

func LogError(_ items: Any..., file: String = #file) {
    #if DEBUG
    print(items.reduce("🔴" + logPrefix(file: file), { $0 + " \($1)" }))
    #endif
}

private func logPrefix(file: String) -> String {
    " [\(filename(file: file))]"
}

private func filename(file: String) -> String {
    file.components(separatedBy: "/").last?.replacingOccurrences(of: ".swift", with: "") ?? "???"
}

func address<T: AnyObject>(of object: T) -> String {
    String(describing: Unmanaged.passUnretained(object).toOpaque())
}
