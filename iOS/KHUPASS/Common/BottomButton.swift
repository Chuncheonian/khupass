//
//  BottomButton.swift
//  KHUPASS
//
//  Created by dykoon on 2022/05/13.
//

import UIKit

final class BottomButton: UIButton {
  
  init(title: String, alpha: CGFloat = 1.0) {
    super.init(frame: .zero)
    backgroundColor = .khuBlue
    setTitle(title, for: .normal)
    setTitleColor(.white, for: .normal)
    titleLabel?.font = UIFont.nanumGothic(size: 17, family: .bold)
    layer.cornerRadius = 10
    self.alpha = alpha
    
    snp.makeConstraints { make in
      make.width.equalTo(311)
      make.height.equalTo(50)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
