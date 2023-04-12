//
//  ImageAnalyzer.swift
//  YesidOCRCamera
//
//  Created by Emmanuel Mtera on 4/4/23.
//

import Foundation
import CoreMedia
import MLKitObjectDetectionCustom

class ImageAnalyzer : ObservableObject {
    let objectDetector: ObjectDetector
    let state: OCRViewModel
    
    init(objectDetector: ObjectDetector, state: OCRViewModel) {
        self.objectDetector = objectDetector
        self.state = state
    }
    
    private let localModelFile = (name: "object_labeler", type: "tflite")
    
    private func analyze(imageBuffer: CMSampleBuffer){
        
    }
}
