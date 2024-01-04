//
//  SearchToolbarItems.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import SwiftUI

struct SearchToolbarItems: View {
    @Binding var gridType: GridType
    
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    gridType = .list
                }
            } label: {
                Image(systemName: "list.dash")
                    .imageScale(.large)
                    .foregroundStyle(gridType == .list ? .blue : .gray)
            }
            .accessibilityLabel("Tap To Show List View")
            
            Button {
                withAnimation {
                    gridType = .tile
                }
            } label: {
                Image(systemName: "square.grid.3x3")
                    .imageScale(.large)
                    .foregroundStyle(gridType == .tile ? .blue : .gray)
            }
            .accessibilityLabel("Tap To Show Grid View")
        }
    }
}

#Preview {
    ContentView()
}
