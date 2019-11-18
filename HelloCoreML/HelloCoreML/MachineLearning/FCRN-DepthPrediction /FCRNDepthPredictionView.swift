//
//  FCRN-DepthPredictionView.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/15.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import SwiftUI

struct FCRNDepthPredictionView: View {
    var body: some View {
        VStack {
            Spacer()
            LiveImageViewController()
            Spacer()
        }
        .background(Color.gray)
        .navigationBarTitle(Text("FCRN-DepthPrediction"), displayMode: .inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FCRNDepthPredictionView()
    }
}
