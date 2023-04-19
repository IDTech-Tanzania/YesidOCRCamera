//
//  OCRResponse.swift
//  YesidOCRCamera
//
//  Created by Emmanuel Mtera on 4/4/23.
//

import Foundation

public struct OCRResponse {
    public let documentImages: [String: String]?
    public let documentText: [String: String]?
}
