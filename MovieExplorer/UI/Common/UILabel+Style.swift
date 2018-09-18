//
//  UILabel+Style.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/18/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension UILabel {
  struct Style {
    static func releaseYear(_ label: UILabel) {
      label.layer.borderColor = UIColor(white: 151.0 / 255.0, alpha: 1.0).cgColor
      label.layer.borderWidth = 0.5
      label.layer.cornerRadius = 2
    }
  }
}
