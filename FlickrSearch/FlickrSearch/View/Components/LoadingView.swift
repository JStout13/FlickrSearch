//
//  LoadingView.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import SwiftUI

struct LoadingView: View {
    var text: String
    
    var body: some View {
        VStack {
            ProgressView(text)
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5, anchor: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).opacity(0.8))
        .ignoresSafeArea(.all)
    }
}

#Preview {
    LoadingView(text: "Searching")
}
