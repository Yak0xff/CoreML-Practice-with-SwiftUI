//
//  ArtStyleView.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/27.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import SwiftUI
import CoreML

struct ArtStyleView: View {
    let modelMetas: [ArtStylesMeta] =  load("styles.json")
    let styleModel = ArtStylesModel()
    
    @State private var isPresented = false
    @State private var takePhoto = false
    @State private var sourceImage: UIImage?

    var body: some View {
        VStack(alignment: .leading) {
            self.sourceImage == nil ? AnyView(ArtStylePlaceholdView()) : ZStack {
                GeometryReader { geo in
                    Image(uiImage: self.sourceImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width)
                        .padding(.bottom, 10.0)
                }
            }.toAnyView()
            HStack {
                Button(action: {
                    self.takePhoto = false
                    self.isPresented.toggle()
                }, label: {
                    Image(systemName: "photo")
                    .foregroundColor(Color.primary)
                }).font(.title)
                    .padding(.leading, 20.0)
                Spacer()
                    .frame(height: 45.0, alignment: .center)
                Button(action: {
                    self.takePhoto = true
                    self.isPresented.toggle()
                }, label: {
                    Image(systemName: "camera")
                        .foregroundColor(Color.primary)
                }).font(.title)
                    .padding(.trailing, 20.0)
            }
            .frame(maxWidth: .infinity, maxHeight: 45.0, alignment: .center)
            .background(Color.black.opacity(0.2))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: CGFloat(0)) {
                    ForEach(self.modelMetas) { meta in
                        ArtStyleModelView(meta: meta)
                            .onTapGesture {
                                self.processArtStyle(meta: meta)
                            }
                    }
                }
            }
            .frame(height: CGFloat(120))
            .background(Color.black.opacity(0.2))
        }
        .sheet(isPresented: self.$isPresented) {
            ShowImagePicker(image: self.$sourceImage, takePhoto: self.$takePhoto)
        }
        .navigationBarTitle(Text("Art Style Image"), displayMode: .inline)
    }
    
    private func processArtStyle(meta: ArtStylesMeta) {
        guard let readiedImage = self.sourceImage else {
            print("Error: No Picture")
            return
        }
        styleModel.processImage(readiedImage, style: meta.style) { resultImage in
            self.sourceImage = resultImage
        }
    }
}

struct ArtStylePlaceholdView: View {
    var body: some View {
        ZStack {
            Image(systemName: "photo.fill")
            .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.init(.lightGray))
                .shadow(color: .secondary, radius: 5)
        }.padding()
    }
}

struct ArtStyleModelView: View {
    var meta: ArtStylesMeta
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(meta.cover)
            .renderingMode(.original)
            .resizable()
            .frame(width: 80, height: 80)
            .cornerRadius(5)
            HStack {
                Spacer()
                Text(meta.name)
                    .foregroundColor(.white)
                    .font(.caption)
                Spacer()
            }
            
            
        }
        .padding(.leading, 5)
        .padding(.trailing, 5)
    }
}
