//
//  APIEnpoint.swift
//  ExPokemon
//
//  Created by 강동영 on 8/2/24.
//

import Foundation

struct APIEndpoints {
    static func fetchBookList(query: String) {
        Endpoint(
            path: "/search/book",
            headerParameters: ["Authorization" : "e53067b0887f20b63e1cfce529a1ee53"],
            queryParameters: ["query" : query]
        )
    }
}



