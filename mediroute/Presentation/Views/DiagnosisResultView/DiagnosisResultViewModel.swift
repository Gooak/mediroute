//
//  DiagnosisResultViewModel.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//

import SwiftUI

final class DiagnosisResultViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false // 로딩
    private let locationService = LocationService()
    
    private let useCase: OpenApiUseCase
    
    init(useCase: OpenApiUseCase = DIContainer.Di.openApiUseCase) {
        self.useCase = useCase
    }
    
    //근처 병원 찾기 버튼 클릭 함수
    func findHospital(fullResultText : String) async {
        do {
            let locations = try await fetchLocation()
            
            let departmentName = DataParse.getDepartmentCode(aiResponse: fullResultText)
            
            guard departmentName != "" else { return }
            
            print(departmentName)
            
            let administrativeArea = locations["administrativeArea"] ?? "" // 시/도
            let subLocality = locations["subLocality"] ?? "" // 구/군
            
            let hospitalListResult = try await useCase.getNearByHospital(
                administrativeArea: administrativeArea,
                subLocality: subLocality,
                departmentName: departmentName,
            )
            
            print("병원 목록 API 호출 성공: \(hospitalListResult)")
        } catch {
            print("병원 찾기 과정 중 에러 발생: \(error)")
        }
    }
    
    //주소 위치 찾기
    func fetchLocation() async throws -> [String : String] {
        
        let location = try await withCheckedThrowingContinuation { continuation in
            self.locationService.fetchCurrentLocation { result in
                switch result {
                case .success(let loc):
                    continuation.resume(returning: loc)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
        let addressComponents = try await withCheckedThrowingContinuation { continuation in
            
            self.locationService.reverseGeocode(location: location) { addressResult in
                switch addressResult {
                case .success(let addressDict):
                    continuation.resume(returning: addressDict)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
        
        return addressComponents
    }
    
}
