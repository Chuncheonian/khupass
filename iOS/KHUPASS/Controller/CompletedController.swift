//
//  CompletedController.swift
//  KHUPASS
//
//  Created by dykoon on 2021/12/01.
//

import UIKit
import Lottie

class CompletedController: UIViewController {

  // MARK: - Properties
  
  private let doneAnimation = AnimationView(name: "972-done").then {
    $0.contentMode = .scaleAspectFill
  }
  
  private let titleLabel = UILabel().then {
    $0.text = "감사합니다!"
    $0.font = UIFont.nanumGothic(size: 30, family: .bold)
    $0.textColor = .black
    $0.alpha = 0.0
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationItem.hidesBackButton = true
    layoutSubviews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animator()
  }
  
  // MARK: - Helper
  
  private func layoutSubviews() {
    view.addSubview(doneAnimation)
    doneAnimation.play()
    doneAnimation.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-90)
    }
    
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.doneAnimation.snp.bottom).offset(20)
      make.centerX.equalToSuperview()
    }
  }
  
  private func animator() {
    UIViewPropertyAnimator(duration: 0, curve: .linear) {
      self.titleLabel.alpha = 1.0
    }.startAnimation(afterDelay: 1.1)
  }
  
}
