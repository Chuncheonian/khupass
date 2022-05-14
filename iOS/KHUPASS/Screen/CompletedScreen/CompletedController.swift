//
//  CompletedController.swift
//  KHUPASS
//
//  Created by dykoon on 2021/12/01.
//

import UIKit
import StoreKit

final class CompletedController: UIViewController {

  // MARK: - property
  
  private let completedView = CompletedView()
  
  // MARK: - life cycle
  
  override func loadView() {
    super.loadView()
    self.view = completedView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.hidesBackButton = true
    completedView.moveWalletButton.addTarget(self, action: #selector(moveWalletApp), for: .touchUpInside)
    requestReview()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animator()
  }
  
  // MARK: - action
  
  @objc private func moveWalletApp() {
    let url = "wallet://"

    if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
      UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
    } else {
      print("Wallet App 실행 불가")  // PassController에서 Wallet 앱이 있는 것을 확인했기에 일어날 일 없음
    }
  }
  
  // MARK: - method
  
  private func animator() {
    UIViewPropertyAnimator(duration: 0, curve: .linear) {
      self.completedView.titleLabel.alpha = 1.0
      self.completedView.descriptionLabel.alpha = 1.0
      self.completedView.moveWalletButton.alpha = 1.0
    }.startAnimation(afterDelay: 1.2)
  }
  
  /// 리뷰 요청
  private func requestReview() {
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
      SKStoreReviewController.requestReview(in: scene)
    }
  }
}
