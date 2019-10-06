//
//  MovieSearchEmptyView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 07.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieSearchEmptyView: UIView {
  
  private let messageLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    label.textAlignment = .center
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
    style()
    
    messageLabel.text = "No movies found"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    addSubview(messageLabel)
    
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      messageLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      messageLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      messageLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
      messageLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
    ])
  }
  
  private func style() {
    backgroundColor = .appBackground
  }
  
}

#if DEBUG
import SwiftUI

struct MovieSearchEmptyViewPreview: UIViewRepresentable {
  
  func makeUIView(context: Context) -> MovieSearchEmptyView {
    return MovieSearchEmptyView()
  }
  
  func updateUIView(_ uiView: MovieSearchEmptyView, context: Context) {
  }
  
}

struct MovieSearchEmptyView_PreviewProvider: PreviewProvider {
  
  static var previews: some View {
    Group {
      MovieSearchEmptyViewPreview()
        .edgesIgnoringSafeArea([.top, .bottom])
      MovieSearchEmptyViewPreview()
        .edgesIgnoringSafeArea([.top, .bottom])
        .colorScheme(.dark)
    }
  }
  
}

#endif
