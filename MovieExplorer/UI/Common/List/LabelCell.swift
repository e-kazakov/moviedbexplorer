//
//  LabelCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/24/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class LabelCell: UICollectionViewCell {

  struct Style {
    let font: UIFont
    let numberOfLines: Int
  }
  
  let label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    contentView.addSubview(label)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    label.frame = contentView.bounds
  }
  
  func apply(style: Style) {
    LabelCell.apply(style: style, to: label)
  }
  
  static func preferredSize(withText text: String, style: Style, in containerSize: CGSize) -> CGSize {
    sizingLabel.text = text
    apply(style: style, to: sizingLabel)
    let fittingSize = sizingLabel.sizeThatFits(containerSize)
    return CGSize(width: containerSize.width, height: fittingSize.height)
  }

  private static func apply(style: LabelCell.Style, to label: UILabel) {
    label.font = style.font
    label.numberOfLines = style.numberOfLines
  }
}

private let sizingLabel = UILabel()
