//
//  MovieFailedCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 29.06.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieFailedCell: UICollectionViewCell {
  
  var onRetry: (() -> Void)?
  
  var message: String? {
    get {
      messageLabel.text
    }
    set {
      messageLabel.text = newValue
    }
  }
  
  private let retryButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle(L10n.Common.MoviesList.reloadButton, for: .normal)
    button.setTitleColor(.appLabel, for: .normal)
    button.tintColor = .label
    return button
  }()
  
  private let messageLabel = UILabel.Style.errorMessage(UILabel())
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    contentView.addSubview(messageLabel)
    contentView.addSubview(retryButton)
    
    setupConstraints()
    
    messageLabel.text = L10n.Common.MoviesList.moreFailedMessage
    retryButton.addTarget(self, action: #selector(onRetryButtonTapped), for: .touchUpInside)
  }
  
  private func setupConstraints() {
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    retryButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      messageLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
      messageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
      messageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
      
      retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
      retryButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
      retryButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
      retryButton.heightAnchor.constraint(equalToConstant: 50),
    ])
  }
  
  @objc
  private func onRetryButtonTapped() {
    onRetry?()
  }
}

extension MovieFailedCell: SizePreferrable {
  static func preferredSize(inContainer containerSize: CGSize) -> CGSize {
    CGSize(width: containerSize.width, height: 198)
  }
}
