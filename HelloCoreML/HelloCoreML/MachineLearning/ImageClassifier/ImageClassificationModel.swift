//
//  ImageClassificationModel.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/16.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO


final class ImageClassificationModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var classificationResult: String = ""
    var model: MLModel = MobileNetV2().model
    
    init(mlModel model:MLModel) {
        self.model = model
    }
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: self.model)
            return VNCoreMLRequest(model: model) { [weak self] (request, error) in
                self?.handleClassification(for: request, error: error)
            }
        } catch {
            fatalError("Error: Can not load Vision ML Model. \(error).")
        }
    }()
    
    func startPredictClassification() {
        self.classificationResult = "Classifying..."
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(self.image!.imageOrientation.rawValue))
        
        guard let ciImage = CIImage(image: self.image!) else {
            fatalError("Unable to create \(CIImage.self) from \(String(describing: image))")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation ?? .up)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    private func handleClassification(for request: VNRequest, error: Error?) {
          DispatchQueue.main.async {
              guard let results = request.results else {
                  self.classificationResult = "Unable to classify image.\n\(error!.localizedDescription)"
                  return
              }
              let observations = results as! [VNClassificationObservation]
              
              if observations.isEmpty {
                  self.classificationResult = "Nothing recognized!"
              } else {
                  let topClassifications = observations.prefix(2)
                  let descriptions = topClassifications.map { classification in
                      return String(format: "%.2f %@", classification.confidence, classification.identifier)
                  }
                  self.classificationResult = "Classification:\n" + descriptions.joined(separator: "\n")
              }
          }
      }
}
