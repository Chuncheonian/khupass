//
//  UIFont+Extension.swift
//  KHUPASS
//
//  Created by dykoon on 2021/11/21.
//

import UIKit

extension UIFont {
  
  enum Family: String {
    case regular = ""
    case bold = "Bold"
    case extrabold = "ExtraBold"
  }
  
  static func nanumGothic(size: CGFloat = 10, family: Family = .regular) -> UIFont {
    guard let font = UIFont(name: "NanumGothicOTF\(family)", size: size) else {
      return UIFont(name: "NanumGothicOTF", size: size)!
    }
    return font
  }
}
