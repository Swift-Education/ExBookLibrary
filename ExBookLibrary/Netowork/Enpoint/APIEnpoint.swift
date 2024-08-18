//
//  APIEnpoint.swift
//  ExPokemon
//
//  Created by 강동영 on 8/2/24.
//

import Foundation

struct APIEndpoints {
    static func fetchBookList(query: String) -> Endpoint<SearchBookResponseDTO> {
        Endpoint(
            path: "/search/book",
            queryParameters: ["query" : query]
        )
    }
}



