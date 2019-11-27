//
//  ArtStylesModel.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/27.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import CoreML
import Vision
import ImageIO
import UIKit

enum ArtStyle: Int, CaseIterable, Codable, Hashable {
       case Mosaic = 0
       case Scream = 1
       case Muse = 2
       case Udanie = 3
       case Candy = 4
       case Feathers = 5
   }

final class ArtStylesModel {
    @Published var sourceImage: UIImage? = nil
    @Published var resultImage: UIImage? = nil
    
    
   
    
    var style: ArtStyle = .Mosaic
    
    var models: [MLModel] = []
    private let imageSize = 720
    
    
    var museModel: FNS_La_Muse!
    var candy:FNS_Candy!
    var Feathers:FNS_Feathers!
    var udanieModel:FNS_Udnie!
    var mosaic:FNS_Mosaic!
    var screamModel:FNS_The_Scream!
    
    init() {
        do {
            let pathMuse = Bundle.main.path(forResource: "FNS-La-Muse", ofType: "mlmodelc")
            let pathCandy = Bundle.main.path(forResource: "FNS-Candy", ofType: "mlmodelc")
            let pathFeathers = Bundle.main.path(forResource: "FNS-Feathers", ofType: "mlmodelc")
            let pathUdanie = Bundle.main.path(forResource: "FNS-Udnie", ofType: "mlmodelc")
            let pathMosaic = Bundle.main.path(forResource: "FNS-Mosaic", ofType: "mlmodelc")
            let pathScream = Bundle.main.path(forResource: "FNS-The-Scream", ofType: "mlmodelc")
            
            museModel = try FNS_La_Muse(contentsOf:URL(fileURLWithPath: pathMuse!) )
            candy = try FNS_Candy(contentsOf:URL(fileURLWithPath: pathCandy!) )
            Feathers = try FNS_Feathers(contentsOf:URL(fileURLWithPath: pathFeathers!) )
            udanieModel = try FNS_Udnie(contentsOf:URL(fileURLWithPath: pathUdanie!) )
            mosaic = try FNS_Mosaic(contentsOf:URL(fileURLWithPath: pathMosaic!) )
            screamModel = try FNS_The_Scream(contentsOf:URL(fileURLWithPath: pathScream!) )
            
            models.append(mosaic.model)
            models.append(screamModel.model)
            models.append(museModel.model)
            models.append(udanieModel.model)
            models.append(candy.model)
            models.append(Feathers.model)
        } catch let error {
            print("Error: ArtStyle Model Initializer error. \(error)")
        }
    }
    
    func processImage(_ image: UIImage, style: ArtStyle, compeletion: (_ result: UIImage?) -> ()) {
        let model = models[style.rawValue]
        if let pixelBuffered = image.pixelBuffer(width: 720, height: 720) {
            let input = ArtStyleInput(input: pixelBuffered)
            let outFeatures = try! model.prediction(from: input)
            let output = outFeatures.featureValue(for: "outputImage")!.imageBufferValue!
            if let result = UIImage(pixelBuffer: output) {
                compeletion(result)
            }else{
                compeletion(nil)
            }
        }
    }
    
    private func stylizeImage(cgImage: CGImage, model: MLModel) -> CGImage {
        let input = ArtStyleInput(input: pixelBuffer(cgImage: cgImage, width: imageSize, height: imageSize))
        let outFeatures = try! model.prediction(from: input)
        let output = outFeatures.featureValue(for: "outputImage")!.imageBufferValue!
        CVPixelBufferLockBaseAddress(output, .readOnly)
        let width = CVPixelBufferGetWidth(output)
        let height = CVPixelBufferGetHeight(output)
        let data = CVPixelBufferGetBaseAddress(output)!
        
        let outContext = CGContext(data: data,
                                   width: width,
                                   height: height,
                                   bitsPerComponent: 8,
                                   bytesPerRow: CVPixelBufferGetBytesPerRow(output),
                                   space: CGColorSpaceCreateDeviceRGB(),
                                   bitmapInfo: CGImageByteOrderInfo.order32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)!
        let outImage = outContext.makeImage()!
        CVPixelBufferUnlockBaseAddress(output, .readOnly)
        
        return outImage
    }
    ///Method which converts given CGImage to CVPixelBuffer.
    private func pixelBuffer(cgImage: CGImage, width: Int, height: Int) -> CVPixelBuffer {
        var pixelBuffer: CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
        if status != kCVReturnSuccess {
            fatalError("Cannot create pixel buffer for image")
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue)
        let context = CGContext(data: data, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer!
    }

}
