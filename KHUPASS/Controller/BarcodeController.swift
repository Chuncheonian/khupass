//
//  BarcodeController.swift
//  KHUPASS
//
//  Created by dykoon on 2021/11/17.
//

import UIKit

class BarcodeController: UIViewController {

  // MARK: - Properties
  
  private let titleLabel = UILabel().then {
    $0.text = "학생증을 준비해주세요."
    $0.font = UIFont.nanumGothic(size: 25, family: .extrabold)
  }
  
  private let subLabel = UILabel().then {
    $0.text = "바코드 생성을 위해\n학생증 뒷면의 바코드 촬영이 필요합니다."
    $0.font = UIFont.nanumGothic(size: 14, family: .bold)
    $0.numberOfLines = 0
    $0.setLinespace(spacing: 6)
    $0.textColor = .init(white: 0, alpha: 0.6)
  }
  
  private let creditCardImageView = UIImageView().then {
    $0.image = UIImage(named: "CreditCard")
    $0.contentMode = .scaleAspectFill
  }
  
  private lazy var camearaButton = UIButton(type: .system).then {
    $0.backgroundColor = .khuBlue
    $0.setTitle("바코드 촬영", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = UIFont.nanumGothic(size: 17, family: .bold)
    $0.snp.makeConstraints { make in
      make.width.equalTo(311)
      make.height.equalTo(50)
    }
    $0.layer.cornerRadius = 10
    $0.addTarget(self, action: #selector(didTapCameraButton), for: .touchUpInside)
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationController?.navigationBar.tintColor = .black
    navigationController?.navigationBar.topItem?.title = ""
    layoutSubviews()
  }
  
  
  // MARK: - Action
  
  @objc private func didTapCameraButton() {
    let controller = ScannerController()
    controller.delegate = self
    controller.modalPresentationStyle = .fullScreen
    self.present(controller, animated: true, completion: nil)
  }
  
  // MARK: - Helper
  
  private func layoutSubviews() {
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(14)
      make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(16)
    }
    
    view.addSubview(subLabel)
    subLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
      make.leading.equalTo(titleLabel.snp.leading)
    }
    
    view.addSubview(creditCardImageView)
    creditCardImageView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  
    view.addSubview(camearaButton)
    camearaButton.snp.makeConstraints { make in
      make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(32)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-40)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-32)
    }
  }
}

// MARK: - ScannerControllerDelegate

extension BarcodeController: ScannerControllerDelegate {
  func didCompletedScan(_ controller: ScannerController, barcodeValue: String) {
    print(barcodeValue)
    controller.dismiss(animated: true, completion: nil)
    let passController = PassController()
    self.navigationController?.pushViewController(passController, animated: true)
  }
  
  
}
