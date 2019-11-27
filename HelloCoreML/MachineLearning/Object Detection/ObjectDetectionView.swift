//
//  ObjectDetectionView.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/18.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import SwiftUI
import CoreML


struct ObjectDetectionView: View {
    var body: some View {
        VStack {
            Spacer()
            VisionObjectRecognitionViewController()
            Spacer()
        }
        .background(Color.gray)
        .navigationBarTitle(Text("ObjectDetection"), displayMode: .inline)
    }
}
