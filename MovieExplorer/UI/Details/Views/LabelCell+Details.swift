//
//  LabelCell+Details.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/26/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension LabelCell.Style {
  static var movieDetailsTitleStyle: LabelCell.Style {
    LabelCell.Style(
      font: UIFont.systemFont(ofSize: 25, weight: .semibold),
      numberOfLines: 0
    )
  }
  
  static var movieDetailsTaglineStyle: LabelCell.Style {
    let font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
    let descriptor = font.fontDescriptor.withSymbolicTraits(.traitItalic)!

    return LabelCell.Style(
      font: UIFont(descriptor: descriptor, size: font.pointSize),
      numberOfLines: 0
    )
  }
  
  static var movieDetailsOverviewStyle: LabelCell.Style {
    LabelCell.Style(
      font: UIFont.systemFont(ofSize: 17, weight: .light),
      numberOfLines: 0
    )
  }
  
  static var movieDetailsGenresStyle: LabelCell.Style {
    LabelCell.Style(
      font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote),
      numberOfLines: 0
    )
  }
}
