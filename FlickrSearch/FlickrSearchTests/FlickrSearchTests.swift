//
//  FlickrSearchTests.swift
//  FlickrSearchTests
//
//  Created by Jason Stout on 1/4/24.
//

import XCTest
import Combine

@testable import FlickrSearch

final class FlickrSearchTests: XCTestCase {
    func testPerformSearch_Success() {
        let mockNetworkService = MockNetworkService()
        let sampleItem = Item(title: "Sample", link: "https://example.com", media: Media(m: "https://example.com/image.jpg"), dateTaken: Date(), description: "Sample Description", published: Date(), author: "Sample Author", tags: "sample, test")
        let sampleFImage = FImage(title: "Test", link: "https://example.com", description: "Test Description", modified: Date(), generator: "TestGenerator", items: [sampleItem])
        mockNetworkService.fetchImagesResult = .success(sampleFImage)

        let viewModel = SearchViewModel(networkService: mockNetworkService)
        viewModel.updateSearch(text: "sample")

        // Expectation for async operation
        let expectation = XCTestExpectation(description: "Fetch images successfully")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(viewModel.images.count, 1)
            XCTAssertFalse(viewModel.isLoading)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.5)
    }
}
