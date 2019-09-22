//
//  URLSessionAPIClient.swift
//  MovieExplorer
//
//  Created by Evgeny Kazakov on 9/8/18.
//  Copyright © 2018 Evgeny Kazakov. All rights reserved.
//

import Foundation

class URLSessionAPIClient: APIClient {

  static let apiKeyQueryItemName = "api_key"

  private let urlSession: URLSessionProtocol
  private let serverConfig: MovieDBServerConfig
  private let jsonDecoder: JSONDecoder

  init(serverConfig: MovieDBServerConfig, urlSession: URLSessionProtocol) {
    self.serverConfig = serverConfig
    self.urlSession = urlSession
    jsonDecoder = JSONDecoder()
  }

  @discardableResult
  func fetch<T: Decodable>(request: URLRequest,
                           callback: @escaping (Result<T, APIError>) -> Void) -> Disposable {
    return fetch(request: request, parse: jsonParser(), callback: callback)
  }

  @discardableResult
  func fetch(request: URLRequest, callback: @escaping (Result<Void, APIError>) -> Void) -> Disposable {
    return fetch(request: request, parse: voidParser(), callback: callback)
  }
  
  @discardableResult
  private func fetch<T>(request: URLRequest,
                        parse: @escaping (Data?) -> Result<T, ParsingError>,
                        callback: @escaping (Result<T, APIError>) -> Void) -> Disposable {
    let isCancelled = Atomic(value: false)
    let task = urlSession.dataTask(
      with: configure(request),
      completionHandler: dataTaskCompletionHandler(isCancelled: isCancelled,
                                                   parse: parse,
                                                   callback: callback)
    )
    task.resume()

    return ClosureDisposable {
      isCancelled.set(true)
      task.cancel()
    }
  }

  private func dataTaskCompletionHandler<T>(
    isCancelled: Atomic<Bool>,
    parse: @escaping (Data?) -> Result<T, ParsingError>,
    callback: @escaping (Result<T, APIError>) -> Void
  ) -> (Data?, URLResponse?, Error?) -> Void {
    return { data, response, error in
      guard !isCancelled.value else { return }

      if let error = error {
        callback(.failure(.network(inner: error)))
      } else {
        let parsingResult = parse(data).mapError(APIError.parsing(inner:))
        callback(parsingResult)
      }
    }
  }

  private func configure(_ request: URLRequest) -> URLRequest {
    var req = request
    req.url = URL(string: request.url!.absoluteString, relativeTo: serverConfig.apiBase)
    req.appendQueryItem(URLQueryItem(name: URLSessionAPIClient.apiKeyQueryItemName, value: serverConfig.apiKey))
    return req
  }

  // MARK: - Parsers
  
  private func jsonParser<T: Decodable>() -> (Data?) -> Result<T, ParsingError> {
    return { [jsonDecoder] data in
      
      guard let data = data else {
        return .failure(.noData)
      }
      
      do {
        let parsedData = try jsonDecoder.decode(T.self, from: data)
        return .success(parsedData)
      } catch {
        return .failure(.jsonDecoding(inner: error))
      }
    }
  }
  
  private func voidParser() -> (Data?) -> Result<Void, ParsingError> {
    return { _ in
      .success(empty)
    }
  }
  
}

private let empty: Void = ()
