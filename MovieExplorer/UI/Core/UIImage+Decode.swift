//
//  UIImage+Decode.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/17/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension UIImage {
  func decoded() -> UIImage {
    guard let cgImage = self.cgImage else { return self }
    
    let size = CGSize(width: cgImage.width, height: cgImage.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
    defer { UIGraphicsEndImageContext() }
    
    let rect = CGRect(origin: .zero, size: size)
    draw(in: rect)
    return UIGraphicsGetImageFromCurrentImageContext() ?? self
  }
}
