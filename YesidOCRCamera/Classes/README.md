# yes:ID IOS Document Reader SDK

# Getting started
# Installation
```
1. Add the yesid ocr to your pod file
pod "YesidOCRCamera" then pod install

2. Copy the object_labler.tflite file found in YesidOCRCamera/Assets Pods folder  to the projects app bundle:
In your pod's project navigator, select the top-level project.
Select the "Build Phases" tab.
Expand the "Copy Bundle Resources" build phase.
Click the "+" button to add a new file.
Select your object_labler.tflite model file and click "Add".

```
# Usage
In your **AppDelegate** class include the OCRCaptureSession and OCRViewModel
```
import SwiftUI
import Combine

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let captureSession = OCRCaptureSession()
    let cardModel = OCRViewModel()
    
    var cancellables = [AnyCancellable]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        captureSession.$sampleBuffer
            .subscribe(cardModel.subject).store(in: &cancellables)
        return true
    }
}
```
In your main **App** you can pass the appdelegate as a parameter as follows
```
@main
struct YesIDApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            YesidMainApp(appDelegate:appDelegate)
        }
    }
}
```
Then in your **MainApp** struct pass captureSession and CardModel as environmentObjects make sure start and stop the capture session onAppear and onDisappear respectively. Use **self.appDelegate.cardModel.performOcr()** to startOCRDetection, the default value is false.
```
struct YesidMainApp: View {
    @State var appDelegate: AppDelegate = AppDelegate()
    var body: some View {
        OCRScreen()
                .environmentObject(appDelegate.captureSession)
                .environmentObject(appDelegate.cardModel)
                .onDisappear(){
                    self.appDelegate.captureSession.stop()
                }
                .onAppear(){
                        self.appDelegate.captureSession.start()
                }
                .onChange(of: self.appDelegate.cardModel.startOCRDetection){
                    newvalue in
                    if(newvalue){
                        self.appDelegate.cardModel.performOcr()
                    }
                }
    }
```
The main **OCRScreen** call **YesidOCRCamera**
```
struct OCRScreen: View {
    @EnvironmentObject var cardModel:OCRViewModel
    @EnvironmentObject var captureSession: OCRCaptureSession
     var body: some View {
            YesidOCRCamera()
                    .environmentObject(self.cardModel)
                    .environmentObject(self.captureSession)
    }
```

# Getting the results
First check if results is set by using **self.cardModel.isResultSet**
```
if(self.cardModel.isResultSet){
    // get results here
}
```
**Getting text results**
Use **self.cardModel.getCardTextResults()** to get all text results
```
ForEach((self.cardModel.getCardTextResults()?.sorted(by:>))!,id:\.key){key,value in
    HStack(alignment: .center){
        CustomText(text:key)
        Spacer()
        CustomText(text:value)
    }
}
```
**Getting image results**
Use **self.cardModel.getCardImageResults()** to get all image results in a dictionary
```
Image(base64String: viewModel.getCardImageResults()["Signature"] ?? "")?
        .resizable()
        .aspectRatio(contentMode: .fit)
        .cornerRadius(6)
        .frame(width: 150, height: 100, alignment: .trailing)
```

The image is a **base64** string so the following extension will work fine
```
extension SwiftUI.Image {
    init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        guard let uiImage = UIImage(data: data) else { return nil }
        self = SwiftUI.Image(uiImage: uiImage)
    }
}
```

