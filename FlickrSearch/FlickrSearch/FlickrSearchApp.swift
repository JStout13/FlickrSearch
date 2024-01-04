//
//  FlickrSearchApp.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import SwiftUI

@main
struct FlickrSearchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, .light)
            // added this to run the app in "light" mode, the test params did not state to use light/dark mode. My personal phone is always on dark mode
        }
    }
}
