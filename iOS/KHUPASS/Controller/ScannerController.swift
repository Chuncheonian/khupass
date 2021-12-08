//
//  ScannerController.swift
//  KHUPASS
//
//  Created by dykoon on 2021/11/21.
//

import UIKit
import AVFoundation

protocol ScannerControllerDelegate: AnyObject {
  func didCompletedScan(_ controller: ScannerController, barcodeValue: String)
}

class ScannerController: UIViewController {
  
  // MARK: - Properties
  
  weak var delegate: ScannerControllerDelegate?
  
  private var captureSession = AVCaptureSession()
  private var previewLayer: AVCaptureVideoPreviewLayer!
  
  private let descriptionLabel = UILabel().then {
    $0.text = "학생증 바코드를 자동 촬영합니다."
    $0.font = UIFont.nanumGothic(size: 15, family: .regular)
    $0.textColor = .white
  }
  
  private lazy var cancelButton = UIButton(type: .system).then {
    $0.setTitle("취소", for: .normal)
    $0.titleLabel?.font = UIFont.nanumGothic(size: 18, family: .extrabold)
    $0.setTitleColor(.white, for: .normal)
    $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
  }
  
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureScanner()
    configureUI()
  }
  
  // MARK: - Action
  
  @objc private func didTapCancelButton() {
    self.dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Helpers
  
  private func configureScanner() {
    // 카메라 사용
    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
      return
    }
      
    // 지정된 장치를 사용하도록 입력을 초기화 하는 작업
    let videoInput: AVCaptureDeviceInput
      
    do {
      videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
    } catch {
      return
    }
      
    if self.captureSession.canAddInput(videoInput) {
      self.captureSession.addInput(videoInput)
    } else {
      return
    }
      
    let metadataOutput = AVCaptureMetadataOutput()
      
    if self.captureSession.canAddOutput(metadataOutput) {
      self.captureSession.addOutput(metadataOutput)
      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes = [.code39, .code128]
    } else {
      return
    }
      
    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    self.previewLayer.frame = self.view.layer.bounds
    self.previewLayer.videoGravity = .resizeAspectFill
    self.view.layer.addSublayer(self.previewLayer)
    print("DEBUG: Running Scanner")
    self.captureSession.startRunning()
  }
  
  private func configureUI() {
    let topTransparentView = UIView()
    topTransparentView.backgroundColor = .black.withAlphaComponent(0.8)
    view.addSubview(topTransparentView)
    topTransparentView.snp.makeConstraints { make in
      make.top.equalTo(self.view.snp.top)
      make.leading.equalTo(self.view.snp.leading)
      make.trailing.equalTo(self.view.snp.trailing)
      make.height.equalTo(250)
    }
    
    let bottomTransparentView = UIView()
    bottomTransparentView.backgroundColor = .black.withAlphaComponent(0.8)
    view.addSubview(bottomTransparentView)
    bottomTransparentView.snp.makeConstraints { make in
      make.leading.equalTo(self.view.snp.leading)
      make.bottom.equalTo(self.view.snp.bottom)
      make.trailing.equalTo(self.view.snp.trailing)
      make.height.equalTo(250)
    }
    
    view.addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(bottomTransparentView.snp.top).offset(20)
      make.centerX.equalToSuperview()
    }
    
    view.addSubview(cancelButton)
    cancelButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
    }
  }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScannerController: AVCaptureMetadataOutputObjectsDelegate {
  func metadataOutput(
    _ output: AVCaptureMetadataOutput,
    didOutput metadataObjects: [AVMetadataObject],
    from connection: AVCaptureConnection
  ) {
    if let first = metadataObjects.first {
      guard let readableObject = first as? AVMetadataMachineReadableCodeObject else {
        return
      }
      
      guard let stringValue = readableObject.stringValue else { return }
      
      found(code: stringValue)
    }
  }
  
  func found(code: String) {
    self.captureSession.stopRunning()
    self.delegate?.didCompletedScan(self, barcodeValue: code)
  }
}
