//
//  Hispital.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//
import Foundation

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

struct Hospital: Identifiable, Codable {
    var id = UUID()
    let hospitalName: String?
    let hospitalAddr: String?
    let hospitalTel: String?
    let xPos: Double?
    let yPos: Double?
}
