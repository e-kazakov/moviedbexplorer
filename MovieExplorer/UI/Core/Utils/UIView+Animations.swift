//
//  UIView+Animations.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 06.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension MVE where Base: UIView {
  
  func crossDissolveTransition(
    duration: TimeInterval = CATransaction.animationDuration(),
    _ transition: @escaping () -> Void
  ) {
    UIView.transition(
      with: base,
      duration: duration, options: [.transitionCrossDissolve],
      animations: transition,
      completion: nil
    )
  }
  
}
