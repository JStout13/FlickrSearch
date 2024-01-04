//
//  NetworkService.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import Foundation
import Combine

class NetworkService {
    static let shared = NetworkService()
    
    private let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags="
    
    func fetchImages(tag: String) -> AnyPublisher<FImage, Error> {
        let urlString = baseURL + cleanString(searchText: tag)
        print("URLSTRING \(urlString)")
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let decoder = JSONDecoder()
        // added due to the date returned from flickr
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: FImage.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func cleanString(searchText: String) -> String {
        return searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: ",")
    }
}


// added for testing
protocol NetworkServiceProtocol {
    func fetchImages(tag: String) -> AnyPublisher<FImage, Error>
}

extension NetworkService: NetworkServiceProtocol {}

class MockNetworkService: NetworkServiceProtocol {
    var fetchImagesResult: Result<FImage, Error>!

    func fetchImages(tag: String) -> AnyPublisher<FImage, Error> {
        return fetchImagesResult.publisher.eraseToAnyPublisher()
    }
}
