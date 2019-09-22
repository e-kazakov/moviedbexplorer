//
//  ImageFetcher.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/19/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation
import class UIKit.UIImage

enum PosterSize: String {
  case w92 = "w92"
  case w185 = "w185"
  case w500 = "w500"
  case w780 = "w780"
}

protocol ImageFetcher {
  
  func posterURL(path: String, size: PosterSize) -> URL
  
  func fetch(from url: URL, callback: @escaping (Result<UIImage, APIError>) -> Void) -> Disposable
}
