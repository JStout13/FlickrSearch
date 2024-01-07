//
//  FImageSearchViewModel.swift
//  FlickrSearch
//
//  Created by Jason Stout on 1/4/24.
//

import Foundation
import Combine
import UIKit

class SearchViewModel: ObservableObject {
    @Published var images: [Item] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMsg = ""
    private var cancellables = Set<AnyCancellable>()
    private var searchSubject = PassthroughSubject<String, Never>()
    private var searchCancellable: AnyCancellable?
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
        searchCancellable = searchSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] tag in
                self?.performSearch(tag: tag)
            }
    }
    
    func updateSearch(text: String) {
        searchSubject.send(text)
    }
    
    private func performSearch(tag: String) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        networkService.fetchImages(tag: tag)
            .sink(receiveCompletion: { [weak self] completion in
                DispatchQueue.main.async {
                    if case .failure(let error) = completion {
                        self?.isLoading = false
                        self?.errorMsg = "Error fetching images: \(error.localizedDescription)"
                        self?.showError = true
                    }
                }
            }, receiveValue: { [weak self] fetchedImages in
                DispatchQueue.main.async {
                    self?.images = fetchedImages.items
                    self?.isLoading = false
                }
            })
            .store(in: &cancellables)
    }

    func getImageSize(from url: String, completion: @escaping (CGFloat, CGFloat) -> Void) {
        guard let imgUrl = URL(string: url) else {
            completion(0,0)
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: imgUrl), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    print("Image Width: \(image.size.width) Height: \(image.size.height)")
                    completion(image.size.width, image.size.height)
                }
            } else {
                self.errorMsg = "Something went wrong, un able to fetch image size."
                self.showError = true
                completion(0,0)
            }
        }
    }
    
    deinit {
        searchCancellable?.cancel()
    }
}
