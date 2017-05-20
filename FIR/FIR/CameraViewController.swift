//
//  CameraViewController.swift
//  FIR
//
//  Created by Sachin Vas on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

import Foundation
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var cameraButton: UIButton!
    var captureSession: AVCaptureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    
    @IBAction func cameraTapped(_ sender: UIButton) {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch let error {
            print(error)
        }
        
        let captureMetaDataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetaDataOutput)
        
        let dispatchQueue = DispatchQueue(label: "qrcodeSession")
        captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        captureMetaDataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = cameraButton.layer.bounds
        cameraButton.layer.addSublayer(videoPreviewLayer)
        
        captureSession.startRunning()
    }
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if let readableCode = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
            if readableCode.type == AVMetadataObjectTypeQRCode {
                print(readableCode.stringValue)
            }
        }
    }

}
