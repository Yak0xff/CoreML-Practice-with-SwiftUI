//
//  MLModel.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/14.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import SwiftUI


struct MLMetaModel: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    fileprivate var cover: String
    var category: Category
    var subtitle: String
    var desc: String
    var support: Int
    
    
    enum Category: String, CaseIterable, Codable, Hashable {
        case Images = "Images"
        case Text = "Text"
    }
}

extension MLMetaModel {
    var coverImage: Image {
        ImageStore.shared.image(name: cover)
    }
}
