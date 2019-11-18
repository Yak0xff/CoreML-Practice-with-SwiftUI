/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing featured landmarks above a list of all of the landmarks.
*/

import SwiftUI

struct CategoryHome: View {
    var categories: [String: [MLMetaModel]] {
        Dictionary(
            grouping: mlModelData,
            by: { $0.category.rawValue }
        )
    }

    var body: some View {
        NavigationView {
            List {
                Header(headerImageName: "charleyrivers_feature.jpg")
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                
                ForEach(categories.keys.sorted(), id: \.self) { key in
                    CategoryRow(categoryName: key, items: self.categories[key]!)
                }
                .listRowInsets(EdgeInsets())
            }
            .navigationBarTitle(Text("SwiftUI + CoreML"))
        }
    }
}

struct Header: View {
    var headerImageName: String
    var body: some View {
        ImageStore.shared.image(name: headerImageName).resizable()
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
    }
}
