//
//  MovieSkeletonCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 5/26/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieSkeletonCell: UITableViewCell {
  
  static let preferredHeight = CGFloat(198)
  static let duration = 1.0
  
  private let skeletonColor = UIColor(rgb: 0xF7F7F7)
  
  private lazy var animatingView: UIView = {
    let view = UIView()
    view.backgroundColor = skeletonColor
    view.mask = MoviewSkeletonMaskView()
    view.layer.addSublayer(gradientLayer)
    return view
  }()

  private lazy var gradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [skeletonColor.cgColor,
                            skeletonColor.darker(by: 0.025).cgColor,
                            skeletonColor.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    gradientLayer.isHidden = true
    return gradientLayer
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    contentView.addSubview(animatingView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()

  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    animatingView.frame = contentView.bounds
    animatingView.mask?.frame = animatingView.bounds
    
    if gradientLayer.frame != animatingView.layer.bounds {
      gradientLayer.frame = animatingView.layer.bounds
      if (!gradientLayer.isHidden) {
        stopAnimation()
        startAnimation()
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    stopAnimation()
  }
  
  func stopAnimation() {
    gradientLayer.removeAllAnimations()
    gradientLayer.isHidden = true
  }
  
  func startAnimation() {
    gradientLayer.isHidden = false

    let gradientMove = CABasicAnimation()
    gradientMove.fromValue = CATransform3DTranslate(CATransform3DIdentity, -gradientLayer.bounds.width, 0, 0)
    gradientMove.toValue = CATransform3DTranslate(CATransform3DIdentity, 2*gradientLayer.bounds.width, 0, 0)
    gradientMove.keyPath = #keyPath(CALayer.transform)
    gradientMove.duration = MovieSkeletonCell.duration
    gradientMove.repeatCount = .greatestFiniteMagnitude
    gradientMove.timingFunction = CAMediaTimingFunction(name: .easeIn)
    
    gradientLayer.add(gradientMove, forKey: "skeleton")
  }
  
}

extension MovieSkeletonCell: Reusable { }
