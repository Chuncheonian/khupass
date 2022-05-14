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
    backgroundColor = .white
    configUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - method
  
  private func configUI() {
    [titleLabel, doneAnimation, descriptionLabel, moveWalletButton].forEach {
      addSubview($0)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    doneAnimation.play()
    doneAnimation.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(titleLabel.snp.top).offset(-15)
    }
    
    descriptionLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
    }
    
    moveWalletButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(32)
      make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-40)
      make.trailing.equalToSuperview().offset(-32)
    }
  }
}
