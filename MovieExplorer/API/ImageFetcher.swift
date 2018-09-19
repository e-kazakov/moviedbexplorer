//
//  ImageFetcher.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/19/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation
import class UIKit.UIImage

protocol ImageFetcher {
  func fetch(from url: URL, callback: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTaskProtocol
}
