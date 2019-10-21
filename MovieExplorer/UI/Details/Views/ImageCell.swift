//
//  ImageCell.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/22/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.tintColor = .appPlaceholder
    return imageView
  }()
  
  private var reuseDisposable: Disposable?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(imageView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = contentView.bounds
  }
  
  func configure(with imageModel: ImageViewModel) {
    reuseDisposable = imageView.mve.setImage(imageModel)
    imageModel.load()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    reuseDisposable?.dispose()
    reuseDisposable = nil
  }
  
}
