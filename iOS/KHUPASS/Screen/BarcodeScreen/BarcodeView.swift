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
  
  lazy var camearaButton = BottomButton(title: "바코드 촬영")
   
  // MARK: - life cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    configUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - method
  
  private func configUI() {
    [titleLabel, subLabel, creditCardImageView, pigTailedArrowAnimation, camearaButton].forEach {
      addSubview($0)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(14)
      make.leading.equalToSuperview().offset(16)
    }
    
    subLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
      make.leading.equalTo(titleLabel.snp.leading)
    }
    
    creditCardImageView.snp.makeConstraints { make in
      make.top.equalTo(subLabel.snp.bottom).offset(80)
      make.centerX.equalToSuperview()
    }
  
    pigTailedArrowAnimation.play()
    pigTailedArrowAnimation.snp.makeConstraints { make in
      make.top.equalTo(creditCardImageView.snp.bottom).offset(-40)
      make.leading.equalTo(creditCardImageView.snp.leading).offset(50)
    }

    camearaButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(32)
      make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-40)
      make.trailing.equalToSuperview().offset(-32)
    }
  }
}
