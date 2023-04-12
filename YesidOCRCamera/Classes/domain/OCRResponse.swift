//
//  OCRResponse.swift
//  YesidOCRCamera
//
//  Created by Emmanuel Mtera on 4/4/23.
//

import Foundation

public struct OCRResponse {
    let documentImages: [String: UIImage]
    let documentText: [String: String]
}
