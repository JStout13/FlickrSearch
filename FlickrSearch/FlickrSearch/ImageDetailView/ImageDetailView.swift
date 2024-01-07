//
//  ImageDetailView.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageDetailView: View {
    @EnvironmentObject var viewModel: SearchViewModel
    @State private var isFetchingImageSize: Bool = true
    @State private var imageWidth: CGFloat = 0
    @State private var imageHeight: CGFloat = 0
    
    var image: Item
    @Binding var showDetailView: Bool
    
    var body: some View {
        VStack {
            
            topHeader()
            
            VStack {
                Section {
                    WebImage(url: URL(string: image.media.m))
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 400)
                }
                
                Section(header: Text("Image Information")) {
                    infoRowView(title: "Title:", info: image.title)
                    infoRowView(title: "Description:", info: image.description)
                    if isFetchingImageSize {
                        infoRowView(title: "", info: "Fetching Image Size...")
                    } else {
                        infoRowView(title: "Image Size:", info: "Width: \(imageWidth) Height: \(imageHeight)")
                    }
                    infoRowView(title: "Author:", info: image.author)
                    infoRowView(title: "Date Taken:", info: formatDate(image.dateTaken))
                    infoRowView(title: "Published:", info: formatDate(image.published))
                    infoRowView(title: "Tags:", info: image.tags)
                }
            }
            .padding(.horizontal, 16)
        }
        .background(Color(.systemBackground))
        .onAppear {
            fetchImageSize()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMsg), dismissButton: .default(Text("OK")))
        }
    }

    @ViewBuilder
    func topHeader() -> some View {
        HStack {
            Button {
                withAnimation(.easeInOut) {
                    showDetailView = false
                }
            } label: {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
            }
            
            Spacer()
            
            Text("Image Details")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Spacer()
        
            ShareLink(item: URL(string: image.media.m)!, message: Text(formattedShareContent()))
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private func fetchImageSize() {
        viewModel.getImageSize(from: image.media.m) { width, height in
            DispatchQueue.main.async {
                self.imageWidth = width
                self.imageHeight = height
                self.isFetchingImageSize = false
            }
        }
    }
    
    private func formattedShareContent() -> String {
        let details = """
        You have to see this amazing image from Flickr!
        Title: \(image.title)
        Description: \(image.description.removingHTMLTags())
        Author: \(image.author)
        Date Taken: \(formatDate(image.dateTaken))
        Published: \(formatDate(image.published))
        Tags: \(image.tags)
        """
        return details
    }
    
    @ViewBuilder
    func infoRowView(title: String, info: String) -> some View {
        HStack {
            Text(title)
            
            Spacer()
            
            Text(info.removingHTMLTags())
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
