//
//  PassController.swift
//  KHUPASS
//
//  Created by dykoon on 2021/11/21.
//

import UIKit
import PassKit

final class PassController: UIViewController {

  // MARK: - property
  
  private let passView = PassView()
  
  private let barcodeValue: String
  private var pass = PKPass()
  
  // MARK: - life cycle
  
  init(barcodeValue: String) {
    self.barcodeValue = barcodeValue
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    self.view = passView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    
    self.passView.passButton.addTarget(
      self,
      action: #selector(fetchPass),
      for: .touchUpInside
    )
  }
  
  // MARK: - action
  
  @objc private func fetchPass() {
    Task {
      do {
        passView.indicator.startAnimating()
        pass = try await API.fetchPass(barcodeValue: barcodeValue)
        passView.indicator.stopAnimating()

        try checkPassExist()
        try presentPass()
      } catch {
        passView.indicator.stopAnimating()
        makeAlert(title: "오류", message: error.localizedDescription)
      }
    }
  }
  
  // MARK: - method
  
  /// Wallet App에 Pass가 이미 존재하는 지 확인
  private func checkPassExist() throws {
    let passLibrary = PKPassLibrary()
    
    if passLibrary.containsPass(pass) {
      throw PassError.existAlreadyPass
    }
  }
  
  /// iPhone이 확인한 후, PKAddPassesViewController 실행
  private func presentPass() throws {
    guard let previewPassVC = PKAddPassesViewController(pass: pass) else {
      throw PassError.invalidDevice
    }
    
    previewPassVC.delegate = self
    present(previewPassVC, animated: true)
  }
}

// MARK: - PKAddPassesViewControllerDelegate

extension PassController: PKAddPassesViewControllerDelegate {
  func addPassesViewControllerDidFinish(_ controller: PKAddPassesViewController) {
    controller.dismiss(animated: true) { [weak self] in
      let passLibrary = PKPassLibrary()
      
      // PKAddPassesViewController에서 Pass를 추가한 경우
      if passLibrary.containsPass(self?.pass ?? PKPass()) {
        let completedVC = CompletedController()
        self?.navigationController?.pushViewController(completedVC, animated: true)
      }
    }
  }
}
