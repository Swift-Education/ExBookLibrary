//
//  SearchBookModel.swift
//  ExBookLibrary
//
//  Created by 강동영 on 8/19/24.
//

import Foundation

class SearchBookModel {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchBookList(query: String) {
        let endpoint = APIEndpoints.fetchBookList(query: query)
        networkService.request(with: endpoint) { result in
            switch result {
            case .success(let list):
                print()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
