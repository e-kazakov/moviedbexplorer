//
//  MovieDetails.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 06.10.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol MovieDetailsPersonellMember {
  var name: String { get }
  var profilePhotoPath: String? { get }
  var occupation: String { get }
}

struct MovieDetails: Codable, Equatable {
  
  struct Images: Codable, Equatable {
    let backdrops: [Image]
    let posters: [Image]
  }
  
  struct CastMember: MovieDetailsPersonellMember, Codable, Equatable {
    let character: String
    let name: String
    let profilePhotoPath: String?
    
    var occupation: String { character }
    
    private enum CodingKeys: String, CodingKey {
      case character = "character"
      case name = "name"
      case profilePhotoPath = "profile_path"
    }
  }
  
  struct CrewMember: MovieDetailsPersonellMember, Codable, Equatable {
    let name: String
    let job: String
    let department: String
    let profilePhotoPath: String?
    
    var occupation: String { job }

    private enum CodingKeys: String, CodingKey {
      case name = "name"
      case job = "job"
      case department = "department"
      case profilePhotoPath = "profile_path"
    }
  }
  
  struct Credits: Codable, Equatable {
    let cast: [CastMember]
    let crew: [CrewMember]
  }
  
  struct Genre: Codable, Equatable {
    let id: Int
    let name: String
  }
  
  struct ExternalsIds: Codable, Equatable {
    let imdb: String?
    let facebook: String?
    let instagram: String?
    let twitter: String?
    
    private enum CodingKeys: String, CodingKey {
      case imdb = "imdb_id"
      case facebook = "facebook_id"
      case instagram = "instagram_id"
      case twitter = "twitter_id"
    }
  }
  
  let id: Int
  let posterPath: String?
  let title: String?
  let tagline: String?
  let releaseDate: String?
  let runtime: Int?
  let overview: String?
  
  let genres: [Genre]
  let images: Images
  let credits: Credits
  let externalIds: ExternalsIds
  
  private enum CodingKeys: String, CodingKey {
    case id = "id"
    case posterPath = "poster_path"
    case title = "title"
    case tagline = "tagline"
    case releaseDate = "release_date"
    case overview = "overview"
    case runtime = "runtime"
    case genres = "genres"
    case images = "images"
    case credits = "credits"
    case externalIds = "external_ids"
  }

}
