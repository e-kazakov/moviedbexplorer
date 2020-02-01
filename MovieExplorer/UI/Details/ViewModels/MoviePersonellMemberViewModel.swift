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
  var initials: String { get }
  var occupation: String { get }
  var photo: ImageViewModel? { get }
}

class MoviePersonellMemberViewModelImpl: MoviePersonellMemberViewModel {
  
  let name: String
  let occupation: String
  let photo: ImageViewModel?
  let initials: String
  
  init(name: String, occupation: String, photo: ImageViewModel?, initials: String) {
    self.name = name
    self.occupation = occupation
    self.photo = photo
    self.initials = initials
  }
}
