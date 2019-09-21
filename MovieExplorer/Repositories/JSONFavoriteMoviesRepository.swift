//
//  JSONFavoriteMoviesRepository.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 30.08.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

extension FileStorage {
  static var favoritesFile: FileStorage {
    return FileStorage(fileName: "favorites.json",
                       directoryPath: "favorites",
                       fileManager: FileManager.default)
  }
}

class JSONFavoriteMoviesRepository: FavoriteMoviesRepository {

  private let fileStorage: FileStorable
  
  private var cachedFavorites: FavoritesList?
  
  init(fileStorage: FileStorable = FileStorage.favoritesFile) {
    self.fileStorage = fileStorage
  }
  
  func movies() -> [Movie] {
    let fav = favorites()
    return fav.ids.compactMap { fav.movies[$0] }
  }
  
  func save(_ movie: Movie) throws {
    try updateFavorites { list in
      list.add(movie: movie)
    }
  }
  
  func removeBy(id movieId: Int) throws {
    try updateFavorites { list in
      list.removeBy(id: movieId)
    }
  }
  
  private func favorites() -> FavoritesList {
    if let cached = cachedFavorites {
      return cached
    }
    
    do {
      let loadedFavoritesList = try readFavorites() ?? .empty
      cachedFavorites = loadedFavoritesList
      return loadedFavoritesList
    } catch {
      print("Failed to load favorite movies from file. Error \(error)")
      cachedFavorites = .empty
      return .empty
    }
  }
  
  private func updateFavorites(_ closure: (inout FavoritesList) -> Void) throws {
    var favorites = self.favorites()
    closure(&favorites)
    try write(favorites)
    cachedFavorites = favorites
  }
  
  private func readFavorites() throws -> FavoritesList? {
    guard let savedData = try fileStorage.read() else {
      return nil
    }

    return try JSONDecoder().decode(FavoritesList.self, from: savedData)
  }
  
  private func write(_ favorites: FavoritesList) throws {
    let data = try JSONEncoder().encode(favorites)
    try fileStorage.write(data)
  }
}

private struct FavoritesList: Codable {
  var movies: [Int: Movie]
  var ids: [Int]
  
  static var empty: FavoritesList {
    return FavoritesList(movies: [:], ids: [])
  }
  
  mutating func add(movie: Movie) {
    guard !ids.contains(movie.id) else { return }
    
    movies[movie.id] = movie
    ids.append(movie.id)
  }
  
  mutating func removeBy(id movieId: Int) {
    movies[movieId] = nil
    ids.remove(movieId)
  }
}
