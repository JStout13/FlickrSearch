//
//  File.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    func removingHTMLTags() -> String {
        guard let htmlData = self.data(using: .utf8) else {
            return self
        }
        
        if let attributedString = try? NSAttributedString(
            data: htmlData,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) {
            return attributedString.string
        }
        
        return self
    }
}
