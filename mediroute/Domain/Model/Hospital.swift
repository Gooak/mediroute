//
//  Hispital.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//


struct ApiResponse: Codable {
    let header: Header
    let body: Body
}

struct Header: Codable {
    let resultCode: String
    let resultMsg: String
}

struct Body: Codable {
    let items: Items
}

struct Items: Codable {
    let item: [Hospital]
}

struct Hospital: Codable {
    let hospitalName: String?
    let hospitalAddr: String?
    let hospitalTel: String?
    let xPos: String?
    let yPos: String?
}
