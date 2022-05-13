//
//  IntroController.swift
//  KHUPASS
//
//  Created by dykoon on 2021/11/21.
//

import UIKit

import SnapKit
import Then

final class IntroController: UIViewController {
  
  // MARK: - property
  
  private let introView = IntroView()
  
  // MARK: - life cycle
  
  override func loadView() {
    super.loadView()
    self.view = introView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    introView.startButton.addTarget(
      self,
      action: #selector(didTapStartButton),
      for: .touchUpInside
    )
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animate()
  }
  
  // MARK: - action
  
  @objc private func didTapStartButton() {
    let controller = BarcodeController()
    navigationController?.pushViewController(controller, animated: true)
  }
  
  // MARK: - method
  
  private func animate() {
    UIViewPropertyAnimator(duration: 0.8, curve: .easeInOut) {
      self.introView.logoImageView.alpha = 1.0
      self.introView.logoImageView.snp.updateConstraints { make in
        make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      }
      self.view.layoutIfNeeded()
    }.startAnimation()

    UIViewPropertyAnimator(duration: 0.8, curve: .easeOut) {
      self.introView.contentLabel.alpha = 1.0
      self.introView.contentLabel.snp.updateConstraints { make in
        make.centerY.equalToSuperview()
      }
      self.view.layoutIfNeeded()
    }.startAnimation(afterDelay: 0.55)

    UIViewPropertyAnimator(duration: 0.7, curve: .easeOut) {
      self.introView.startButton.alpha = 1.0
      self.introView.startButton.snp.updateConstraints { make in
        make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-40)
      }
      self.view.layoutIfNeeded()
    }.startAnimation(afterDelay: 0.7)
  }
}
