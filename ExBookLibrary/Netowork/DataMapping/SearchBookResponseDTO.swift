//
//  SearchBookResponseDTO.swift
//  ExBookLibrary
//
//  Created by 강동영 on 8/19/24.
//

import Foundation

struct SearchBookResponseDTO: Decodable {
    let meta: Meta
    let documents: [Document]
}

struct Meta: Decodable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

struct Document: Decodable {
    let title: String
    let contents: String
    let url: String
    let isbn: String
    let datetime: String
    let authors: [String]
    let publisher: String
    let translators: [String]
    let price: Int
    let salePrice: Int
    let thumbnail: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case title, contents, url, isbn, datetime, authors, publisher
        case translators, price, thumbnail, status
        case salePrice = "sale_price"
    }
}

