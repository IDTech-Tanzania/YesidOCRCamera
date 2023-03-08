//
//  LocalizeUtils.swift
//  YesidOCRCamera
//
//  Created by Emmanuel Mtera on 3/6/23.
//
import UIKit

class LocalizeUtils: NSObject {
    
    static let defaultLocalizer = LocalizeUtils()
    var appBundle = Bundle.main
    
    func setSelectedLanguage(lang: String) {
        guard let langPath = Bundle.main.path(forResource: lang, ofType: "lproj") else {
            appBundle = Bundle.main
            return
        }
        appBundle = Bundle(path: langPath)!
        UserDefaults.standard.set([lang], forKey: "AppleLanguages")
    }
    
    func getSelectedLanguage() -> String? {
        guard let langs = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String], let lang = langs.first else {
            return nil
        }
        return lang.prefix(2).lowercased()
    }

    
    func stringForKey(key: String) -> String {
        return appBundle.localizedString(forKey: key, value: "", table: nil)
    }
}

