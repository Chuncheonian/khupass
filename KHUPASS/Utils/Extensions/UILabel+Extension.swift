//
//  UILabel+Extension.swift
//  KHUPASS
//
//  Created by dykoon on 2021/11/21.
//

import UIKit

extension UILabel {
  func setLinespace(spacing: CGFloat) {
    if let text = self.text {
      let attributeString = NSMutableAttributedString(string: text)
      let style = NSMutableParagraphStyle()
      style.lineSpacing = spacing
      attributeString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
      self.attributedText = attributeString
    }
  }
}
