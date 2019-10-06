//
//  ImageViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/8/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

protocol ImageViewModel: class {

  func image(_ callback: @escaping (UIImage?) -> Void) -> Disposable

  func load()
}
