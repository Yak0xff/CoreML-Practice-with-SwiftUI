//
//  MNISTClassifierView.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/16.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import SwiftUI
import CoreML
import Vision

struct MNISTClassifierView: View {
    private let drawCanvasView = DrawCanvasView()
    
    @EnvironmentObject var mnistModel: MNISTClassificationModel
    
    fileprivate func classification() {
        self.mnistModel.startPredictClassification()
    }
    
    var body: some View {
        VStack {
            drawCanvasView
                .background(Color.black)
                .frame(height: CGFloat(450))
            HStack(alignment: .top) {
                Button(action: {
                    self.drawCanvasView.earsing()
                }) {
                    HStack {
                        Image(systemName: "rectangle.grid.1x2.fill")
                        Text("Clear")
                    }
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(5)
                }
                Spacer()
                    .frame(width: 50)
                Button(action: {
                    guard let context = self.drawCanvasView.getConext(), let inputImage = context.makeImage() else {
                        fatalError("Error: Get context or make image fail.")
                    }
                    self.mnistModel.cgImage = inputImage
                    self.classification()
                }) {
                    Image(systemName: "rectangle.grid.1x2.fill")
                    Text("Predict")
                }
                .padding()
                .foregroundColor(Color.red)
                .background(Color.blue)
                .cornerRadius(5)
            }
            Spacer()
            VStack {
                Text(self.mnistModel.classificationText)
                    .bold()
                    .font(.system(size: 150))
            }
            .padding()
            .frame(width: 300, height: 300, alignment: .center)
            .background(Color.gray)
        }
        .background(Color.white)
        .navigationBarTitle(Text("MNISTClassifier"), displayMode: .inline)
    }
}


 
