
import Foundation
import SwiftUI
import Combine
import MapKit

struct AnotationItem: Identifiable {
    let id: Int
    let userid: Int
    let name: String
    let coordinate: CLLocationCoordinate2D
    let remoteIcon: String
    let place: Location
}

final class PlacesViewModel: ObservableObject {

    @Published var spinner = false
    @Published var annotations = [AnotationItem]()
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 43.6582232,
            longitude: -79.36996829999998),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1)
    )
    
    private var apiService = APIService()
    private var cancellable: AnyCancellable?
    private var alertMessage: String?
    @Published var billboardRandomLocation: String?
    @Published var loadingMessage: String? = nil
    @Published var backgroundLocationImageUrl: String?
    @Published var randomLocationCity: String?
    @Published var placeImageChanged: Bool = false

    var places = [Location]()
    var savedPlaces = [Location]()
    
//    func assignLocationToEvent(with eventid: Int, placeid: Int) {
//        self.loadingMessage = "Assigning Location to Event..."
//        
//        self.cancellable = self.apiService.assignLocationToEvent(eventId: eventid, placeid: placeid)
//            .catch {_ in Just(ResponseNotification()) }
//            .sink(receiveCompletion: { _ in }, receiveValue: {
//                print("\($0)")
//                self.loadingMessage = nil
//        })
//    }
    
//    func savePlace(place: Location) {
//        self.spinner = true
//        self.cancellable = self.apiService.addPlace(
//            place_id: place.place_id,
//            name: place.name,
//            formatted_address: place.formatted_address,
//            lat: "\(place.lat)",
//            lng: "\(place.lng)",
//            icon: place.icon
//        )
//        .catch {_ in Just(ResponseNotification()) }
//        .sink(receiveCompletion: { _ in }, receiveValue: {
//            self.alertMessage = $0.message
//            self.fetchSavedPlaces()
//            self.spinner = false
//        })
//    }
    
    func parseCityAndCountry(from address: String, completion: @escaping (String?, String?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, nil, error)
                return
            }
            
            let city = placemark.locality
            let country = placemark.country
            
            completion(city, country, nil)
        }
    }
    
    func getLocationPhotoForEvent(place: Location) {
        self.generateBannerFromAddress(place: place)
    }
    
    func searchLocation(with keyword: String) {
        self.loadingMessage = "Searching locations for \(keyword)"
        self.placeImageChanged = false

        self.cancellable = self.apiService.searchLocation(keyword: keyword)
        .catch {_ in Just([Location]()) }
        .sink(receiveCompletion: { _ in }, receiveValue: {
            self.places = $0
            self.placeImageChanged = true
            self.generateBannerFromAddress(place: self.places.first)
            self.loadingMessage = nil
        })
    }
    
    func reloadIcon(destination: Destination) {
        self.searchLocation(with: destination.name.searchSanitized() + "+city")
    }
    
    func generateBannerFromAddress(place: Location?) {
        self.parseCityAndCountry(from: place?.formatted_address ?? "Lasvos, Greece") { city, country, error in
            
            guard let city = city, let country = country else { return }
            self.billboardRandomLocation = "\(city), \(country)"
            
            self.fetchRandomLocationPhoto(keyword: self.billboardRandomLocation ?? "Lesvos, Greece")
        }
    }
    
//    func fetchSavedPlaces() {
//        self.loadingMessage = "Loading Saved Locations..."
//        CBJournalServices().savedPlaces() {
//            self.savedPlaces = $0
//
//            self.generateBannerFromAddress(place: self.savedPlaces.sorted(by: { $0.id > $1.id }).first)
//            self.loadingMessage = nil
//        }
//        self.loadingMessage = nil
//    }
    
    func fetchRandomLocationPhoto(keyword: String) {
        self.randomLocationCity = nil
        self.cancellable = self.apiService.openAPIGenerateImage(keyword: keyword)
        .catch {_ in Just(ChatGPTImageResponse(created: 0, data: [])) }
        .sink(receiveCompletion: { _ in }, receiveValue: {
            self.randomLocationCity = keyword
            self.backgroundLocationImageUrl = $0.data.first?.url
        })
    }
    
    func populateAnotations() {
        for place in self.places.uniqued(by: \.place_id) {
            let anotation = AnotationItem(
                id: place.id,
                userid: 1,
                name: place.name,
                coordinate: CLLocationCoordinate2D(
                    latitude: place.lat,
                    longitude: place.lng),
                remoteIcon: place.icon,
                place: place
            )
            
            self.annotations.append(anotation)
        }
        
        self.spinner = false
    }
    
//    func addPlace(place: Location) {
//        self.spinner = true
//        
//        self.cancellable = self.apiService.addPlace(
//            place_id: place.place_id,
//            name: place.name,
//            formatted_address: place.formatted_address,
//            lat: "\(place.lat)",
//            lng: "\(place.lng)",
//            icon: place.icon
//        )
//        .catch {_ in Just(ResponseNotification()) }
//        .sink(receiveCompletion: { _ in }, receiveValue: {
//            self.alertMessage = $0.message
//            self.spinner = false
//        })
//    }
    
    func fetchPlaces(with keyword: String) {
        self.spinner = true
        
        self.cancellable = self.apiService.searchLocation(keyword: keyword)
        .catch {_ in Just([Location]()) }
        .sink(receiveCompletion: { _ in }, receiveValue: {
            self.places = $0
            self.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: self.places.first?.lat ?? 43.6582232,
                    longitude: self.places.first?.lng ?? -79.36996829999998),
                span: MKCoordinateSpan(
                    latitudeDelta: 1.5,
                    longitudeDelta: 1.5)
            )

            self.populateAnotations()
        })
    }
}
