//
//  LocationService.swift
//  mediroute
//
//  Created by 황진우 on 11/16/25.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    // Core Location의 핵심 객체
    private let manager = CLLocationManager()
    
    // 위치 정보를 전달할 Completion Handler (클로저)
    // Result 타입을 사용해 성공(CLLocation) 또는 실패(Error)를 전달합니다.
    private var completion: ((Result<CLLocation, LocationError>) -> Void)?

    override init() {
        super.init()
        // 델리게이트 설정
        manager.delegate = self
        // 정확도 설정
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
     // 현재 위치를 한 번 가져오는 메인 함수
    public func fetchCurrentLocation(completion: @escaping (Result<CLLocation, LocationError>) -> Void) {
        // completion 핸들러 저장
        self.completion = completion
        
        // 권한 상태 확인 및 요청
        checkAuthorization()
    }
    
    
    // 현재 권한 상태를 확인하고, 필요시 권한을 요청합니다.
    private func checkAuthorization() {
        switch manager.authorizationStatus {
        case .notDetermined:
            // 권한이 결정되지 않은 상태 -> 권한 요청 
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            // 권한이 있는 상태 -> 위치 업데이트 시작
            manager.startUpdatingLocation()
        case .denied, .restricted:
            // 권한이 거부된 상태 -> 에러 전달
            completion?(.failure(.authorizationDenied))
            clearCompletion()
        @unknown default:
            completion?(.failure(.unknown))
            clearCompletion()
        }
    }

    // 권한 상태가 변경되었을 때 호출됩니다.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 권한 요청 팝업에서 사용자가 선택했을 때 다시 checkAuthorization 호출
        // (completion이 nil이 아닐 때만, 즉 요청이 진행 중일 때만)
        if completion != nil {
            checkAuthorization()
        }
    }

    // 위치 정보가 성공적으로 업데이트되었을 때 호출됩니다.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 가장 최신 위치 정보를 가져옵니다.
        if let location = locations.last {
            // 성공 결과를 completion으로 전달
            completion?(.success(location))
            // 위치 업데이트 중지 (배터리 절약)
            manager.stopUpdatingLocation()
            
            clearCompletion()
        }
    }

    // 위치 정보 가져오기를 실패했을 때 호출됩니다.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 실패 결과를 completion으로 전달
        completion?(.failure(.locationUnavailable))
        // 위치 업데이트 중지
        manager.stopUpdatingLocation()
        
        clearCompletion()
    }
    
    // Completion 핸들러를 nil로 초기화합니다.
    private func clearCompletion() {
        self.completion = nil
    }
    
    public func reverseGeocode(location: CLLocation, completion: @escaping (Result<[String : String], LocationError>) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
            
            if let _ = error {
                completion(.failure(.locationUnavailable))
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(.failure(.locationUnavailable))
                return
            }
            
            // 최종 주소 문자열 (예: 서울특별시 강남구 테헤란로 123)
            let fullAddress : [String : String] = [
                "thoroughfare" : placemark.thoroughfare ?? "",        // 도로명
                "subThoroughfare" : placemark.subThoroughfare ?? "",  // 건물 번지
                "locality" : placemark.locality ?? placemark.subAdministrativeArea ?? "", // 시/군/구 (때로는 광역시 전체 이름)
                "subLocality" : placemark.subLocality ?? "",          // 동/읍/면
                "administrativeArea" : placemark.administrativeArea ?? "" // 시/도 (예: 대구광역시)
            ]
            
            if fullAddress.isEmpty {
                 completion(.failure(.locationUnavailable))
            } else {
                 completion(.success(fullAddress))
            }
        }
    }
}
