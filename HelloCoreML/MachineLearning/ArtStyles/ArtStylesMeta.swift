//
//  ArtStylesMeta.swift
//  HelloCoreML
//
//  Created by Robin on 2019/11/27.
//  Copyright © 2019 RobinChao. All rights reserved.
//

import SwiftUI


struct ArtStylesMeta: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var cover: String
    var style: ArtStyle
}

