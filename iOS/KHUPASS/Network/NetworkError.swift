//
//  NetworkError.swift
//  KHUPASS
//
//  Created by dykoon on 2022/05/12.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case serverError
  case invalidData
}

extension NetworkError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return NSLocalizedString("서버에 오류가 생겼습니다.\n다시 한번 시도해주세요.", comment: "Invalid URL")
    case .serverError:
      return NSLocalizedString("서버에 오류가 생겼습니다.\n다시 한번 시도해주세요.", comment: "serverError")
    case .invalidData:
      return NSLocalizedString("Pass를 로드하지 못했습니다.\n다시 한번 시도해주세요.", comment: "Invalid Data")
    }
  }
}
