// CaptureSession.swift
// object-detection
//
// Created by Aim Group on 19/09/2022.

// This is the implementation file of the OCRCaptureSession class that is used to set up and manage the AVFoundation Capture session in a SwiftUI app.

import Foundation
import AVFoundation
import SwiftUI

public class OCRCaptureSession: NSObject, ObservableObject {
    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }
    
    // Properties to store error, sample buffer, and orientation
    @Published var error: CameraError?
    @Published public var sampleBuffer: CMSampleBuffer?
    @Published var orientation: AVCaptureDevice.Position = .back
    
    // AVCaptureSession object
    let captureSession = AVCaptureSession()
    private var videoDeviceInput: AVCaptureDeviceInput!
    private weak var previewView: PreviewView!
    
    // DispatchQueue to handle sessionQueue
    private let sessionQueue = DispatchQueue(label: "io.yesid.sdk")
    private let videoOutput = AVCaptureVideoDataOutput()
    private var status = Status.unconfigured
    
    // Method to set the error
    private func set(error: CameraError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    // Method to check permissions for camera access
    private func checkPermissions() {
        // Check the authorization status for video
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // Suspend the sessionQueue
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.status = .unauthorized
                    self.set(error: .deniedAuthorization)
                }
                self.sessionQueue.resume()
            }
        case .restricted:
            status = .unauthorized
            set(error: .restrictedAuthorization)
        case .denied:
            status = .unauthorized
            set(error: .deniedAuthorization)
        case .authorized:
            break
        default:
            status = .unauthorized
            set(error: .unknownAuthorization)
        }
    }
    
    private func configureCaptureSession() {
        guard status == .unconfigured else {
            return
        }
        
        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
        }
        
        let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: self.orientation)
        
        guard let camera = device else {
            set(error: .cameraUnavailable)
            status = .failed
            return
        }
        
        try! camera.lockForConfiguration()
        camera.focusMode = .continuousAutoFocus
        camera.unlockForConfiguration()

        do {
            
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(cameraInput) {
                captureSession.addInput(cameraInput)
                self.videoDeviceInput = cameraInput
                
            } else {
                set(error: .cannotAddInput)
                status = .failed
                return
            }
        } catch {
            set(error: .cannotAddInput)
            status = .failed
            return
        }
        
        
        if captureSession.canAddOutput(videoOutput) {
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "SampleBuffer"))
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            captureSession.addOutput(videoOutput)
        } else {
            set(error: .cannotAddOutput)
            status = .failed
            return
        }
        
        status = .configured
    }
    
    public func start(){
        self.configure()
    }
    
    public func stop(){
        sessionQueue.async {
            self.captureSession.stopRunning()
        }
    }
    
    public func changeOrientation(orientation:AVCaptureDevice.Position){
        let currentVideoDevice = self.videoDeviceInput.device
        var currentPosition = orientation
        
        var newVideoDevice: AVCaptureDevice? = nil
        
        let backVideoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInDualWideCamera, .builtInWideAngleCamera],
                                                                               mediaType: .video, position: .back)
        let frontVideoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInWideAngleCamera],
                                                                                mediaType: .video, position: .front)
        
        switch currentPosition {
        case .unspecified, .front:
            newVideoDevice = frontVideoDeviceDiscoverySession.devices.first
        case .back:
            newVideoDevice = backVideoDeviceDiscoverySession.devices.first
        default:
            print("Unknown capture position. Defaulting to back, dual-camera.")
            newVideoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        if let videoDevice = newVideoDevice {
            do {
                let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                
                self.captureSession.beginConfiguration()
                
                // Remove the existing device input first, because AVCaptureSession doesn't support
                // simultaneous use of the rear and front cameras.
                self.captureSession.removeInput(self.videoDeviceInput)
                
                if self.captureSession.canAddInput(videoDeviceInput) {
                    self.captureSession.addInput(videoDeviceInput)
                    self.videoDeviceInput = videoDeviceInput
                } else {
                    self.captureSession.addInput(self.videoDeviceInput)
                }
                
                self.captureSession.commitConfiguration()
            } catch {
                print("Error occurred while creating video device input: \(error)")
            }
        }
    }
    
    private func configure() {
        checkPermissions()
        sessionQueue.async {
            self.configureCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    func set(
        _ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
        queue: DispatchQueue
    ) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
    
    @objc public func focusAndExposeTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let devicePoint = self.previewView.videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: gestureRecognizer.location(in: gestureRecognizer.view))
        focus(with: .autoFocus, exposureMode: .autoExpose, at: devicePoint, monitorSubjectAreaChange: true)
        print("focus")
    }
    
    @objc private func focus(with focusMode: AVCaptureDevice.FocusMode,
                       exposureMode: AVCaptureDevice.ExposureMode,
                       at devicePoint: CGPoint,
                       monitorSubjectAreaChange: Bool) {
        
        sessionQueue.async {
            let device = self.videoDeviceInput.device
            do {
                try device.lockForConfiguration()
                
                /*
                 Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation.
                 Call set(Focus/Exposure)Mode() to apply the new point of interest.
                 */
                if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(focusMode) {
                    device.focusPointOfInterest = devicePoint
                    device.focusMode = focusMode
                }
                
                if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode) {
                    device.exposurePointOfInterest = devicePoint
                    device.exposureMode = exposureMode
                }
                
                device.isSubjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
                device.unlockForConfiguration()
            } catch {
                print("Could not lock device for configuration: \(error)")
            }
        }
    }
}

extension OCRCaptureSession: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        DispatchQueue.main.async {
            self.sampleBuffer = sampleBuffer
        }
    }
}
