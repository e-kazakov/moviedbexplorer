//
//  ImageListItem+MovieDetails.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/26/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

extension ImageListItem.Style {
  
  static var movieDetailsPoster: ImageListItem.Style {
    ImageListItem.Style(aspectRatio: .poster, cornerRadius: 8)
  }

  static var movieDetailsBackdrop: ImageListItem.Style {
    ImageListItem.Style(aspectRatio: .backdrop, cornerRadius: 4)
  }
}
