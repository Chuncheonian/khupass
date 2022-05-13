//
//  IntroView.swift
//  KHUPASS
//
//  Created by dykoon on 2022/04/20.
//

import UIKit

final class IntroView: UIView {
  
  // MARK: - property
  
  let logoImageView = UIImageView().then {
    $0.image = UIImage(named: "logo-2")
    $0.contentMode = .scaleAspectFill
    $0.alpha = 0.0
  }
  
  let contentLabel = UILabel().then {
    $0.text = "학생증이 없어도\n경희대 열람실을 편하게"
    $0.numberOfLines = 2
    $0.setLinespace(spacing: 15)
    $0.alpha = 0.0
    $0.textColor = .init(white: 0, alpha: 0.8)
    $0.textAlignment = .center
    $0.font = UIFont.nanumGothic(size: 30, family: .extrabold)
  }
  
  lazy var startButton = BottomButton(title: "시작하기", alpha: 0.0)
  
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
    self.addSubview(logoImageView)
    logoImageView.snp.makeConstraints { make in
      make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30)
      make.centerX.equalToSuperview()
    }
    
    self.addSubview(contentLabel)
    contentLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(40)
    }
    
    self.addSubview(startButton)
    startButton.snp.makeConstraints { make in
      make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(32)
      make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-10)
      make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-32)
    }
  }
}
