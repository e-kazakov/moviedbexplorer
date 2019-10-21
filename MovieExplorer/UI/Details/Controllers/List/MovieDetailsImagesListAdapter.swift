//
//  MovieDetailsImagesAdapter.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/22/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

class MovieDetailsImagesListAdapter {
  
  func postersList(images: [ImageViewModel]) -> List {
    var section = ListSection(images.map(MovieDetailsPosterListItem.init))
    section.minimumInteritemSpacing = 16
    section.minimumLineSpacing = 16
    
    return List(sections: [section])
  }
  
  func backdropsList(images: [ImageViewModel]) -> List {
    var section = ListSection(images.map(MovieDetailsBackdropListItem.init))
    section.minimumInteritemSpacing = 8
    section.minimumLineSpacing = 8

    return List(sections: [section])
  }
  
}
