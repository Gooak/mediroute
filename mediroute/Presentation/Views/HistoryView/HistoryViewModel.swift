//
//  HistoryViewModel.swift
//  mediroute
//
//  Created by 황진우 on 11/17/25.
//

import SwiftUI

final class HistoryViewModel: ObservableObject {
    
    @Published var shouldShowResult = false // 링크 활성화
    
    @Published var latitude : Double? // 위도
    @Published var longitude : Double? // 경도
    @Published var hospitalListResult : [Hospital]?
    
    private let openApiUseCase: OpenApiUseCase
    private let locationUseCase: LocationUseCase
    
    init(openApiUseCase : OpenApiUseCase = DIContainer.Di.openApiUseCase, locationUseCase : LocationUseCase = DIContainer.Di.locationUseCase) {
        self.openApiUseCase = openApiUseCase
        self.locationUseCase = locationUseCase
    }
    
    //근처 병원 찾기 버튼 클릭 함수
    @MainActor func findHospital(fullResultText : String, departmentName : String) async {
        do {
            let location : Location = try await locationUseCase.fetchLocationAndAddress()
            
            hospitalListResult = try await openApiUseCase.getNearByHospital(
                administrativeArea: location.administrativeArea,
                subLocality: location.subLocality,
                departmentName: departmentName,
            )
            
            latitude = location.latitude
            longitude = location.longitude
            
            shouldShowResult = true
            print("병원 목록 API 호출 성공: \(String(describing: hospitalListResult))")
        } catch {
            hospitalListResult = []
            print("병원 찾기 과정 중 에러 발생: \(error)")
        }
    }
    
}
