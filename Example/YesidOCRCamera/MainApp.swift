import SwiftUI
import Combine
import YesidOCRCamera

struct MainApp: View {
    @State var appDelegate: AppDelegate = AppDelegate()
    var body: some View {
        OCRScreen()
            .environmentObject(appDelegate.captureSession)
            .environmentObject(appDelegate.cardModel)
    }
    
}

struct OCRScreen: View {
    @EnvironmentObject var ocrModel:OCRViewModel
    @EnvironmentObject var captureSession: OCRCaptureSession
    var body: some View {
        VStack {
            
            ZStack{
                ScrollView{
                    OCRCameraView()
                }
                .padding(.horizontal,10)
            }
        }
    }
  
    @ViewBuilder
    func OCRCameraView()-> some View {
        VStack {
            if(!self.ocrModel.isResultSet){
                HStack{
                    YesidOCRCamera()
                        .environmentObject(self.ocrModel)
                        .environmentObject(self.captureSession)
                        .onDisappear(){
                            self.captureSession.stop()
                            self.ocrModel.startOCRDetection = false
                        }
                        .onAppear(){
                            self.captureSession.start()
                            self.ocrModel.startOCRDetection = true
                        }
                        .onChange(of: self.ocrModel.startOCRDetection){
                            newvalue in
                            if(newvalue){
                                self.ocrModel.performOcr()
                            }
                        }
                }
                .cornerRadius(6)
                .padding(.vertical,10)
                .frame(maxWidth:.infinity)
                .frame(height:UIScreen.screenHeight)
            }
            if(self.ocrModel.isResultSet){
                OCRCompletedScanView()
                    .environmentObject(self.ocrModel)
                    .padding(.vertical,20)
            }
        }
    }
}

struct OCRCompletedScanView: View {
    @EnvironmentObject var viewModel: OCRViewModel
    @State var hideRecapture:Bool = false
    var body: some View {
      MainView()
    }
    
    @ViewBuilder
    func MainView()-> some View {
        if(self.viewModel.getCardImageResults().keys.contains("Portrait") && self.viewModel.getCardTextResults()!.count > 0){
            ResultsView()
        }else{
            NoResultsView()
        }
    }
    
    @ViewBuilder
    func ResultsView()-> some View {
        VStack{
            ZStack(alignment:.bottom) {
                Image(base64String: viewModel.getCardImageResults()["Document front side"] ?? "")?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(6)
                if(!hideRecapture){
                    Button(
                        "Recapture", action: {
                            self.viewModel.clearData()
                        })
                    .offset(x: 0, y: 10)
                }
            }
            .padding()
            .cornerRadius(6.0)
            .shadow(radius: 1)
            Text("").padding(.vertical,5)
            VStack(spacing: 16){
                HStack{
                    Image(base64String: viewModel.getCardImageResults()["Portrait"] ?? "")?
                        .resizable()
                        .cornerRadius(6)
                }
                 .frame(maxWidth:.infinity,maxHeight: 300)
                
                ForEach((viewModel.getCardTextResults()?.sorted(by:>))!,id:\.key){key,value in
                    HStack(alignment: .center){
                        Text("\(key)")
                        Spacer()
                        Text("\(value)")
                    }
                    .cornerRadius(6.0)
                    .padding(.vertical, 1.0)
                    
                }
                if(self.viewModel.getCardImageResults().keys.contains("Signature")){
                    HStack(alignment: .center){
                        Text("Signature")
                        Spacer()
                        SwiftUI.Image(base64String: viewModel.getCardImageResults()["Signature"] ?? "")?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(6)
                            .frame(width: 150, height: 100, alignment: .trailing)
                    }
                    .cornerRadius(6.0)
                    .padding(.vertical, 1.0)
                }
                
            }
            .padding()
            .cornerRadius(6.0)
            .shadow(radius: 1)
        }
        .padding(.horizontal,1)
    }
    
    @ViewBuilder
    func NoResultsView()-> some View{
        VStack(alignment:.center){
            Text("Sorry some document fields not detected, please recapture the document")
            Button(
                "Recapture",
                action: {
                    self.viewModel.clearData()
                })
            .offset(x: 0, y: 10)
        }
        .padding(1)
    }
}

extension SwiftUI.Image {
    init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        guard let uiImage = UIImage(data: data) else { return nil }
        self = Image(uiImage: uiImage)
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
