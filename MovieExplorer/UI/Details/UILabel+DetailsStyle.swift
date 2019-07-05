//
//  UILabel+DetailsStyle.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 16.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension UILabel.Style {
  @discardableResult
  static func releaseYear(_ label: UILabel) -> UILabel {
    label.textAlignment = .center
    label.layer.borderColor = UIColor(white: 151.0 / 255.0, alpha: 1.0).cgColor
    label.layer.borderWidth = 0.5
    label.layer.cornerRadius = 2
    return label
  }
  
  @discardableResult
  static func title(_ label: UILabel) -> UILabel {
    label.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
    return label
  }
  
  @discardableResult
  static func info(_ label: UILabel) -> UILabel {
    label.font = UIFont.systemFont(ofSize: 15, weight: .light)
    label.numberOfLines = 0
    return label
  }
  
  @discardableResult
  static func errorTitle(_ label: UILabel) -> UILabel {
    label.font = UIFont.systemFont(ofSize: 25, weight: .light)
    label.textAlignment = .center
    return label
  }
  
  @discardableResult
  static func errorMessage(_ label: UILabel) -> UILabel {
    label.font = UIFont.systemFont(ofSize: 17, weight: .thin)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }

}
