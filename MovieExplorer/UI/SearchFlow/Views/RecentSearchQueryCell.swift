//
//  RecentSearchQueryCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 20.07.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

final class RecentSearchQueryCell: UICollectionViewCell {
  
  var text: String? {
    get {
      return label.text
    }
    set {
      label.text = newValue
    }
  }
  
  private let label = UILabel()
  private let separator = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
    style()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    label.translatesAutoresizingMaskIntoConstraints = false
    separator.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(label)
    contentView.addSubview(separator)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: topAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor),
      label.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
      label.rightAnchor.constraint(equalTo: rightAnchor),

      separator.heightAnchor.constraint(equalToConstant: 1.0/UIScreen.main.scale),
      separator.bottomAnchor.constraint(equalTo: bottomAnchor),
      separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
      separator.rightAnchor.constraint(equalTo: rightAnchor),
    ])
  }
  
  private func style() {
    backgroundColor = .appSecondaryBackground
    separator.backgroundColor = .appSeparator
  }
}
extension RecentSearchQueryCell: SizePreferrable {
  static func preferredSize(inContainer containerSize: CGSize) -> CGSize {
    CGSize(width: containerSize.width, height: 50)
  }
}
  
#if DEBUG
import SwiftUI

struct RecentSearchQueryCellPreview: UIViewRepresentable {
  
  let state: String
  
  func makeUIView(context: Context) -> RecentSearchQueryCell {
    let cell = RecentSearchQueryCell()
    cell.text = state
    return cell
  }
  
  func updateUIView(_ uiView: RecentSearchQueryCell, context: Context) {
  }

}

struct RecentSearchQueryCell_PreviewProvider: PreviewProvider {
  
  static var previews: some View {
    Group {
      Group {
        VStack(alignment: .leading, spacing: 0) {
          RecentSearchQueryCellPreview(state: "Avengers")
          RecentSearchQueryCellPreview(state: "Matrix")
        }
        .previewLayout(.fixed(width: 375,
                              height: 2 * RecentSearchQueryCell.preferredSize(inContainer: .zero).height))
      }
      .previewDisplayName("Light")

      Group {
        VStack(alignment: .leading, spacing: 0) {
          RecentSearchQueryCellPreview(state: "Avengers")
          RecentSearchQueryCellPreview(state: "Matrix")
        }
        .previewLayout(.fixed(width: 375,
                              height: 2 * RecentSearchQueryCell.preferredSize(inContainer: .zero).height))
      }
      .colorScheme(.dark)
      .previewDisplayName("Dark")
    }
  }
}

#endif
