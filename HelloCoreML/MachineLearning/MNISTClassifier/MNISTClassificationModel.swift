//
//  MNISTClassificationModel.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/16.
//  Copyright © 2019 RobinChao. All rights reserved.
//
import UIKit
import CoreML
import Vision
import ImageIO


final class MNISTClassificationModel: ObservableObject {
    @Published var cgImage: CGImage? = nil
    @Published var classificationText: String = ""
    
    private lazy var mnistClassificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MNISTClassifier().model)
            let request = VNCoreMLRequest(model: model) { [weak self](request, error) in
                self?.handleClassification(for: request, error: error)
            }
            return request
        } catch {
            fatalError("Error: Can not load Vision ML Model. \(error).")
        }
    }()
    
    func startPredictClassification() {
        self.classificationText = "Classifying..."
        let ciImage = CIImage(cgImage: self.cgImage!)
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([self.mnistClassificationRequest])
        } catch {
            print("Error: Image Request Perform error \(error).")
        }
    }
    
    private func handleClassification(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationText = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            let observations = results as! [VNClassificationObservation]
            
            if observations.isEmpty {
                self.classificationText = "Nothing recognized!"
            } else {
                guard let best = observations.first else {
                    fatalError("Error: Can not get best result.")
                }
                self.classificationText = best.identifier
            }
        }
    }
}
