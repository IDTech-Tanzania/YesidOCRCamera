import SwiftUI
import Combine
import YesidOCRCameraFramework

struct MainApp: View {
    var body: some View {
        OCRScreen()
    }
    
}

struct OCRScreen: View {
    @State var cardImageResults: [String:String]? = [:]
    @State var cardTextResults: [String:String]? = [:]
    @State var isResultSet: Bool = false
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
            if(!self.isResultSet){
                HStack{
                    OCRCameraUI(configurationBuilder: OCRConfigurationBuilder().setUserLicense(userLicense: "1234")){
                        results in
                        print(results)
                    }
                }
                .cornerRadius(6)
                .padding(.vertical,10)
                .frame(maxWidth:.infinity)
                .frame(height:UIScreen.screenHeight)
            }
            if(self.isResultSet){
                OCRCompletedScanView(cardImageResults: self.$cardImageResults, cardTextResults: self.$cardTextResults, isResultSet: self.$isResultSet)
                    .padding(.vertical,20)
            }
        }
    }
}

struct OCRCompletedScanView: View {
    @State var hideRecapture:Bool = false
    @Binding var cardImageResults: [String:String]?
    @Binding var cardTextResults: [String:String]?
    @Binding var isResultSet: Bool
    var body: some View {
      MainView()
    }
    
    @ViewBuilder
    func MainView()-> some View {
        if(self.cardImageResults!.keys.contains("Portrait") && self.cardTextResults!.count > 0){
            ResultsView()
        }else{
            NoResultsView()
        }
    }
    
    @ViewBuilder
    func ResultsView()-> some View {
        VStack{
            ZStack(alignment:.bottom) {
                Image(base64String: self.cardImageResults!["Document front side"] ?? "")?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(6)
                if(!hideRecapture){
                    Button(
                        "Recapture", action: {
                            self.isResultSet = false
                            self.cardImageResults = [:]
                            self.cardTextResults = [:]
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
                    Image(base64String: self.cardImageResults!["Portrait"] ?? "")?
                        .resizable()
                        .cornerRadius(6)
                }
                 .frame(maxWidth:.infinity,maxHeight: 300)
                
                ForEach((self.cardTextResults?.sorted(by:>))!,id:\.key){key,value in
                    HStack(alignment: .center){
                        Text("\(key)")
                        Spacer()
                        Text("\(value)")
                    }
                    .cornerRadius(6.0)
                    .padding(.vertical, 1.0)
                    
                }
                if(self.cardImageResults!.keys.contains("Signature")){
                    HStack(alignment: .center){
                        Text("Signature")
                        Spacer()
                        Image(base64String: self.cardImageResults!["Signature"] ?? "")?
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
                    self.isResultSet = false
                    self.cardImageResults = [:]
                    self.cardTextResults = [:]
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
