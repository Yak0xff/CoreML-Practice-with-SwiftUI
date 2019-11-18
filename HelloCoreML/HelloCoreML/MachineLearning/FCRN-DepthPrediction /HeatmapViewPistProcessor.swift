//
//  HeatmapViewPistProcessor.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/15.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import CoreML

class HeatmapViewPistProcessor {
    func convertTo2DArray(from heatmaps: MLMultiArray) -> Array<Array<Double>> {
        guard heatmaps.shape.count >= 3 else {
            print("Error: heatmap's shape is invalid. \(heatmaps.shape)")
            return []
        }
        
        let _ /*keypoint_number*/ = heatmaps.shape[0].intValue
        let heatmap_w = heatmaps.shape[1].intValue
        let heatmap_h = heatmaps.shape[2].intValue
        
        var convertedHeatmap: Array<Array<Double>> = Array(repeating: Array(repeating: 0.0, count: heatmap_w), count: heatmap_h)
        
        var minimumValue = Double.greatestFiniteMagnitude
        var maximumValue = -Double.greatestFiniteMagnitude
        
        for i in 0 ..< heatmap_w {
            for j in 0 ..< heatmap_h {
                let index = i * (heatmap_h) + j
                let confidence = heatmaps[index].doubleValue
                guard confidence > 0 else { continue }
                convertedHeatmap[j][i] = confidence
                
                if minimumValue > confidence {
                    minimumValue = confidence
                }
                if maximumValue < confidence {
                    maximumValue = confidence
                }
            }
        }
        
        let minmaxGap = maximumValue - minimumValue
        for i in 0 ..< heatmap_w {
            for j in 0 ..< heatmap_h {
                convertedHeatmap[j][i] = (convertedHeatmap[j][i] - minimumValue) / minmaxGap
            }
        }
        return convertedHeatmap
    }
}
