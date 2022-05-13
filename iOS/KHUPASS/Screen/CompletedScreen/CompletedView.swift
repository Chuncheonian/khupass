//
//  CompletedView.swift
//  KHUPASS
//
//  Created by dykoon on 2022/04/20.
//

import UIKit

import Lottie

final class CompletedView: UIView {
  
  // MARK: - property
  
  let doneAnimation = AnimationView(name: "972-done").then {
    $0.contentMode = .scaleAspectFill
  }
  
  let titleLabel = UILabel().then {
    $0.text = "감사합니다!"
    $0.font = UIFont.nanumGothic(size: 30, family: .bold)
    $0.textColor = .black
    $0.alpha = 0.0
  }
  
  let descriptionLabel = UILabel().then {
    $0.text = "발급된 패스는 '지갑' 앱에서 확인할 수 있습니다."
    $0.font = UIFont.nanumGothic(size: 14, family: .bold)
    $0.textColor = .init(white: 0, alpha: 0.6)
    $0.alpha = 0.0
  }
  
  lazy var moveWalletButton = BottomButton(title: "지갑 앱 실행", alpha: 0.0)
   
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
    self.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    self.addSubview(self.doneAnimation)
    self.doneAnimation.play()
    self.doneAnimation.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(self.titleLabel.snp.top).offset(-15)
    }
    
    self.addSubview(self.descriptionLabel)
    self.descriptionLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
    }
    
    self.addSubview(self.moveWalletButton)
    self.moveWalletButton.snp.makeConstraints { make in
      make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(32)
      make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-40)
      make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-32)
    }
  }
}
