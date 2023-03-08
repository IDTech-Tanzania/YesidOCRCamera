import SwiftUI
import Combine
import YesidOCRCamera

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

@main
struct YesIDApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            MainApp(appDelegate:appDelegate)
        }
    }
}

