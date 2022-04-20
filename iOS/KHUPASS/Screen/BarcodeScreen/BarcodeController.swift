//
//  BarcodeController.swift
//  KHUPASS
//
//  Created by dykoon on 2021/11/17.
//

import UIKit

final class BarcodeController: UIViewController {

  // MARK: - property
  
  private let barcodeView = BarcodeView()
  
  // MARK: - life cycle
  
  override func loadView() {
    super.loadView()
    self.view = self.barcodeView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupNavigationController()
    self.barcodeView.camearaButton.addTarget(
      self,
      action: #selector(self.didTapCameraButton),
      for: .touchUpInside
    )
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.barcodeView.pigTailedArrowAnimation.play()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.barcodeView.pigTailedArrowAnimation.stop()
  }
  
  // MARK: - action
  
  @objc private func didTapCameraButton() {
    let controller = ScannerController()
    controller.delegate = self
    controller.modalPresentationStyle = .fullScreen
    self.present(controller, animated: true, completion: nil)
  }
  
  // MARK: - Helper
  
  private func setupNavigationController() {
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationController?.navigationBar.topItem?.title = ""
  }
}

// MARK: - ScannerControllerDelegate

extension BarcodeController: ScannerControllerDelegate {
  func didCompletedScan(_ controller: ScannerController, barcodeValue: String) {
    controller.dismiss(animated: true, completion: nil)
    let passController = PassController(barcodeValue: barcodeValue)
    self.navigationController?.pushViewController(passController, animated: true)
  }
}
