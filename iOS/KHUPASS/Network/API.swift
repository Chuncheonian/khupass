//
//  API.swift
//  KHUPASS
//
//  Created by dykoon on 2022/04/25.
//

import Foundation
import PassKit

struct API {
  
  static func fetchPass(barcodeValue value: String) async throws -> PKPass {
    guard let url = URL(string: "\(BASE_URL)?barcodeValue=\(value)") else {
      throw NetworkError.invalidURL
    }
    
    let urlSession: URLSession = {
      let config: URLSessionConfiguration = .default
      config.timeoutIntervalForRequest = 30
      return URLSession(configuration: config)
    }()
    
    let (data, response) = try await urlSession.data(from: url)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw NetworkError.serverError
    }
    
    do {
      return try PKPass(data: data)
    } catch {
      throw NetworkError.invalidData
    }
  }
}
