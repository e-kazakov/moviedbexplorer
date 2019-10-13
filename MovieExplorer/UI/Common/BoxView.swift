//
//  BoxView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/16/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class BoxView: UIView {
  init(_ wrapped: UIView, inset: UIEdgeInsets) {
    super.init(frame: .zero)
    
    addSubview(wrapped)
    wrapped.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      wrapped.topAnchor.constraint(equalTo: topAnchor, constant: inset.top),
      wrapped.leftAnchor.constraint(equalTo: leftAnchor, constant: inset.left),
      wrapped.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset.right),
      wrapped.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset.bottom),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
