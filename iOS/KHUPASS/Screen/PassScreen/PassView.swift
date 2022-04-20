//
//  PassView.swift
//  KHUPASS
//
//  Created by dykoon on 2022/04/20.
//

import UIKit
import PassKit

import NVActivityIndicatorView

final class PassView: UIView {
  
  // MARK: - property
  
  let titleLabel = UILabel().then {
    $0.text = "스캔이 완료되었습니다."
    $0.font = UIFont.nanumGothic(size: 25, family: .extrabold)
  }
  
  let subLabel = UILabel().then {
    $0.text = "Apple Wallet에 보관하기 위해\n아래의 버튼을 클릭해주세요."
    $0.font = UIFont.nanumGothic(size: 14, family: .bold)
    $0.numberOfLines = 0
    $0.setLinespace(spacing: 6)
    $0.textColor = .init(white: 0, alpha: 0.6)
  }
  
  let passImageView = UIImageView().then {
    $0.image = UIImage(named: "pass")
    $0.contentMode = .scaleAspectFill
  }
  
  let passButton = PKAddPassButton()
  
  let indicator = NVActivityIndicatorView(
    frame: CGRect(x: 0, y: 0, width: 50, height: 50),
    type: .circleStrokeSpin,
    color: .black,
    padding: 0
  )
   
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
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(14)
      make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(16)
    }
    
    self.addSubview(subLabel)
    self.subLabel.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
      make.leading.equalTo(self.titleLabel.snp.leading)
    }
    
    self.addSubview(passImageView)
    self.passImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.subLabel.snp.bottom).offset(25)
    }
    
    self.addSubview(passButton)
    self.passButton.snp.makeConstraints { make in
      make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(32)
      make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-40)
      make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).offset(-32)
      make.height.equalTo(50)
    }
    
    self.addSubview(indicator)
    self.indicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
