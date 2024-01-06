//
//  GridView.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/6/24.
//

import SwiftUI

struct GridView: View {
    @Binding var selectedImage: Item?
    @Binding var showDetailView: Bool
    var images: [Item]
    var gridType: GridType

    var body: some View {
        switch gridType {
        case .list:
            ImageListView(selectedImage: $selectedImage, showDetailView: $showDetailView, images: images)
        case .tile:
            ImageGridView(selectedImage: $selectedImage, showDetailView: $showDetailView, images: images)
        }
    }
}

