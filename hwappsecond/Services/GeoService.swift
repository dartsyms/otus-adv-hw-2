//
//  GeoService.swift
//  hwappsecond
//

import Foundation
import Combine
import CoreLocation

protocol GeoService {
    func getCoordinates(for address: String) -> Future<CLLocationCoordinate2D, Never>
}

final class GeoServiceImpl: GeoService {

    func getCoordinates(for address: String) -> Future<CLLocationCoordinate2D, Never> {
        return Future<CLLocationCoordinate2D, Never> { promise in
            self.getLocation(from: address) { value in
                guard value != nil else { return }
                print(value!)
                promise(.success(value!))
            }
        }
    }
    
    private func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        print("For address: \(address)")
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemarks = placemarks,
            let location = placemarks.first?.location?.coordinate else {
                print("error geocoding")
                completion(nil)
                return
            }
            print(location)
            completion(location)
        }
    }
}
