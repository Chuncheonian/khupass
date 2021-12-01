//
//  IntroController.swift
//  KHUPASS
//
//  Created by dykoon on 2021/11/21.
//

import UIKit
import SnapKit
import Then

class IntroController: UIViewController {
  
  // MARK: - Properties
  
  private let logoImageView = UIImageView().then {
    $0.image = UIImage(named: "logo-2")
    $0.contentMode = .scaleAspectFill
    $0.alpha = 0.0
  }
  
  private let contentLabel = UILabel().then {
    $0.text = "학생증이 없어도\n경희대 열람실을 편하게"
    $0.numberOfLines = 2
    $0.setLinespace(spacing: 15)
    $0.alpha = 0.0
    $0.textColor = .init(white: 0, alpha: 0.8)
    $0.textAlignment = .center
    $0.font = UIFont.nanumGothic(size: 33, family: .extrabold)
  }
  
  private lazy var startButton = UIButton(type: .system).then {
    $0.backgroundColor = .khuBlue
    $0.setTitle("시작하기", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont.nanumGothic(size: 17, family: .bold)
    $0.snp.makeConstraints { make in
      make.width.equalTo(311)
      make.height.equalTo(50)
    }
    $0.layer.cornerRadius = 10
    $0.alpha = 0.0
    $0.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    layoutSubviews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animate()
  }
  
  // MARK: - Actions
  
  @objc private func didTapStartButton() {
    let controller = BarcodeController()
    self.navigationController?.pushViewController(controller, animated: true)
  }
  
  // MARK: - Helpers
  
  private func layoutSubviews() {
    view.addSubview(logoImageView)
    logoImageView.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
      make.centerX.equalToSuperview()
    }
    
    view.addSubview(contentLabel)
    contentLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(40)
    }
    
    view.addSubview(startButton)
    startButton.snp.makeConstraints { make in
      make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(32)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-32)
    }
  }
  
  private func animate() {
    UIViewPropertyAnimator(duration: 0.8, curve: .easeInOut) {
      self.logoImageView.alpha = 1.0
      self.logoImageView.snp.updateConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(0)
      }
      self.view.layoutIfNeeded()
    }.startAnimation()
    
    UIViewPropertyAnimator(duration: 0.8, curve: .easeOut) {
      self.contentLabel.alpha = 1.0
      self.contentLabel.snp.updateConstraints { make in
        make.centerY.equalToSuperview().offset(0)
      }
      self.view.layoutIfNeeded()
    }.startAnimation(afterDelay: 0.55)
    
    UIViewPropertyAnimator(duration: 0.7, curve: .easeOut) {
      self.startButton.alpha = 1.0
      self.startButton.snp.updateConstraints { make in
        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-40)
      }
      self.view.layoutIfNeeded()
    }.startAnimation(afterDelay: 0.7)
  }
}
