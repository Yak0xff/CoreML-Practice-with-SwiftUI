//
//  DrawView.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/15.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import UIKit
import SwiftUI

final class DrawView: UIView {
    var linewidth = CGFloat(15) {
        didSet {
            setNeedsDisplay()
        }
    }
    var color = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    var lines: [Line] = []
    var lastPoint: CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = touches.first!.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newPoint = touches.first!.location(in: self)
        
        lines.append(Line(start: lastPoint, end: newPoint))
        lastPoint = newPoint
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let drawPath = UIBezierPath()
        drawPath.lineCapStyle = .round
        
        for line in lines {
            drawPath.move(to: line.start)
            drawPath.addLine(to: line.end)
        }
        drawPath.lineWidth = linewidth
        color.set()
        drawPath.stroke()
    }
    
    func getViewContext() -> CGContext? {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        
        let bitmapInfo = CGImageAlphaInfo.none.rawValue
        
        let context = CGContext(data: nil,
                                width: 28,
                                height: 28,
                                bitsPerComponent: 8,
                                bytesPerRow: 28,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo)
        
        context!.translateBy(x: 0, y: 28)
        context!.scaleBy(x: 28 / self.frame.size.width, y: -28 / self.frame.size.height)
        
        self.layer.render(in: context!)
        
        return context
    }
    
    func clear() {
        self.lines = []
        self.backgroundColor = UIColor.black
        setNeedsDisplay()
    }
}


class Line {
    var start, end: CGPoint
    
    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
}


struct DrawCanvasView: UIViewRepresentable{
    let drawView = DrawView()
    
    func makeUIView(context: Context) -> DrawView {
        return drawView
    }
    
    func updateUIView(_ uiView: DrawView, context: Context) {
        drawView.setNeedsDisplay()
    }
    
    func getConext() -> CGContext? {
        return drawView.getViewContext()
    }
    
    func earsing(){
        drawView.clear()
    }
    
}
