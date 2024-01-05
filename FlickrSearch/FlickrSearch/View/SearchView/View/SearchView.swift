//
//  SearchView.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    @State private var searchText: String = ""
    @State private var gridType: GridType = .list
    @State private var showDetailView: Bool = false
    @State private var selectedImage: Item?
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    HStack(alignment: .center) {
                        Text("FlickrSearch")
                            .font(.title3)
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
                        switch gridType {
                        case .list:
                            ImageListView(selectedImage: $selectedImage, showDetailView: $showDetailView, images: viewModel.images)
                        case .tile:
                            ImageGridView(selectedImage: $selectedImage, showDetailView: $showDetailView, images: viewModel.images)
                        }
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
                }
                
                if viewModel.isLoading {
                    LoadingView(text: "Fetching Images...")
                        .accessibilityLabel("Fetching Images, please wait.")
                }
            }
            .navigationBarHidden(showDetailView)
        }
    }
}

#Preview {
    ContentView()
}
