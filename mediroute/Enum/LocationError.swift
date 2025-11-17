//
//  LocationError.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//

enum LocationError: Error {
    case authorizationDenied
    case locationUnavailable
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .authorizationDenied:
            return "위치 정보 접근 권한이 거부되었습니다. 설정에서 변경해주세요."
        case .locationUnavailable:
            return "현재 위치 정보를 가져올 수 없습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
