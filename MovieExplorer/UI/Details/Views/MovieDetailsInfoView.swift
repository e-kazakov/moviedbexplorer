//
//  MovieDetailsInfoView.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 08.10.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
  static var horizontal: UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return layout
  }
  
  static var vertical: UICollectionViewFlowLayout {
    UICollectionViewFlowLayout()
  }
}

extension UICollectionView {
  static var horizontalList: UICollectionView {
    UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.horizontal)
  }

  static var verticalList: UICollectionView {
    UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.vertical)
  }
}

class MovieDetailsInfoView: UIView {
  
  var posters: [ImageViewModel] = [] {
    didSet {
      updatePosters()
    }
  }
  
  var images: [ImageViewModel] = [] {
    didSet {
      updateImages()
    }
  }
  
  let crewListView: UICollectionView = {
    let listView = UICollectionView.horizontalList
    listView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    listView.backgroundColor = .appBackground
    return listView
  }()
  let castListView: UICollectionView = {
    let listView = UICollectionView.horizontalList
    listView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    listView.backgroundColor = .appBackground
    return listView
  }()
  
  private let postersScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    return scrollView
  }()
  private let postersStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 8
    return stackView
  }()

  private let backdropsImagesScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    return scrollView
  }()
  private let backdropsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 8
    return stackView
  }()

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
    postersScrollView.translatesAutoresizingMaskIntoConstraints = false
    postersStackView.translatesAutoresizingMaskIntoConstraints = false
    backdropsImagesScrollView.translatesAutoresizingMaskIntoConstraints = false
    backdropsStackView.translatesAutoresizingMaskIntoConstraints = false
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
      backdropsImagesScrollView,
      castListView,
      crewListView
    ])
    contentStack.translatesAutoresizingMaskIntoConstraints = false
    contentStack.axis = .vertical
    contentStack.spacing = 16

    addSubview(postersScrollView)
    addSubview(contentStack)
    addSubview(releaseYearLabel)
    addSubview(durationLabel)
    addSubview(genresLabel)

    postersScrollView.addSubview(postersStackView)
    backdropsImagesScrollView.addSubview(backdropsStackView)
    
    NSLayoutConstraint.activate([
      postersScrollView.topAnchor.constraint(equalTo: self.topAnchor),
      postersScrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
      postersScrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
      postersScrollView.heightAnchor.constraint(equalToConstant: 420),

      postersStackView.topAnchor.constraint(equalTo: postersScrollView.topAnchor),
      postersStackView.bottomAnchor.constraint(equalTo: postersScrollView.bottomAnchor),
      postersStackView.leftAnchor.constraint(equalTo: postersScrollView.leftAnchor),
      postersStackView.rightAnchor.constraint(equalTo: postersScrollView.rightAnchor),
      
      releaseYearLabel.topAnchor.constraint(equalTo: postersScrollView.bottomAnchor, constant: 30),
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

      backdropsImagesScrollView.heightAnchor.constraint(equalToConstant: 152),

      backdropsStackView.topAnchor.constraint(equalTo: backdropsImagesScrollView.topAnchor),
      backdropsStackView.bottomAnchor.constraint(equalTo: backdropsImagesScrollView.bottomAnchor),
      backdropsStackView.leftAnchor.constraint(equalTo: backdropsImagesScrollView.leftAnchor),
      backdropsStackView.rightAnchor.constraint(equalTo: backdropsImagesScrollView.rightAnchor),
      
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
  
  private func updatePosters() {
    postersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    let postersImageViews = posters.map { poster -> UIImageView in
      let posterView = createPoasterView()
      posterView.mve.setImage(poster)
      return posterView
    }
    postersImageViews.forEach(postersStackView.addArrangedSubview)
    
    posters.forEach { $0.load() }
    
    NSLayoutConstraint.activate(
      postersImageViews.flatMap { posterView in
        [
          posterView.heightAnchor.constraint(equalTo: postersScrollView.heightAnchor),
          posterView.widthAnchor.constraint(equalTo: posterView.heightAnchor, multiplier: 2.0/3.0),
        ]
      }
    )
  }
  
  private func updateImages() {
    backdropsImagesScrollView.isHidden = images.isEmpty

    backdropsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    let backdropsImageViews = images.map { poster -> UIImageView in
      let backdropView = createImageView()
      backdropView.mve.setImage(poster)
      return backdropView
    }
    backdropsImageViews.forEach(backdropsStackView.addArrangedSubview)

    images.forEach { $0.load() }

    NSLayoutConstraint.activate(
      backdropsImageViews.flatMap { imageView in
        [
          imageView.heightAnchor.constraint(equalTo: backdropsImagesScrollView.heightAnchor),
          imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 16.0/9.0),
        ]
      }
    )
  }
  
  private func createPoasterView() -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.tintColor = .appPlaceholder
    imageView.layer.cornerRadius = 8
    return imageView
  }
  
  private func createImageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.tintColor = .appPlaceholder
    imageView.layer.cornerRadius = 4
    return imageView
  }
}
