//
//  BarcodeController.swift
//  KHUPASS
//
//  Created by dykoon on 2021/11/17.
//

import AVFoundation
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
    if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
      moveScannerController()
    } else {
      showAlert()
    }
  }
  
  // MARK: - method
  
  private func setupNavigationController() {
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationController?.navigationBar.topItem?.title = ""
  }
  
  private func showAlert() {
    let alertVC = UIAlertController(
      title: "",
      message: "카메라 기능을 사용하려면\n'카메라' 접근권한을 허용해야 합니다.",
      preferredStyle: .alert
    )
    
    let cancelAction = UIAlertAction(title: "취소", style: .default)
    let moveSettingAction = UIAlertAction(title: "설정으로 이동", style: .default) { [weak self] _ in
      self?.moveSettingApp()
    }
    alertVC.addAction(cancelAction)
    alertVC.addAction(moveSettingAction)
    present(alertVC, animated: true, completion: nil)
  }
  
  private func moveScannerController() {
    let controller = ScannerController()
    controller.delegate = self
    controller.modalPresentationStyle = .fullScreen
    self.present(controller, animated: true, completion: nil)
  }
  
  private func moveSettingApp() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
}

// MARK: - ScannerControllerDelegate

extension BarcodeController: ScannerControllerDelegate {
  func didCompletedScan(_ controller: ScannerController, barcodeValue: String) {
    controller.dismiss(animated: true)
    let passController = PassController(barcodeValue: barcodeValue)
    self.navigationController?.pushViewController(passController, animated: true)
  }
  
  func didFailedScan(_ controller: ScannerController) {
    controller.dismiss(animated: true)
    makeAlert(title: "오류", message: "카메라를 사용할 수 없습니다.\n다시 시도해주세요.")
  }
}
