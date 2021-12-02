//
//  CompletedController.swift
//  KHUPASS
//
//  Created by dykoon on 2021/12/01.
//

import UIKit
import StoreKit
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
  
  private let descriptionLabel = UILabel().then {
    $0.text = "발급된 패스는 '지갑' 앱에서 확인할 수 있습니다."
    $0.font = UIFont.nanumGothic(size: 14, family: .bold)
    $0.textColor = .init(white: 0, alpha: 0.6)
    $0.alpha = 0.0
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationController?.navigationBar.tintColor = .black
    navigationItem.hidesBackButton = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "ellipsis"),
      style: .plain,
      target: self,
      action: #selector(didTapBarButton)
    )
    
    // 리뷰 요청
    if #available(iOS 14.0, *) {
      if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        SKStoreReviewController.requestReview(in: scene)
      }
    } else {
      SKStoreReviewController.requestReview()
    }
    
    layoutSubviews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animator()
  }
  
  // MARK: - Action
  
  @objc private func didTapBarButton() {
    let controller = SettingController()
    self.present(controller, animated: true, completion: nil)
  }
  
  // MARK: - Helper
  
  private func layoutSubviews() {
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    view.addSubview(doneAnimation)
    doneAnimation.play()
    doneAnimation.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(titleLabel.snp.top).offset(-15)
    }
    
    view.addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
    }
  }
  
  private func animator() {
    UIViewPropertyAnimator(duration: 0, curve: .linear) {
      self.titleLabel.alpha = 1.0
      self.descriptionLabel.alpha = 1.0
    }.startAnimation(afterDelay: 1.2)
  }
}
