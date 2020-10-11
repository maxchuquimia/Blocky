//
//  DiskDataSource.swift
//  Blocky
//
//  Created by Max Chuquimia on 10/10/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import Foundation

protocol DiskDataSourceInterface {
    func write(data: Data, named: String)
    func readData(named: String) -> Data?
}

class DiskDataSource {

    static var groupLocation: URL {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.chuquimianproductions.Blocky")!
    }

    let location: URL
    let allowsCaching: Bool

    private static var cache: [URL: Data] = [:]

    init(allowsCaching: Bool = false, location: URL = DiskDataSource.groupLocation) {
        self.allowsCaching = allowsCaching
        self.location = location
    }

}

extension DiskDataSource: DiskDataSourceInterface {

    func write(data: Data, named name: String) {
        if !FileManager.default.fileExists(atPath: location.absoluteString, isDirectory: nil) {
            try? FileManager.default.createDirectory(at: location, withIntermediateDirectories: true, attributes: nil)
        }

        let targetFile = location.appendingPathComponent(name)

        do {
            try data.write(to: targetFile)
        } catch {
            LogError("Could not write to", targetFile, "because", error)
            return
        }

        if allowsCaching {
            Self.cache[targetFile] = data
        }
    }

    func readData(named name: String) -> Data? {
        let targetFile = location.appendingPathComponent(name)

        if allowsCaching, let cachedData = Self.cache[targetFile] {
            return cachedData
        }

        do {
            return try Data(contentsOf: targetFile)
        } catch {
            LogError("Could not read from", targetFile, "because", error)
        }

        return nil
    }

}
