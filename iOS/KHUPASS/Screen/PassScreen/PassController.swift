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
    self.view = self.passView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.topItem?.title = ""
    
    self.passView.passButton.addTarget(
      self,
      action: #selector(self.addCredential),
      for: .touchUpInside
    )
  }
  
  // MARK: - action
  
  @objc func addCredential() {
    let url: URL! = URL(string: "\(BASE_URL)?barcodeValue=\(barcodeValue)")
    let request: URLRequest = URLRequest(url: url as URL)
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    self.passView.indicator.startAnimating()
    
    let task : URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: {[weak self] (data, response, error) in
      do {
        DispatchQueue.main.sync {
          self?.passView.indicator.stopAnimating()
        }
        
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
        DispatchQueue.main.sync {
          self?.passView.indicator.stopAnimating()
        }
        self?.showAlert(title: "오류", message: "Pass를 로드하지 못했습니다.")
      }
    })
    task.resume()
  }
  
  // MARK: - method
  
  private func showAlert(title: String, message: String) {
    let alertVC = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    
    let okAction = UIAlertAction(title: "OK", style: .default)
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
