//
//  ImageListView.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageListView: View {
    @Binding var selectedImage: Item?
    @Binding var showDetailView: Bool
    
    var images: [Item]
    
    var body: some View {
        if !images.isEmpty {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(images, id: \.self) { image in
                        Button {
                            self.selectedImage = image
                            withAnimation(.easeInOut) {
                                self.showDetailView = true
                            }
                        } label: {
                            imageRowView(for: image)
                        }
                        
//                            .onTapGesture {
//                                self.selectedImage = image
//                                withAnimation(.easeInOut) {
//                                    self.showDetailView = true
//                                }
//                            }
                    }
                }
            }
            .padding(.horizontal)
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
    
    @ViewBuilder
    func imageRowView(for image: Item) -> some View {
        VStack(alignment: .leading) {
            HStack {
                WebImage(url: URL(string: image.media.m))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                    )
                
                Text(image.title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .accessibilityLabel("Image Title: \(image.title)")
                
            }
            
            Divider()
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    ContentView()
}
