//
//  OCRConfigurationBuilder.swift
//  YesidOCRCamera
//
//  Created by Emmanuel Mtera on 4/4/23.
//

import Foundation

import SwiftUI
import AVFoundation

public class OCRConfigurationBuilder {
    public init(){}
    private var userLicense = ""
    public func setUserLicense(userLicense: String) -> OCRConfigurationBuilder {
        self.userLicense = userLicense
        return self
    }
    
    func getUserLicense() -> String {
        return userLicense
    }
    
}
