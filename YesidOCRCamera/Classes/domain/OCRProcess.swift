//
//  OCRProcess.swift
//  YesidOCRCamera
//
//  Created by Emmanuel Mtera on 4/4/23.
//

import Foundation


protocol OCRProcess {
    func processCardImage(image: UIImage, completion: @escaping (Result<OCRResponse, Error>) -> Void)
}
