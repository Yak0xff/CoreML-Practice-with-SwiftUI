//
//  StyleInput.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/27.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import CoreML



class ArtStyleInput: MLFeatureProvider {
    var input: CVPixelBuffer
    
    var featureNames: Set<String> {
        get {
            return ["inputImage"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if  featureName == "inputImage" {
            return MLFeatureValue(pixelBuffer: input)
        }
        return nil
    }
    
    init(input: CVPixelBuffer) {
        self.input = input
    }
}
