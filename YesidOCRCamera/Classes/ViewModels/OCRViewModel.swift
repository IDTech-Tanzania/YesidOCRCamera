//
//  ObjectDetector.swift
//  object-detection
//
//  Created by Aim Group on 19/09/2022.
//

import Foundation
import Vision
import UIKit
import Combine
import AVFoundation
import SwiftUI
import MLKitObjectDetectionCustom
import MLKitCommon
import MLKitVision

public class OCRViewModel: NSObject, ObservableObject {
    
    @Published var placeMentColor: Color = Color.white
    
    @Published var boundingBox = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    
    @Published var rectangleSize = CGRect()
    
    @Published var direction: String = ""
    
    @Published var capturePhoto:Bool = false
    
    @Published var cardImage:UIImage?
    
    @Published public var startOCRDetection:Bool = false
    
    @Published private var proceedWithOCR:Bool = false
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    private let localModelFile = (name: "object_labeler", type: "tflite")
    
    private let apiEndpoint = "https://api.regulaforensics.com/api/process"
    
    @Published public var isResultSet:Bool = false
    @Published public var isLoading:Bool = false
    @Published var isloading:Bool = false
    @Published var isError:Bool = false
    
    @Published var cardResults = RegulaResponse().containerList?.list
    
    private var sampleBuffer: CMSampleBuffer?
    
    public let subject = PassthroughSubject<CMSampleBuffer?, Never>()
    var cancellables = [AnyCancellable]()
    
    let queue = DispatchQueue(label: "io.yesid.sdk.ios")
    
    @Published var defaultLocalizer = LocalizeUtils.defaultLocalizer
    
    
    public func performOcr(){
        subject
            .sink { sampleBuffer in
                self.sampleBuffer = sampleBuffer
                do {
                    guard let sampleBuffer = sampleBuffer else {
                        return
                    }
                    try self.detect(sampleBuffer: sampleBuffer)
                } catch {
                    self.direction = "Error has been thrown"
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchDetails(image:String) {
        guard semaphore.wait(timeout: .now()) == .success else {
            return
        }
        DispatchQueue.main.async {
            self.isLoading = true
            self.direction = NSLocalizedString("Processing", comment: "Processing")
        }
        guard let url = URL(string: apiEndpoint) else {
            semaphore.signal()
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = """
        
        {
         "processParam": {
           "scenario": "FullAuth",
           "resultTypeOutput": [33, 20, 36, 37, 9, 8, 3, 17, 18, 102, 6, 19, 103, 15]
         },
         "List":[
           {
           "ImageData":{
             "image":"\(image)"
           },
           "light":6,
            "page_idx":0
             }
         ],
         "systemInfo": {}
        }
        """
        request.httpBody = body.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.isResultSet = false
                    self.isLoading = false
                    self.placeMentColor = .white
                    self.direction = NSLocalizedString("ProcessingError", comment: "Processing Error")
                    self.proceedWithOCR = false
                    self.isError = true
                }
                self.semaphore.signal()
                return
            }
            do {
                let response = try JSONDecoder().decode(RegulaResponse.self, from: data)
                if let count = response.containerList?.count {
                    DispatchQueue.main.async {
                        self.cardResults = response.containerList?.list
                        self.isResultSet = true
                        self.isLoading = false
                        self.placeMentColor = .white
                        self.direction = NSLocalizedString("ProcessingDone", comment: "Processing Done")
                        self.proceedWithOCR = false
                    }
                    self.semaphore.signal()
                } else {
                    DispatchQueue.main.async {
                        self.cardResults = response.containerList?.list
                        self.isResultSet = true
                        self.isLoading = false
                        self.placeMentColor = .white
                        self.direction = NSLocalizedString("ProcessingDone", comment: "Processing Done")
                        self.proceedWithOCR = false
                    }
                    self.semaphore.signal()
                }
            } catch {
                DispatchQueue.main.async {
                    self.isResultSet = false
                    self.isLoading = false
                    self.placeMentColor = .white
                    self.direction = NSLocalizedString("ProcessingError", comment: "Processing Error")
                    self.proceedWithOCR = false
                    self.isError = true
                }
                self.semaphore.signal()
            }
        }
        task.resume()
    }
    
    
    public func getCardTextResults() -> [String:String]? {
        var newlist : [String:String] = [:]
        cardResults?.forEach{results in
            results.text?.fieldList?.forEach{result in
                newlist["\(result.fieldName ?? "")"] = result.value
            }
        }
        return newlist
    }
    
    public func getCardImageResults() -> [String:String]{
        var newlist:[String:String] = [:]
        cardResults?.forEach{results in
            results.images?.fieldList?.forEach{result in
                newlist["\(result.fieldName?.description ?? "")"] = result.valueList?.first?.value
            }
        }
        return newlist
    }
    
    
    private func detect(sampleBuffer: CMSampleBuffer) throws {
        guard let modelPath = Bundle.main.path(forResource: self.localModelFile.name, ofType: localModelFile.type) else {
            print("Couldn't find \(localModelFile.name).tflite in your pod's resources")
            return
        }
        let localModel = LocalModel(path: modelPath)

        // Live detection and tracking
        let options = CustomObjectDetectorOptions(localModel: localModel)
        options.detectorMode = .singleImage
        options.shouldEnableClassification = true
        options.classificationConfidenceThreshold = NSNumber(value: 0.5)
        options.maxPerObjectLabelCount = 1
        
        let objectDetector = ObjectDetector.objectDetector(options: options)
        
        
        let image = VisionImage(buffer: sampleBuffer)
        image.orientation = imageOrientation(
            deviceOrientation: UIDevice.current.orientation,
            cameraPosition: .unspecified)
        
        if(self.isLoading==false && self.isResultSet==false){
            if(self.proceedWithOCR){
                self.capturePhoto = true
                if self.capturePhoto {
                    self.capturePhoto = false
                    self.doCardOCR(from: sampleBuffer)
                }
            }else{
                objectDetector.process(image) { objects, error in
                    guard error == nil else {
                        self.direction = "\(String(describing: error?.localizedDescription))"
                        return
                    }
                    guard !objects!.isEmpty else {
                        self.direction = NSLocalizedString("PlaceCardOnFrame", comment: "Place card on frame")
                        return
                    }
                    for object in objects! {
                        let frame = object.frame
                        _ = object.trackingID
                        if(object.labels.first?.text == "Driver's license"){
                            if self.checkFaceBoundsCenter(boundingBox: frame) && !self.proceedWithOCR {
                                self.boundingBox = frame
                                self.changePlaceMentColor(color: .green)
                                self.direction = NSLocalizedString("PleaseHoldStill", comment: "Please hold still")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1
                                ) {
                                    self.proceedWithOCR = true
                                }
                            }else{
                                //self.direction = NSLocalizedString("PleaseMoveCloser", comment: "Please move closer")
                            }
                        }
                    }
                }
            }
        }else{
            self.changePlaceMentColor(color: .white)
        }
        
    }
    
    private func doCardOCR(from buffer: CMSampleBuffer) {
        let imageBuffer = CMSampleBufferGetImageBuffer(buffer)
        var ciImage = CIImage(cvPixelBuffer: imageBuffer!)
            .cropped(to: CGRect(x: self.boundingBox.origin.x, y: self.boundingBox.origin.y, width: self.boundingBox.width, height: self.boundingBox.height))
        let context = CIContext(options: nil)
        let targetSize = CGSize(width: ciImage.extent.width, height: ciImage.extent.height/2)
        ciImage = ciImage.transformed(by: CGAffineTransform.init(scaleX: 0.5, y: 0.5))
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        let uiImage = UIImage(cgImage: cgImage!).fixedOrientation().imageRotatedByDegrees(degrees: 90)
        DispatchQueue.main.async {
            if(self.cardImage==nil){
                self.cardImage = uiImage
            }
        }
        let base64StringImage = self.convertImageToBase64String(img: uiImage)
        if(self.isResultSet == false){
            self.queue.async {
                self.fetchDetails(image: base64StringImage)
            }
        }
    }
    
    
    func cropImage(image: UIImage, to aspectRatio: CGFloat,completion: @escaping (UIImage) -> ()) {
        DispatchQueue.global(qos: .background).async {
            
            let imageAspectRatio = image.size.height/image.size.width
            
            var newSize = image.size
            
            if imageAspectRatio > aspectRatio {
                newSize.height = image.size.width * aspectRatio
            } else if imageAspectRatio < aspectRatio {
                newSize.width = image.size.height / aspectRatio
            } else {
                completion (image)
            }
            
            let center = CGPoint(x: image.size.width/2, y: image.size.height/2)
            let origin = CGPoint(x: center.x - newSize.width/2, y: center.y - newSize.height/2)
            
            let cgCroppedImage = image.cgImage!.cropping(to: CGRect(origin: origin, size: CGSize(width: newSize.width, height: newSize.height)))!
            let croppedImage = UIImage(cgImage: cgCroppedImage, scale: image.scale, orientation: image.imageOrientation)
            
            completion(croppedImage)
        }
    }
    
    private func changePlaceMentColor(color:Color){
        DispatchQueue.main.async {
            self.placeMentColor = color
        }
    }
    
    public func clearData(){
        self.placeMentColor = Color.white
        self.boundingBox = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        self.direction = ""
        self.cardImage = nil
        self.sampleBuffer = nil
        self.cardResults = nil
        self.isResultSet = false
        self.isError = false
        self.startOCRDetection = true
        self.proceedWithOCR = false
    }
    
    private func checkFaceBoundsCenter(boundingBox: CGRect)->Bool{
        let x = boundingBox.origin.x
        let y = boundingBox.origin.y
        let width = boundingBox.size.width
        let height = boundingBox.size.height
        let centerX = x + width/2
        let centerY = y + height/2
        //print("centerx : \(centerX), centery : \(centerY)")
        if(centerX > 920 && centerX < 980 && centerY > 520 && centerY < 580){
            return true
        }else{
            return false
        }
    }
    
    
    private func convertImageToBase64String(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
    }
    
    public func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        if(imageBase64String == ""){
            return UIImage()
        }else{
            let imageData = Data(base64Encoded: imageBase64String)
            let image = UIImage(data: imageData!)
            return image!
        }
    }
    
    private func imageOrientation(
        deviceOrientation: UIDeviceOrientation,
        cameraPosition: AVCaptureDevice.Position
    ) -> UIImage.Orientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return cameraPosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return cameraPosition == .front ? .upMirrored : .down
        case .faceDown, .faceUp, .unknown:
            return .up
        }
    }
}
