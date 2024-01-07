//
//  SearchView.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var viewModel: SearchViewModel
    @State private var searchText: String = ""
    @State private var gridType: GridType = .list
    @State private var showDetailView: Bool = false
    @State private var selectedImage: Item?
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center) {
                    Text("FlickrSearch")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                        .accessibilityLabel("Flickr Search")
                    
                    Spacer()
                    
                    SearchToolbarItems(gridType: $gridType)
                }
                .padding(.horizontal, 16)
                
                CustomSearchBar(searchText: $searchText) {
                    viewModel.updateSearch(text: searchText)
                }
                .accessibilityAddTraits(.isSearchField)
                
                Group {
                    GridView(selectedImage: $selectedImage, showDetailView: $showDetailView, images: viewModel.images, gridType: gridType)
                }
                .blur(radius: viewModel.isLoading ? 3 : 0)
                .onChange(of: searchText) { _, newValue in
                    viewModel.updateSearch(text: newValue)
                }
                .fullScreenCover(isPresented: $showDetailView) {
                    if let image = selectedImage {
                        ImageDetailView(image: image, showDetailView: $showDetailView)
                    }
                }
                .alert(isPresented: $viewModel.showError) {
                    Alert(title: Text("Error"), message: Text(viewModel.errorMsg), dismissButton: .default(Text("OK")))
                }
            }
            
            if viewModel.isLoading {
                LoadingView(text: "Fetching Images...")
                    .accessibilityLabel("Fetching Images, please wait.")
            }
        }
        .navigationBarHidden(showDetailView)
    }
}

#Preview {
    ContentView()
}
