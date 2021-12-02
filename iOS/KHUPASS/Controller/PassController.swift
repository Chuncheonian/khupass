//
//  PassController.swift
//  KHUPASS
//
//  Created by dykoon on 2021/11/21.
//

import UIKit
import PassKit

class PassController: UIViewController {

  // MARK: - Properties
  
  private let barcodeValue: String
  
  private let titleLabel = UILabel().then {
    $0.text = "스캔이 완료되었습니다."
    $0.font = UIFont.nanumGothic(size: 25, family: .extrabold)
  }
  
  private let subLabel = UILabel().then {
    $0.text = "Apple Wallet에 보관하기 위해\n아래의 버튼을 클릭해주세요."
    $0.font = UIFont.nanumGothic(size: 14, family: .bold)
    $0.numberOfLines = 0
    $0.setLinespace(spacing: 6)
    $0.textColor = .init(white: 0, alpha: 0.6)
  }
  
  private let passImageView = UIImageView().then {
    $0.image = UIImage(named: "pass")
    $0.contentMode = .scaleAspectFill
  }
  
  private let passButton = PKAddPassButton()
  
  // MARK: - Lifecycle
  
  init(barcodeValue: String) {
    self.barcodeValue = barcodeValue
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    navigationController?.navigationBar.topItem?.title = ""
    layoutSubviews()
  }
  
  // MARK: - Action
  
  @objc func addCredential() {
    let url: URL! = URL(string: "\(BASE_URL)?barcodeValue=\(barcodeValue)")
    let request: URLRequest = URLRequest(url: url as URL)
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task : URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: {[weak self] (data, response, error) in
      do {
        let pass = try PKPass(data: data ?? Data())
        let passLibrary = PKPassLibrary()

        if passLibrary.containsPass(pass) {
          DispatchQueue.main.sync {
            self?.showAlert(title: "오류", message: "이미 발급되었습니다. 지갑에서 확인해주세요.")
          }
        } else {
          if let pkvc = PKAddPassesViewController(pass: pass) {
            pkvc.delegate = self
            DispatchQueue.main.sync {
              self?.navigationController?.present(pkvc, animated: true)
            }
          } else {
            DispatchQueue.main.sync {
              self?.showAlert(title: "오류", message: "iPhone에서만 작동됩니다.")
            }
          }
        }
      } catch {
        self?.showAlert(title: "오류", message: "Pass를 로드하지 못했습니다.")
      }
    })
    task.resume()
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
    
    view.addSubview(passImageView)
    passImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(subLabel.snp.bottom).offset(20)
    }
    
    view.addSubview(passButton)
    passButton.addTarget(self, action: #selector(addCredential), for: .touchUpInside)
    passButton.snp.makeConstraints { make in
      make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(32)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-40)
      make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-32)
      make.height.equalTo(50)
    }
  }
  
  func showAlert(title: String, message: String) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertVC.addAction(okAction)
    self.present(alertVC, animated: true, completion: nil)
  }
}

// MARK: - PKAddPassesViewControllerDelegate

extension PassController: PKAddPassesViewControllerDelegate {
  func addPassesViewControllerDidFinish(_ controller: PKAddPassesViewController) {
    controller.dismiss(animated: true) {
      let completedVC = CompletedController()
      self.navigationController?.pushViewController(completedVC, animated: true)
    }

  }
}
