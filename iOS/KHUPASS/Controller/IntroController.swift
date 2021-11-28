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
    $0.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    layoutSubviews()
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
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      make.centerX.equalToSuperview()
    }
    
    view.addSubview(startButton)
    startButton.snp.makeConstraints { make in
      make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(32)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-40)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-32)
    }
  }
}
