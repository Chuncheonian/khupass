//
//  UIViewController+Extension.swift
//  KHUPASS
//
//  Created by dykoon on 2022/05/13.
//

import UIKit

extension UIViewController {
  func makeAlert(title: String, message: String) {
    let alertViewController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    let okAction = UIAlertAction(title: "확인", style: .default)
    alertViewController.addAction(okAction)
    self.present(alertViewController, animated: true)
  }
}
