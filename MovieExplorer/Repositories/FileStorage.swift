//
//  FileStorage.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 03.09.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol FileStorable {
  func write(_ data: Data) throws
  func read() throws -> Data?
}

class FileStorage: FileStorable {
  
  private let fileName: String
  private let directoryPath: String
  private let fileManager: FileManager
  
  private var directory: URL?
  
  init(fileName: String, directoryPath: String, fileManager: FileManager) {
    self.fileName = fileName
    self.directoryPath = directoryPath
    self.fileManager = fileManager
  }
  
  func read() throws -> Data? {
    let savedFileURL = try fileURL()
    guard fileManager.fileExists(atPath: savedFileURL.path) else {
      return nil
    }
    
    return try Data(contentsOf: savedFileURL)
  }

  func write(_ data: Data) throws {
    try data.write(to: try fileURL(), options: .atomic)
  }
  
  private func fileURL() throws -> URL {
    return try directoryURL().appendingPathComponent(fileName)
  }
  
  private func directoryURL() throws -> URL {
    if let directory = directory {
      return directory
    }
    
    let documentsURL = try fileManager.url(
      for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    
    let dirURL = documentsURL.appendingPathComponent(directoryPath, isDirectory: true)
    
    try fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)

    return dirURL
  }
}
