//
//  OpenApiRepository.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//

final class OpenApiUseCase {
    private let repository: OpenApiRepository
    
    init(repository: OpenApiRepository) {
        self.repository = repository
    }
    
    func getNearByHospital(administrativeArea: String, subLocality: String, departmentName : String) async throws -> [Hospital] {
        do {
            let result = try await repository.getNearByHospital(administrativeArea: administrativeArea, subLocality: subLocality, departmentName : departmentName)
            return result
        } catch {
            throw error
        }
    }
}
