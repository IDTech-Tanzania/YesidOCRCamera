//
//  OCRCameraUI.swift
//  YesidOCRCamera
//
//  Created by Emmanuel Mtera on 4/4/23.
//
import Foundation
import SwiftUI
import AVFoundation
import Combine
import UIKit

// MARK: The OCRAppDelegate
class OCRAppDelegate: UIResponder, UIApplicationDelegate {
    let viewModel: OCRViewModel = OCRViewModel()
    private var cancellables = [AnyCancellable]()
    let captureSession = OCRCaptureSession()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        captureSession.$sampleBuffer
            .subscribe(viewModel.subject).store(in: &cancellables)
        return true
    }
}

// MARK: OCR MainApp
public struct OCRCameraUI: View {
    var configurationBuilder: OCRConfigurationBuilder
    var onResults: (OCRResponse) -> Void
    @UIApplicationDelegateAdaptor(OCRAppDelegate.self) private var ocrAppDelegate
    public init(configurationBuilder:OCRConfigurationBuilder, onResults:@escaping (OCRResponse) -> Void){
        self.configurationBuilder = configurationBuilder
        self.onResults = onResults
    }
    public var body: some View {
        return OCRMainCameraUI(configurationBuilder: configurationBuilder, onResults: onResults, ocrAppDelegate:ocrAppDelegate)
    }
}

// MARK: The Public OCRMainCameraUI
// Takes in OCRConfigurationBuilder and onResults callback which return OCRResponse
private struct OCRMainCameraUI: View {
    var configurationBuilder: OCRConfigurationBuilder
    var onResults: (OCRResponse) -> Void
    @State private var ocrAppDelegate: OCRAppDelegate = OCRAppDelegate()
    init(configurationBuilder:OCRConfigurationBuilder, onResults:@escaping (OCRResponse) -> Void, ocrAppDelegate: OCRAppDelegate){
        self.configurationBuilder = configurationBuilder
        self.onResults = onResults
        self.ocrAppDelegate = ocrAppDelegate
    }
    var body: some View {
        return _OCRCameraUI(
        configurationBuilder: configurationBuilder, onResults: onResults)
        .environmentObject(ocrAppDelegate.viewModel)
        .environmentObject(ocrAppDelegate.captureSession)
    }
}

// MARK: The Private _OCRCameraUI
private struct _OCRCameraUI: View {
    var configurationBuilder: OCRConfigurationBuilder = OCRConfigurationBuilder()
    var onResults: (OCRResponse) -> Void = {_ in }
    @EnvironmentObject private var viewModel:OCRViewModel
    @EnvironmentObject private var captureSession: OCRCaptureSession
    
    public init(configurationBuilder:OCRConfigurationBuilder, onResults:@escaping (OCRResponse) -> Void){
        self.configurationBuilder = configurationBuilder
        self.onResults = onResults
    }
    
    public var body: some View {
        return ZStack(alignment:.bottom){
            IOSCameraView()
            SimpleProgressView()
            InstructionText()
        }
    }
    
    @ViewBuilder
    private func IOSCameraView() -> some View {
        if #available(iOS 14.0, *) {
            ZStack{
                CameraView(captureSession: self.captureSession.captureSession)
                cameraOverlay()
            }.onDisappear(){
                self.captureSession.stop()
            }
            .onAppear(){
                self.captureSession.start()
            }.onChange(of: self.captureSession.sampleBuffer, perform: { _ in
                self.viewModel.performOcr()
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    @ViewBuilder
    private func cameraOverlay() -> some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 3)
                    .stroke(self.viewModel.placeMentColor, lineWidth: 3)
                    .padding(20)
                    .frame(width: geometry.size.width, height: geometry.size.height*0.4)
                Spacer()
            }
        }
    }

    
    @ViewBuilder
    private func SimpleProgressView() -> some View {
        if #available(iOS 14.0, *) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        } else {
            ActivityIndicator(style: .medium)
        }
    }

    
    @ViewBuilder
    private func InstructionText() -> some View {
        Text(self.viewModel.instructionText)
            .foregroundColor(Color.white)
            .padding()
    }
}

// MARK: The ProgressView to support older ios verions
private struct ActivityIndicator: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIViewType {
        UIViewType(style: style)
    }

    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<Self>) {
        uiView.style = style
        uiView.hidesWhenStopped = true
        uiView.startAnimating()
    }
}

// MARK: USAGE
/*
 OCRCameraUI(
     configurationBuilder: OCRConfigurationBuilder()
         .setUserLicense(userLicense: "1234"),
     onResults: {OCRResponse in print(OCRResponse)}
 )
 */
