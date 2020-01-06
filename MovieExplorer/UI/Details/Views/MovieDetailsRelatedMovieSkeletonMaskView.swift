//
//  MovieDetailsRelatedMovieSkeletonMaskView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/6/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsRelatedMovieSkeletonMaskView: UIView {
  
  let imageStub: UIView = {
    let view = UIView(color: .black)
    view.layer.cornerRadius = 4
    return view
  }()
  let titleStub = UIView(color: .black)

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    addSubview(imageStub)
    addSubview(titleStub)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let layout = Layout.layout(for: bounds.size)
    imageStub.frame = layout.imageFrame
    titleStub.frame = layout.titleFrame
  }
}

private struct Layout {
  
  let imageFrame: CGRect
  let titleFrame: CGRect
  
  private static let imageSize = CGSize(width: 125, height: 186)
  private static let titleTopOffset = 8 as CGFloat
  private static let titleHeight = 20 as CGFloat

  static func layout(for size: CGSize) -> Layout {
    let imageFrame = CGRect(origin: .zero, size: Layout.imageSize)
    
    let titleOrigin = CGPoint(x: 0,
                              y: imageFrame.maxY + Layout.titleTopOffset)
    let titleSize = CGSize(width: size.width, height: Layout.titleHeight)
    let titleFrame = CGRect(origin: titleOrigin, size: titleSize)

    return Layout(imageFrame: imageFrame,
                  titleFrame: titleFrame)
  }
}
