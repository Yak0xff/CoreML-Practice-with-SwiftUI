//
//  ImageClassifierView.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/16.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import SwiftUI


struct ImageClassifierView: View {
    @EnvironmentObject var classificationModel: ImageClassificationModel
    @State private var isPresented = false
    @State private var takePhoto = false
    
    fileprivate func classification() {
        self.classificationModel.startPredictClassification()
    }
    
    var body: some View {
        VStack {
                self.classificationModel.image == nil ? PlaceholdView().toAnyView() : ZStack {
                    Image(uiImage: self.classificationModel.image!)
                    .resizable()
                        .aspectRatio(contentMode: .fill)
                        .onTapGesture {
                            self.classification()
                    }
                    
                    Text(self.classificationModel.classificationResult.localizedCapitalized)
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                        .shadow(color: .black, radius: 1, x: 2, y: 2)
                        .padding()
                    .background(Rectangle()
                        .foregroundColor(Color.init(.systemBackground))
                        .opacity(0.33)
                        .cornerRadius(10))
                    
                }.toAnyView()
            HStack {
                Button(action: {
                    self.takePhoto = false
                    self.classificationModel.classificationResult = "Tap to Classify"
                    self.isPresented.toggle()
                }, label: {
                    Image(systemName: "photo")
                }).font(.title)
                Spacer()
                    .frame(width: 250, height: 44, alignment: .trailing)
                Button(action: {
                    self.takePhoto = true
                    self.classificationModel.classificationResult = "Tap to Classify"
                    self.isPresented.toggle()
                }, label: {
                    Image(systemName: "camera")
                }).font(.title)
            }.padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2)).toAnyView()
        }
        .sheet(isPresented: self.$isPresented) {
            ShowImagePicker(image: self.$classificationModel.image, takePhoto: self.$takePhoto)
        }
        .navigationBarTitle(Text("Image Classifier"), displayMode: .inline)
        .onDisappear {
            self.classificationModel.image = nil
        }
    }
}


struct PlaceholdView: View {
    var body: some View {
        ZStack {
            Color(.red)
            Image(systemName: "photo.fill")
            .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.init(.systemRed))
                .shadow(color: .secondary, radius: 5)
        }.padding()
    }
}


extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}
