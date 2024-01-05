//
//  ImageGridView.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageGridView: View {
    @Binding var selectedImage: Item?
    @Binding var showDetailView: Bool

    var images: [Item]
    
    let minColumnWidth: CGFloat = 100
    let spacing: CGFloat = 3
    
    var body: some View {
        GeometryReader { geometry in
            if !images.isEmpty {
                ScrollView {
                    LazyVGrid(columns: gridItems(for: geometry.size.width), spacing: spacing) {
                        ForEach(images, id: \.self) { image in
                            Button {
                                self.selectedImage = image
                                withAnimation(.easeInOut) {
                                    self.showDetailView = true
                                }
                            } label: {
                                gridRowView(for: image)
                            }
                        }
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Text("No Images Found, please refine your search.")
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .accessibilityLabel("No images found. Please refine your search.")
                    
                    Spacer()
                }
            }
        }
    }

    func gridItems(for width: CGFloat) -> [GridItem] {
        let numberOfColumns = max(1, Int(width / minColumnWidth))
        return Array(repeating: GridItem(.flexible(), spacing: spacing), count: numberOfColumns)
    }
    
    @ViewBuilder
    func gridRowView(for image: Item) -> some View {
        VStack(alignment: .leading) {
            WebImage(url: URL(string: image.media.m))
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
                )
                .accessibilityLabel("Image Title: \(image.title)")
        }
    }
}

#Preview {
    ContentView()
}
