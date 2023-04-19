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
private class OCRAppDelegate: UIResponder, UIApplicationDelegate {
    let viewModel: OCRViewModel = OCRViewModel()
    var cancellables = [AnyCancellable]()
    let captureSession = OCRCaptureSession()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        captureSession.$sampleBuffer
            .subscribe(viewModel.subject).store(in: &cancellables)
        return true
    }
}

// MARK: The Private OCRMainCameraUI
public struct OCRCameraUI: View {
    var configurationBuilder: OCRConfigurationBuilder
    var onResults: (OCRResponse) -> Void
    @State private var ocrAppDelegate: OCRAppDelegate = OCRAppDelegate()
    public init(configurationBuilder:OCRConfigurationBuilder, onResults:@escaping (OCRResponse) -> Void){
        self.configurationBuilder = configurationBuilder
        self.onResults = onResults
    }
    public var body: some View {
        return _OCRCameraUI(
            configurationBuilder: configurationBuilder, onResults: onResults)
        .environmentObject(ocrAppDelegate.viewModel)
        .environmentObject(ocrAppDelegate.captureSession)
        .onAppear(){
            ocrAppDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        }
        .onDisappear(){
            ocrAppDelegate.cancellables.forEach { $0.cancel() }
        }
    }
}


// MARK: The Private _OCRCameraUI
private struct _OCRCameraUI: View {
    var configurationBuilder: OCRConfigurationBuilder
    var onResults: (OCRResponse) -> Void = {_ in }
    
    @EnvironmentObject private var viewModel:OCRViewModel
    @EnvironmentObject private var captureSession: OCRCaptureSession
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    init(configurationBuilder:OCRConfigurationBuilder, onResults:@escaping (OCRResponse) -> Void){
        self.configurationBuilder = configurationBuilder
        self.onResults = onResults
    }
    
    var body: some View {
        return ZStack(alignment:.bottom){
            if(!self.viewModel.isLoading){
                IOSCameraView()
                InstructionText()
            }else {
                SimpleProgressView()
                InstructionText()
            }
        }
    }
    
    @ViewBuilder
    private func IOSCameraView() -> some View {
        ZStack{
            CameraView(captureSession: self.captureSession.captureSession)
            cameraOverlay()
        }
        .onDisappear(){
            self.captureSession.stop()
        }
        .onAppear(){
            if(self.viewModel.isResultSet){
                self.viewModel.clearData()
            }
            self.captureSession.start()
            self.viewModel.performOcr()
        }
        .onReceive(self.viewModel.$cardResults){ results in
            if(results != nil){
                let documentImageResults = self.viewModel.getCardImageResults()
                let documentTextResults = self.viewModel.getCardTextResults()
                let ocrResponse = OCRResponse(
                    documentImages: documentImageResults,
                    documentText: documentTextResults)
                self.onResults(ocrResponse)
            }
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
                    .frame(width: geometry.size.width, height: geometry.size.height <= 340 ? geometry.size.height * 0.8 : geometry.size.height * 0.45)
                Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    @ViewBuilder
    private func SimpleProgressView() -> some View {
        Rectangle().overlay(
            ActivityIndicator(style: .medium)
        )
        .frame(maxWidth: self.screenWidth, maxHeight: self.screenHeight)
        .background(Color.black)
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
