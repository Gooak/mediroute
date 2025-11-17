//
//  OpenApiRepositoryImpl.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//

final class OpenApiRepositoryImpl: OpenApiRepository {

    private let dataSource: OpenApiDataSource

    init(dataSource: OpenApiDataSource) {
        self.dataSource = dataSource
    }

    func getNearByHospital(administrativeArea: String, subLocality: String, departmentName : String) async throws -> [Hospital] {
        let data = try await dataSource.getNearByHospital(administrativeArea: administrativeArea, subLocality: subLocality, departmentName: departmentName)
        
        let parser = HospitalXMLParser()
        let hospitalList : [Hospital] = parser.parse(data: data)
        
        return hospitalList
    }
}
