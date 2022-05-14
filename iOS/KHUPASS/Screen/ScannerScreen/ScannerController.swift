//
//  ScannerController.swift
//  KHUPASS
//
//  Created by dykoon on 2021/11/21.
//

import AVFoundation
import UIKit

protocol ScannerControllerDelegate: AnyObject {
  func didCompletedScan(_ controller: ScannerController, barcodeValue: String)
  func didFailedScan(_ controller: ScannerController)
}

final class ScannerController: UIViewController {
  
  // MARK: - property
  
  weak var delegate: ScannerControllerDelegate?
  
  private var captureSession = AVCaptureSession()
  private var previewLayer: AVCaptureVideoPreviewLayer!
  
  private let topTransparentView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.8)
  }
  
  private let bottomTransparentView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.8)
  }
  
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
  
  // MARK: - life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupScanner()
    configUI()
  }
  
  // MARK: - action
  
  @objc private func didTapCancelButton() {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - method
  
  private func setupScanner() {
    // 카메라 사용
    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
      return
    }
      
    // 지정된 장치를 사용하도록 입력을 초기화 하는 작업
    let videoInput: AVCaptureDeviceInput
      
    do {
      videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
    } catch {
      delegate?.didFailedScan(self)
      return
    }
      
    if captureSession.canAddInput(videoInput) {
      captureSession.addInput(videoInput)
    } else {
      delegate?.didFailedScan(self)
      return
    }
    
    let metadataOutput = AVCaptureMetadataOutput()
      
    if captureSession.canAddOutput(metadataOutput) {
      captureSession.addOutput(metadataOutput)
      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes = [.code39, .code128]
    } else {
      delegate?.didFailedScan(self)
      return
    }
    
    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.layer.bounds
    previewLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(previewLayer)
    captureSession.startRunning()
  }
  
  private func configUI() {
    [topTransparentView, bottomTransparentView, descriptionLabel, cancelButton].forEach {
      view.addSubview($0)
    }
    
    topTransparentView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(250)
    }
    
    bottomTransparentView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.bottom.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(250)
    }
    
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(bottomTransparentView.snp.top).offset(20)
      make.centerX.equalToSuperview()
    }
    
    cancelButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
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
    guard
      let object = metadataObjects.first,
      let readableObject = object as? AVMetadataMachineReadableCodeObject,
      let stringValue = readableObject.stringValue
    else {
      delegate?.didFailedScan(self)
      return
    }
    
    captureSession.stopRunning()
    delegate?.didCompletedScan(self, barcodeValue: stringValue)
  }
}
