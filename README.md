# yes:ID IOS Document Reader SDK

# Installation
You can install the YesidOCRCamera library using CocoaPods. Add the following line to your project's Podfile:

`pod 'YesidOCRCamera'`

Then run `pod install` command to install the library.

# Import the YesidOCRCamera module:

In your project's Swift file where you want to use the YesidOCRCamera library, add the following import statement:

```
import YesidOCRCamera
```

# Instantiate and present the OCRCameraUI view:

`Configure the SDK by passing the license or any other configuration params`

```
let configuration: OCRConfigurationBuilder = OCRConfigurationBuilder().setUserLicense(userLicense: "YOUR_LICENSE")

```
`Use the SDK by calling OCRCameraUI`
```
@main
struct iOSApp: App {
    var body: some Scene {
        WindowGroup {
                OCRCameraUI(configurationBuilder: configuration) { response in
                    print(response)
                }
        }
    }
}
```

# Handle OCR responses:

When the OCR process completes, the OCRCameraUI view will call the callback function you provided with the OCRReponse. You can handle the response accordingly in your app.

