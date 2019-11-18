//
//  HeatmapView.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/15.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import SwiftUI
import UIKit

class HeatmapView: UIView {
    var heatmap: Array<Array<Double>>? = nil {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext(){
            context.clear(rect)
            
            guard let heatmap = self.heatmap else {
                return
            }
            
            let size = self.bounds.size
            let heatmap_w = heatmap.count
            let heatmap_h = heatmap.first?.count ?? 0
            let width = size.width / CGFloat(heatmap_w)
            let height = size.height / CGFloat(heatmap_h)
            
            for j in  0 ..< heatmap_h {
                for i in 0 ..< heatmap_w {
                    let value = heatmap[i][j]
                    var alpha = CGFloat(value)
                    if alpha > 1 {
                        alpha = 1
                    } else if alpha < 0 {
                        alpha = 0
                    }
                    
                    let rect = CGRect(x: CGFloat(i) * width, y: CGFloat(j) * height, width: width, height: height)
                    
                    let color = UIColor(white: 1 - alpha, alpha: 1)
                    let bpath = UIBezierPath(rect: rect)
                    
                    color.set()
                    bpath.fill()
                }
            }
        }
        
    }
}


//struct HeatmapContentView: UIViewRepresentable {
//    typealias UIViewType = HeatmapView
//
//    @Binding var heatmap: Array<Array<Double>>?
//
//    func makeUIView(context: UIViewRepresentableContext<HeatmapContentView>) -> HeatmapContentView.UIViewType {
//        return HeatmapView()
//    }
//
//    func updateUIView(_ uiView: HeatmapContentView.UIViewType, context: UIViewRepresentableContext<HeatmapContentView>) {
//        uiView.heatmap = heatmap
//    }
//}
