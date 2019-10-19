//
//  CrewMemberViewModel.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 10/19/19.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol MoviePersonellMemberViewModel {
  var name: String { get }
  var occupation: String { get }
  var photo: ImageViewModel { get }
}

class MoviePersonellMemberViewModelImpl: MoviePersonellMemberViewModel {
  
  let name: String
  let occupation: String
  let photo: ImageViewModel
  
  init(name: String, occupation: String, photo: ImageViewModel) {
    self.name = name
    self.occupation = occupation
    self.photo = photo
  }
  
}
