//
//  KakaoMapView.swift
//  mediroute
//
//  Created by 황진우 on 11/17/25.
//

import SwiftUI
import KakaoMapsSDK

struct KakaoMapView: UIViewRepresentable {
    @Binding var draw: Bool
    
    var initialLongitude: Double
    var initialLatitude: Double
    var initialHospitalListResult : [Hospital]
    @Binding var selectedHospitalInfo: Hospital?
    
    func makeUIView(context: Self.Context) -> KMViewContainer {
        let view: KMViewContainer = KMViewContainer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

        context.coordinator.createController(view)
        
        return view
    }

    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        if draw {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if context.coordinator.controller?.isEnginePrepared == false {
                    context.coordinator.controller?.prepareEngine()
                }
                
                if context.coordinator.controller?.isEngineActive == false {
                    context.coordinator.controller?.activateEngine()
                }
            }
        }
        else {
            context.coordinator.controller?.pauseEngine()
            context.coordinator.controller?.resetEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(
            longitude: initialLongitude,
            latitude: initialLatitude,
            hospitalList : initialHospitalListResult,
            selectedHospitalInfo: $selectedHospitalInfo
        )
    }

    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        
    }
    
    
    class KakaoMapCoordinator: NSObject, MapControllerDelegate {
        
        var longitude: Double
        var latitude: Double
        var hospitalList : [Hospital]
        
        @Binding var selectedHospitalInfo: Hospital?
        
        init(longitude: Double, latitude: Double, hospitalList : [Hospital], selectedHospitalInfo: Binding<Hospital?>) {
            self.longitude = longitude
            self.latitude = latitude
            self.hospitalList = hospitalList
            first = true
            _selectedHospitalInfo = selectedHospitalInfo
            super.init()
        }
        
        func createController(_ view: KMViewContainer) {
            container = view
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }
        
        func addViews() {
            let defaultPosition: MapPoint = MapPoint(longitude: longitude, latitude: latitude)
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
            
            controller?.addView(mapviewInfo)
        }
        
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            print("OK")
            guard let view = controller?.getView("mapview") as? KakaoMap else { return }
            view.viewRect = container!.bounds
            
            createLabelLayer(view: view)
            createPoiStyle(view: view)
            createPois(view: view)
        }
        
        func containerDidResized(_ size: CGSize) {
            let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
            mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
            if first {
                let cameraUpdate: CameraUpdate = CameraUpdate.make(target: MapPoint(longitude: longitude, latitude: latitude), mapView: mapView!)
                mapView?.moveCamera(cameraUpdate)
                first = false
            }
        }
        
        func createLabelLayer(view: KakaoMap) {
            let manager = view.getLabelManager()
            let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 1000)
            _ = manager.addLabelLayer(option: layerOption)
        }
        
        func createPois(view: KakaoMap) {
            let manager = view.getLabelManager()
            guard let layer = manager.getLabelLayer(layerID: "PoiLayer") else {
                print("레이어 없음")
                return
            }

            // 원하는 위치에 마커 추가
            for hospital in hospitalList {
                guard let lat = hospital.yPos, let lon = hospital.xPos else {
                    continue
                }

                let poiOption = PoiOptions(styleID: "PerLevelStyle")
                poiOption.clickable = true // clickable 옵션
                
                let poiText = PoiText(
                    text: hospital.hospitalName!,
                    styleIndex: 0
                )
                
                poiOption.addText(poiText)
                
                let poi = layer.addPoi(
                    option: poiOption,
                    at: MapPoint(longitude: lon, latitude: lat) // xPos는 경도, yPos는 위도
                )
                
                poi?.userObject = hospital as AnyObject // 병원 객체 자체를 userObject에 저장
                
                let _ = poi?.addPoiTappedEventHandler(target: self, handler: KakaoMapCoordinator.poiTappedHandler)
                
                poi?.show()
            }
            print("✅ 병원 목록 마커 추가 완료 (총 \(hospitalList.count)개)")
        }
        
        func createPoiStyle(view: KakaoMap) {
            let manager = view.getLabelManager()
            
            // 마커 아이콘
            let iconStyle = PoiIconStyle(
                symbol: UIImage(named: "maker"),
                anchorPoint: CGPoint(x: 0.6, y: 1.0) // 마커 아래가 좌표와 맞닿도록
            )

            let textStyle = PoiTextStyle(textLineStyles: [
                PoiTextLineStyle(
                    textStyle : TextStyle(fontSize: 20, strokeThickness: 1)
                )
            ])

            // 레벨 별 스타일
            let perLevelStyle = PerLevelPoiStyle(
                iconStyle: iconStyle,
                textStyle: textStyle,
                level: 0
            )

            // 최종 스타일
            let poiStyle = PoiStyle(
                styleID: "PerLevelStyle",
                styles: [perLevelStyle]
            )

            manager.addPoiStyle(poiStyle)
        }
        
        func poiTappedHandler(_ param: PoiInteractionEventParam) {
            // 클릭된 POI 객체
            let poi = param.poiItem
            
            if let hospital = poi.userObject as? Hospital { // ⭐️ userObject에서 Hospital 객체 추출
                self.selectedHospitalInfo = hospital
                print("🏥 클릭된 병원: \(String(describing: hospital.hospitalName)) (userObject 사용)")
            } else {
                self.selectedHospitalInfo = nil
                print("🚨 userObject에서 병원 정보 추출 실패.")
            }
        }
        
        var controller: KMController?
        var container: KMViewContainer?
        var first: Bool
    }
}
