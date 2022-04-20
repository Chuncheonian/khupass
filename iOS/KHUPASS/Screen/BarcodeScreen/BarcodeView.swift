//
//  BarcodeView.swift
//  KHUPASS
//
//  Created by dykoon on 2022/04/20.
//

import UIKit
import Lottie

final class BarcodeView: UIView {
  
  // MARK: - property
  
  let titleLabel = UILabel().then {
    $0.text = "학생증을 준비해주세요."
    $0.font = UIFont.nanumGothic(size: 25, family: .extrabold)
  }
  
  let subLabel = UILabel().then {
    $0.text = "바코드 생성을 위해\n학생증 뒷면의 바코드 촬영이 필요합니다."
    $0.font = UIFont.nanumGothic(size: 14, family: .bold)
    $0.numberOfLines = 0
    $0.setLinespace(spacing: 6)
    $0.textColor = .init(white: 0, alpha: 0.6)
  }
  
  let creditCardImageView = UIImageView().then {
    $0.image = UIImage(named: "CreditCard")
    $0.contentMode = .scaleAspectFill
  }
  
  let pigTailedArrowAnimation = AnimationView(name: "79064-arrows").then {
    $0.contentMode = .scaleAspectFill
    $0.loopMode = .autoReverse
    $0.animationSpeed = 0.4
    $0.transform = CGAffineTransform(rotationAngle: .pi * 1.72)
  }
  
  lazy var camearaButton = UIButton(type: .system).then {
    $0.backgroundColor = .khuBlue
    $0.setTitle("바코드 촬영", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont.nanumGothic(size: 17, family: .bold)
    $0.snp.makeConstraints { make in
      make.width.equalTo(311)
      make.height.equalTo(50)
    }
    $0.layer.cornerRadius = 10
  }
   
  // MARK: - life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.configUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - method
  
  private func configUI() {

    self.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(14)
      make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(16)
    }
    
    self.addSubview(subLabel)
    subLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
      make.leading.equalTo(titleLabel.snp.leading)
    }
    
    self.addSubview(creditCardImageView)
    creditCardImageView.snp.makeConstraints { make in
      make.top.equalTo(subLabel.snp.bottom).offset(80)
      make.centerX.equalToSuperview()
    }
  
    self.addSubview(pigTailedArrowAnimation)
    pigTailedArrowAnimation.play()
    pigTailedArrowAnimation.snp.makeConstraints { make in
      make.top.equalTo(creditCardImageView.snp.bottom).offset(-40)
      make.leading.equalTo(creditCardImageView.snp.leading).offset(50)
    }

    self.addSubview(camearaButton)
    camearaButton.snp.makeConstraints { make in
      make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(32)
      make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-40)
      make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-32)
    }
  }
}

