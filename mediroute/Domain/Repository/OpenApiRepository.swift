//
//  OpenApiRepository.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//

protocol OpenApiRepository {
    func getNearByHospital(administrativeArea: String, subLocality: String, departmentName : String ) async throws -> [Hospital]
}
