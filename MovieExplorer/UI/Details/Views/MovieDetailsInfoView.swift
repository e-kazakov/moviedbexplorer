//
//  MovieDetailsInfoView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 08.10.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

private extension UICollectionView {
  static var detailsCollectionView: UICollectionView {
    let listView = UICollectionView.horizontalList
    listView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    listView.backgroundColor = .appBackground
    return listView
  }
}

class MovieDetailsInfoView: UIView {

  let crewListView = UICollectionView.detailsCollectionView
  
  let castListView = UICollectionView.detailsCollectionView
  
  let postersListView = UICollectionView.detailsCollectionView
  
  let backdropsListView = UICollectionView.detailsCollectionView
  
  let nameLabel = UILabel.Style.title(UILabel())
  
  let overviewLabel = UILabel.Style.info(UILabel())
  
  let genresLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.preferredFont(forTextStyle: .footnote)
    return label
  }()
  
  let taglineLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    let f = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
    let d = f.fontDescriptor.withSymbolicTraits(.traitItalic)!
    label.font = UIFont(descriptor: d, size: f.pointSize)
    return label
  }()
  
  let releaseYearLabel = UILabel.Style.releaseYear(UILabel())
  
  let durationLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
    style()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSubviews() {
    postersListView.translatesAutoresizingMaskIntoConstraints = false
    backdropsListView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    genresLabel.translatesAutoresizingMaskIntoConstraints = false
    taglineLabel.translatesAutoresizingMaskIntoConstraints = false
    overviewLabel.translatesAutoresizingMaskIntoConstraints = false
    releaseYearLabel.translatesAutoresizingMaskIntoConstraints = false
    durationLabel.translatesAutoresizingMaskIntoConstraints = false
    castListView.translatesAutoresizingMaskIntoConstraints = false
    crewListView.translatesAutoresizingMaskIntoConstraints = false
    
    let overviewStack = UIStackView(arrangedSubviews: [taglineLabel, overviewLabel])
    overviewStack.translatesAutoresizingMaskIntoConstraints = false
    overviewStack.axis = .vertical
    overviewStack.spacing = 8
    
    let contentStack = UIStackView(arrangedSubviews: [
      BoxView(nameLabel, inset: .horizontal(16)),
      BoxView(overviewStack, inset: .horizontal(16)),
      backdropsListView,
      castListView,
      crewListView
    ])
    contentStack.translatesAutoresizingMaskIntoConstraints = false
    contentStack.axis = .vertical
    contentStack.spacing = 16

    addSubview(postersListView)
    addSubview(contentStack)
    addSubview(releaseYearLabel)
    addSubview(durationLabel)
    addSubview(genresLabel)

    NSLayoutConstraint.activate([
      postersListView.topAnchor.constraint(equalTo: self.topAnchor),
      postersListView.leftAnchor.constraint(equalTo: self.leftAnchor),
      postersListView.rightAnchor.constraint(equalTo: self.rightAnchor),
      postersListView.heightAnchor.constraint(equalToConstant: 420),

      releaseYearLabel.topAnchor.constraint(equalTo: postersListView.bottomAnchor, constant: 30),
      releaseYearLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
      releaseYearLabel.widthAnchor.constraint(equalToConstant: 60),
      
      durationLabel.centerYAnchor.constraint(equalTo: releaseYearLabel.centerYAnchor),
      durationLabel.leftAnchor.constraint(equalTo: releaseYearLabel.rightAnchor, constant: 10),
      
      genresLabel.topAnchor.constraint(equalTo: releaseYearLabel.bottomAnchor, constant: 8),
      genresLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
      genresLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),

      contentStack.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 16),
      contentStack.leftAnchor.constraint(equalTo: self.leftAnchor),
      contentStack.rightAnchor.constraint(equalTo: self.rightAnchor),
      contentStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),

      backdropsListView.heightAnchor.constraint(equalToConstant: 152),
      
      castListView.heightAnchor.constraint(equalToConstant: 240),
      crewListView.heightAnchor.constraint(equalToConstant: 240),
    ])
  }
  
  private func style() {
    UILabel.Style.releaseYear(releaseYearLabel)
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
      style()
    }
  }
}
