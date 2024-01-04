//
//  CustomSearchBar.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search Images", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
    
            Button {
                UIApplication.shared.endEditing()
                onSearch()
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .accessibilityLabel("Tap To Search")
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

#Preview {
    ContentView()
}
