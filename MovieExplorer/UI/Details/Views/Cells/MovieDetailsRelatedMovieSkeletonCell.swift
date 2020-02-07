//
//  MovieDetailsRelatedMovieSkeletonCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 1/6/20.
//  Copyright © 2020 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsRelatedMovieSkeletonCell: UICollectionViewCell {
  
  static let duration = 1.0
  
  private let skeletonColor = UIColor.appSkeleton
  
  private let animatingViewMask = MovieDetailsRelatedMovieSkeletonMaskView()
  
  private lazy var animatingView: UIView = {
    let view = UIView()
    view.backgroundColor = skeletonColor
    view.mask = animatingViewMask
    view.layer.addSublayer(gradientLayer)
    return view
  }()

  private lazy var gradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
    gradientLayer.isHidden = true
    configureSkeletonColors(gradientLayer)
    return gradientLayer
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(animatingView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
  
  override func didMoveToWindow() {
    super.didMoveToWindow()

    if let _ = window {
      startAnimation()
    } else {
      stopAnimation()
    }
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      stopAnimation()
      configureSkeletonColors(gradientLayer)
      startAnimation()
    }
  }
  
  private func configureSkeletonColors(_ gradientLayer: CAGradientLayer) {
    gradientLayer.colors = [
      skeletonColor.cgColor,
      traitCollection.userInterfaceStyle == .dark
        ? skeletonColor.lighter(by: 0.05).cgColor
        : skeletonColor.darker(by: 0.025).cgColor,
      skeletonColor.cgColor
    ]
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
    // Start every skeleton animation at the same time regardless of when animation was created
    gradientMove.beginTime = 1
    
    gradientLayer.add(gradientMove, forKey: "skeleton")
  }
}

extension MovieDetailsRelatedMovieSkeletonCell: SizePreferrable {
  static func preferredSize(inContainer containerSize: CGSize) -> CGSize {
    CGSize(width: 125, height: containerSize.height)
  }
}
