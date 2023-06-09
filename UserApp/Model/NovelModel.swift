//
//  NovelModel.swift
//  UserApp
//
//  Created by William Yulio on 07/06/23.
//

import Foundation

// MARK: - Novel
struct ListNovel: Codable {
    let data: [Novel]
    let messages: String
    let status, total: Int

    enum CodingKeys: String, CodingKey {
        case data = "DATA"
        case messages = "MESSAGES"
        case status = "STATUS"
        case total = "TOTAL"
    }
}

// MARK: - Datum
struct Novel: Codable, Identifiable {
    let createdAt, desc: String
    let genres: [GenreData]?
    let id: Int
    let imagesNovel: String
    let isDeleted, memberID: Int
    let postDate: String
    let price, statusEpisode: Int
    let title: String
    let totalLike, totalViews: Int

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case desc, genres, id
        case imagesNovel = "images_novel"
        case isDeleted = "is_deleted"
        case memberID = "member_id"
        case postDate = "post_date"
        case price
        case statusEpisode = "status_episode"
        case title
        case totalLike = "total_like"
        case totalViews = "total_views"
    }
}

// MARK: - Genre
struct GenreData: Codable {
    let id: Int
    let images: String
    let name: String
    let pivot: Pivot
}

// MARK: - Pivot
struct Pivot: Codable {
    let genreID, novelID: Int

    enum CodingKeys: String, CodingKey {
        case genreID = "genre_id"
        case novelID = "novel_id"
    }
}

enum PageStatus {
case ready (nextPage: Int)
case loading (page: Int)
case done
}

enum MyError: Error {
case limitError
case httpError
}

// MARK: - Genre
struct RealGenre: Codable {
    let data: [Genres]
    let messages: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case data = "DATA"
        case messages = "MESSAGES"
        case status = "STATUS"
    }
}

// MARK: - Datum
struct Genres: Codable {
    let id: Int
    let images: String
    let name: String
}

struct UploadResponse: Codable{
    let data: String
    
    enum CodingKeys: String, CodingKey {
        case data = "DATA"
//        case messages = "MESSAGES"
//        case status = "STATUS"
    }
}
