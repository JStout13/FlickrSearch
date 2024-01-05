//
//  ImageDetailViewModel.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import Foundation
import UIKit

class ImageDetailViewModel: ObservableObject {
    @Published var imageWidth: CGFloat = 0
    @Published var imageHeight: CGFloat = 0
    
    func getImageSize(from url: String) {
        guard let imgUrl = URL(string: url) else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: imgUrl), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageWidth = image.size.width
                    self.imageHeight = image.size.height
                }
            }
        }
    }
}
