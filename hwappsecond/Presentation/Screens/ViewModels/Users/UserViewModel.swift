//
//  UserViewModel.swift
//  hwappsecond
//

import SwiftUI
import Combine
import CoreLocation

final class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var location: CLLocationCoordinate2D?
    @Injected var geoService: GeoService
    @Injected var userService: UserService
    
    private(set) var isLoading = false
    
    var userRequest: AnyCancellable?
    var locationRequest: AnyCancellable?
    
    private static let processingQueue = DispatchQueue(label: "geocoding-processing")
    
    var userOrigin: String {
        guard let city = user?.location?.city, let country = user?.location?.country else { return "" }
        return "(\(city), \(country))"
    }
    
    var email: String {
        guard let userEmail = user?.email else { return "" }
        return "Email: \(userEmail)"
    }
    
    var phone: String {
        guard let userPhone = user?.phone else { return "" }
        return "Pnone: \(userPhone)"
    }
    
    func loadDetailsFor(_ id: String) {
        guard !isLoading else { return }
        self.isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.userRequest = self.userService.getUserDetails(userId: id, apiResponseQueue: DummyAPIConfig.apiResponseQueue)
                .receive(on: RunLoop.main)
                .handleEvents(receiveSubscription: { [weak self] _ in self?.onLoad() },
                    receiveOutput: { print($0) },
                    receiveCompletion: { [weak self] _ in self?.onFinish() },
                    receiveCancel: { [weak self] in self?.onFinish() })
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                    self.isLoading = false
                }, receiveValue: { user in
                    self.user = user
                    self.resolveLocation()
                })
        }
    }
    
    func cancel() {
        self.isLoading = false
        self.userRequest?.cancel()
        self.userRequest = nil
    }
    
    private func onLoad() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    func resolveLocation() {
        guard let loc = self.user?.location,
              loc.country != nil,
              loc.city != nil else { return }
       
        let address = "\(loc.city ?? ""), \(loc.country ?? "")"
        self.locationRequest = self.geoService.getCoordinates(for: address)
            .subscribe(on: Self.processingQueue)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { print($0) })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { coords in
                self.location = coords
            })
    }
}
