import SwiftUI
import Vision
import UIKit


struct DetectedRectangle: Identifiable {
    var id = UUID()
    var width: CGFloat = 0
    var height: CGFloat = 0
    var x: CGFloat = 0
    var y: CGFloat = 0
}

public struct YesidOCRCamera: View {
    @EnvironmentObject var ocrReader: OCRViewModel
    @EnvironmentObject var captureSession: OCRCaptureSession
    @State var rectangleSize: CGRect = .zero
    var tapGestureRecognizer = UITapGestureRecognizer()
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    public init(){
        
    }
    
    public var body: some View {
        VStack(alignment:.leading,spacing: 10) {
            FullCameraView()
        }
        .clipped()
        .onAppear{
            if(self.ocrReader.isLoading){
                captureSession.stop()
            }
        }
    }
    
    @ViewBuilder
    func MainCameraView() -> some View {
        CameraView(captureSession: self.captureSession.captureSession).onTapGesture {
            tapGestureRecognizer.addTarget(self, action: #selector(self.captureSession.focusAndExposeTap))
        }
    }
    
    @ViewBuilder
    func FullCameraView() -> some View {
        ZStack{
            if(self.ocrReader.isLoading){
                if #available(iOS 15.0, *) {
                    Rectangle().overlay{
                        HStack(spacing:10){
                            SwiftUI.Text("\(self.ocrReader.direction)")
                                .foregroundColor(.white)
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                    }.frame(maxWidth:self.screenWidth,maxHeight: self.screenHeight)
                        .background(.black)
                    
                } else {
                    if self.ocrReader.isLoading {
                        Rectangle().overlay(
                            HStack(spacing: 10) {
                                SwiftUI.Text("\(self.ocrReader.direction)")
                                    .foregroundColor(.white)
                                ActivityIndicatorView(style: .large, color: .white)
                            }
                        )
                        .frame(maxWidth: self.screenWidth, maxHeight: self.screenHeight)
                        .background(Color.black)
                    }
                }
            }else{
                if(!self.ocrReader.isResultSet && !self.ocrReader.isError){
                    MainCameraView()
                    if #available(iOS 14.0, *) {
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(ocrReader.placeMentColor, lineWidth: 3)
                            .padding(20)
                            .frame(width: screenWidth-20, height: 250)
                            .background(rectReader($rectangleSize))
                            .onChange(of: rectangleSize){ new in
                                self.ocrReader.rectangleSize = rectangleSize
                            }
                    } else {
                        
                    }
                    
                    VStack{
                        SwiftUI.Text("\(self.ocrReader.direction)")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .if(self.ocrReader.isLoading){view in
                        view.offset(y:0)
                    }
                    .if(!self.ocrReader.isLoading){view in
                        view.offset(y:130)
                    }
                }
            }
        }
        .frame(maxWidth:self.screenWidth,maxHeight: self.screenHeight)
    }
    
}

struct ChildSizeReader<Content: View>: View {
    @Binding var size: CGSize
    let content: () -> Content
    var body: some View {
        ZStack {
            content()
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: SizePreferenceKey.self, value: proxy.size)
                    }
                )
        }
        .onPreferenceChange(SizePreferenceKey.self) { preferences in
            self.size = preferences
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

func rectReader(_ binding: Binding<CGRect>, _ space: CoordinateSpace = .global) -> some View {
    GeometryReader { (geometry) -> Color in
        let rect = geometry.frame(in: space)
        DispatchQueue.main.async {
            binding.wrappedValue = rect
        }
        return .clear
    }
}

struct ActivityIndicatorView: UIViewRepresentable {
    var style: UIActivityIndicatorView.Style
    var color: UIColor
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(style: style)
        indicatorView.color = color
        indicatorView.startAnimating()
        return indicatorView
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}
