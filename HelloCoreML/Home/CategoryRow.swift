//
//  CategoryRow.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/14.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    var items: [MLMetaModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: CGFloat(0)) {
                    ForEach(self.items) { model in
                        NavigationLink(destination: self.contentView(model: model)){
                            CategoryItem(model: model)
                        }
                    }
                }
            }
            .frame(height: CGFloat(185))
        }
    }
    
    func contentView(model: MLMetaModel) -> AnyView {
        if model.category == .Images {
            switch model.id {
            case 1001:
                return AnyView(FCRNDepthPredictionView())
            case 1002:
                return AnyView(MNISTClassifierView().environmentObject(MNISTClassificationModel()))
            case 1004:
                return AnyView(ImageClassifierView().environmentObject(ImageClassificationModel(mlModel: MobileNetV2().model)))
            case 1005:
                return AnyView(ImageClassifierView().environmentObject(ImageClassificationModel(mlModel: Resnet50().model)))
            case 1006:
                return AnyView(ImageClassifierView().environmentObject(ImageClassificationModel(mlModel: SqueezeNet().model)))
            case 1008:
                return AnyView(ObjectDetectionView())
            default:
                return AnyView(CircleImage(image: ImageStore.shared.image(name: "charleyrivers_feature.jpg")))
            }
        }else if model.category == .ArtStyles{
            switch model.id {
            case 1001:
                return AnyView(ArtStyleView())
            default:
                return AnyView(CircleImage(image: ImageStore.shared.image(name: "charleyrivers_feature.jpg")))
            }
        }
        return AnyView(CircleImage(image: ImageStore.shared.image(name: "charleyrivers_feature.jpg")))
    }
}

struct CategoryItem: View {
    var model: MLMetaModel
    var body: some View {
        VStack(alignment: .leading) {
            model.coverImage
            .renderingMode(.original)
            .resizable()
            .frame(width: 205, height: 155)
            .cornerRadius(5)
            Text(model.support == 1 ? model.name : "[WIP]---\(model.name)")
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}


struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(
            categoryName: mlModelData[0].category.rawValue,
            items: Array(mlModelData.prefix(4))
        )
    }
}
