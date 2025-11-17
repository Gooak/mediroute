//
//  LocationUseCase.swift
//  mediroute
//
//  Created by 황진우 on 11/17/25.
//
import SwiftUI

final class LocationUseCase {
    // locationService는 LocationUseCase 내에서 관리
    private let locationService: LocationService
    
    init(locationService: LocationService = LocationService()) {
        self.locationService = locationService
    }
    
    func fetchLocationAndAddress() async throws -> Location {
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
        
        let resultLocation = Location(
            thoroughfare: addressComponents["thoroughfare"]!,
            subThoroughfare: addressComponents["subThoroughfare"]!,
            locality: addressComponents["locality"]!,
            subLocality: addressComponents["subLocality"]!,
            administrativeArea: addressComponents["administrativeArea"]!,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        return resultLocation
    }
}
