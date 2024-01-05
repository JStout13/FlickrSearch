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
        isLoading = true
        networkService.fetchImages(tag: tag)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.isLoading = false
                    print("Fetch Images Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] fetchedImages in
                self?.images = fetchedImages.items
                self?.isLoading = false
                UIApplication.shared.endEditing()
            })
            .store(in: &cancellables)
    }
    
    deinit {
        searchCancellable?.cancel()
    }
}
