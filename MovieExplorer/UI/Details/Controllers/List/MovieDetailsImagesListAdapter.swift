//
//  MovieDetailsImagesAdapter.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/22/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import UIKit

class MovieDetailsImagesListAdapter {
  
  func postersList(images: [ImageViewModel]) -> List {
    var section = ListSection(images.map { ImageListItem(image: $0, style: .movieDetailsPoster) })
    section.minimumInteritemSpacing = 16
    section.minimumLineSpacing = 16
    section.inset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    return List(sections: [section])
  }
  
  func backdropsList(images: [ImageViewModel]) -> List {
    var section = ListSection(images.map { ImageListItem(image: $0, style: .movieDetailsBackdrop) })
    section.minimumInteritemSpacing = 8
    section.minimumLineSpacing = 8
    section.inset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    return List(sections: [section])
  }
  
}
