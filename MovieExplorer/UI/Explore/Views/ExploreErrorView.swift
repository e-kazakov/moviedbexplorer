//
//  ExploreErrorView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 22.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class ExploreErrorView: UIView {
  
  var onRetry: (() -> Void)?
  
  private let reloadButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Retry", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.tintColor = .black
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 1.0
    return button
  }()
  
  private let titleLabel = UILabel.Style.errorTitle(UILabel())
  private let messageLabel = UILabel.Style.errorMessage(UILabel())
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    addSubview(reloadButton)
    addSubview(titleLabel)
    addSubview(messageLabel)
    
    setupConstraints()
    
    reloadButton.addTarget(self, action: #selector(onReloadButtonTap), for: .touchUpInside)
    titleLabel.text = "Failed to load movies"
    messageLabel.text = "Try loading again"
  }
  
  private func setupConstraints() {
    reloadButton.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false

    let buttonOffsets = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    NSLayoutConstraint.activate([
      reloadButton.leftAnchor.constraint(equalTo: leftAnchor, constant: buttonOffsets.left),
      reloadButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -buttonOffsets.right),
      reloadButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -buttonOffsets.bottom),
      reloadButton.heightAnchor.constraint(equalToConstant: 50),
      
      titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 64),
      titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 32),
      titleLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -32),
      
      messageLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 64),
      messageLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 32),
      messageLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -32),
    ])
  }
  
  @objc
  private func onReloadButtonTap() {
    onRetry?()
  }
}
