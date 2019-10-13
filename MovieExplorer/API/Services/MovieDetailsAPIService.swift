//
//  MovieDetailsAPIService.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 06.10.2019.
//  Copyright © 2019 Evgeny Kazakov. All rights reserved.
//

import Foundation

protocol MovieDetailsAPIService {
  
  @discardableResult
  func details(id: Int,
               callback: @escaping (Result<MovieDetails, APIError>) -> Void) -> Disposable
    
  @discardableResult
  func similar(id: Int,
               page: Int?,
               callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable
  
  @discardableResult
  func recommendations(id: Int,
                       page: Int?,
                       callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable
  
}

class MovieDetailsAPIServiceImpl: MovieDetailsAPIService {
  
  private let client: APIClient

  private let pageQueryParameter = "page"
  private let appendToResponseQueryParameter = "append_to_response"
  private let includeImageLanguageQueryParameter = "include_image_language"

  init(client: APIClient) {
    self.client = client
  }
  
  @discardableResult
  func details(id: Int,
               callback: @escaping (Result<MovieDetails, APIError>) -> Void) -> Disposable {
    let request = detailsRequest(id: id)
    return client.fetch(request: request, callback: callback)
  }
  
  @discardableResult
  func similar(id: Int,
               page: Int?,
               callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable {
    let request = similarRequest(id: id, page: page)
    return client.fetch(request: request, callback: callback)
  }
  
  @discardableResult
  func recommendations(id: Int,
                       page: Int?,
                       callback: @escaping (Result<APIPaginatedResponse<Movie>, APIError>) -> Void) -> Disposable {
    let request = recommendationsRequest(id: id, page: page)
    return client.fetch(request: request, callback: callback)
  }
  
  // MARK: Requests
  
  private func detailsRequest(id: Int) -> URLRequest {
    var queryParams: [String: String] = [:]
    queryParams[appendToResponseQueryParameter] = "images,credits,external_ids"
    queryParams[includeImageLanguageQueryParameter] = "en,null"
    
    var req = URLRequest(path: "3/movie/\(id)")
    req.appendRawQueryItems(queryParams)
    
    return req
  }

  private func similarRequest(id: Int, page: Int?) -> URLRequest {
    var queryParams: [String: String] = [:]
    queryParams[pageQueryParameter] = page.map(String.init)
    
    var req = URLRequest(path: "3/movie/\(id)/similar")
    req.appendRawQueryItems(queryParams)

    return req
  }

  private func recommendationsRequest(id: Int, page: Int?) -> URLRequest {
    var queryParams: [String: String] = [:]
    queryParams[pageQueryParameter] = page.map(String.init)
    
    var req = URLRequest(path: "3/movie/\(id)/recommendations")
    req.appendRawQueryItems(queryParams)

    return req
  }

  
}
