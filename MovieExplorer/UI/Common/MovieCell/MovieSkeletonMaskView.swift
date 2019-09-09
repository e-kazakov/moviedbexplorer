//
//  MovieSkeletonMaskView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 14.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieSkeletonMaskView: UIView {
  
  let imageStub = UIView.black
  let titleStub = UIView.black
  let yearStub = UIView.black
  let textLinesStubs = (0..<7).map { _ in UIView.black }

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    self.addSubview(imageStub)
    self.addSubview(imageStub)
    self.addSubview(titleStub)
    self.addSubview(yearStub)
    textLinesStubs.forEach(self.addSubview)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let layout = Layout.layout(for: bounds.size)
    imageStub.frame = layout.imageFrame
    titleStub.frame = layout.titleFrame
    yearStub.frame = layout.yearFrame
    zip(textLinesStubs, layout.textLinesFrames).forEach { (v, frame) in
      v.frame = frame
    }
  }
}

private struct Layout {
  
  let imageFrame: CGRect
  let titleFrame: CGRect
  let yearFrame: CGRect
  let textLinesFrames: [CGRect]
  
  private static let titleLeftTop = 6 as CGFloat
  private static let titleLeftOffset = 12 as CGFloat
  private static let titleRightOffset = 32 as CGFloat
  private static let titleHeight = 20 as CGFloat
  private static let yearSize = CGSize(width: 60, height: 20)
  private static let yearRightOffset = 20 as CGFloat
  private static let yearBottomOffset = 8 as CGFloat
  private static let textLineSpacing = 5 as CGFloat
  private static let textLineRightOffset = 20 as CGFloat
  private static let textLineVerticalOffset = 16 as CGFloat

  static func layout(for size: CGSize) -> Layout {
    let imageSize = CGSize(width: 125, height: 186)
    let imageOrigin = CGPoint(x: 0, y: (size.height - imageSize.height)/2)
    let imageFrame = CGRect(origin: imageOrigin, size: imageSize)
    
    let titleOrigin = CGPoint(x: imageFrame.maxX + Layout.titleLeftOffset,
                              y: titleLeftTop)
    let titleSize = CGSize(width: size.width - titleOrigin.x - Layout.titleRightOffset,
                           height: Layout.titleHeight)
    let titleFrame = CGRect(origin: titleOrigin, size: titleSize)

    let yearOrigin = CGPoint(x: size.width - yearSize.width - yearRightOffset,
                             y: imageFrame.maxY - yearSize.height - yearBottomOffset)
    let yearFrame = CGRect(origin: yearOrigin, size: yearSize)
    
    let textOriginY = titleFrame.maxY + Layout.textLineVerticalOffset
    let textHeight = yearFrame.minY - titleFrame.maxY - 2*Layout.textLineVerticalOffset
    let textLineSize = CGSize(width: size.width - titleOrigin.x - Layout.textLineRightOffset,
                              height: (textHeight - 6*Layout.textLineSpacing)/7)
    let textLinesFrames = (0..<7).map { idx in
      return CGRect(origin: CGPoint(x: titleOrigin.x, y: textOriginY + CGFloat(idx)*(textLineSize.height + Layout.textLineSpacing)),
                    size: textLineSize)
    }

    return Layout(imageFrame: imageFrame,
                  titleFrame: titleFrame,
                  yearFrame: yearFrame,
                  textLinesFrames: textLinesFrames)
  }

}

private extension UIView {
  
  static var black: UIView {
    let v = UIView()
    v.backgroundColor = .black
    return v
  }
  
}
