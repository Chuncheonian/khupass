//
//  PassController+Error.swift
//  KHUPASS
//
//  Created by dykoon on 2022/05/12.
//

import Foundation

extension PassController {
  enum PassError: Error, LocalizedError {
    case existAlreadyPass
    case invalidDevice
    
    var errorDescription: String? {
      switch self {
      case .existAlreadyPass:
        return NSLocalizedString("이미 발급되었습니다.\n'지갑' 앱에서 확인해주세요.", comment: "Exist Pass already")
      case .invalidDevice:
        return NSLocalizedString("Pass는 iPhone에서만 발급받을 수 있습니다.", comment: "Invalid Device")
      }
    }
  }
}
