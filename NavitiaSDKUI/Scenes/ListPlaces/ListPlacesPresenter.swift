//
//  ListPlacesPresenter.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol ListPlacesPresentationLogic {
    
    func presentDisplayedSearch(response: ListPlaces.UpdateSearchViewFields.Response)
    func presentHistoryPlaces(response: ListPlaces.FetchHistoryItems.Response)
    func presentFetchPlaces(response: ListPlaces.FetchPlaces.Response)
    func presentUserLocation(response: ListPlaces.FetchUserLocation.Response)
}

class ListPlacesPresenter: ListPlacesPresentationLogic {
    
    weak var viewController: ListPlacesDisplayLogic?
    
    // MARK: Display Search
    
    func presentDisplayedSearch(response: ListPlaces.UpdateSearchViewFields.Response) {
        // In one case, there is only one possibility of text to be displayed (name) and in the opposite case, several possibilities in a specific order (name > label > id)
        let fromName = response.from?.name ?? response.from?.label ?? response.from?.id
        let toName = response.to?.name ?? response.to?.label ?? response.to?.id
        let viewModel = ListPlaces.UpdateSearchViewFields.ViewModel(fromName: fromName ?? "", toName: toName ?? "")
        
        viewController?.displaySearch(viewModel: viewModel)
    }
    
    // MARK: Fetch Places
    
    func presentFetchPlaces(response: ListPlaces.FetchPlaces.Response) {
        let viewModel = ListPlaces.FetchPlaces.ViewModel(displayedSections: getSections(places: response.places))
        viewController?.displayFetchedPlaces(viewModel: viewModel)
    }
    
    // MARK: Fetch History Place
    
    func presentHistoryPlaces(response: ListPlaces.FetchHistoryItems.Response) {
        var displayedSections = [ListPlaces.FetchPlaces.ViewModel.DisplayedSection]()
        var historyPlaces = [ListPlaces.FetchPlaces.ViewModel.Place]()

        for line in response.historyItems {
            if let embeddedType = ListPlaces.FetchPlaces.ViewModel.ModelType(rawValue: line.type) {
                let place = ListPlaces.FetchPlaces.ViewModel.Place(label: nil, name: line.name, id: line.idNavitia, distance: nil, type: embeddedType)
                historyPlaces.append(place)
            }
        }
        
        let historySection = ListPlaces.FetchPlaces.ViewModel.DisplayedSection(name: "history".localized().uppercased(), places: historyPlaces)
        displayedSections.append(historySection)
        
        let viewModel = ListPlaces.FetchPlaces.ViewModel(displayedSections: displayedSections)
        viewController?.displayFetchedPlaces(viewModel: viewModel)
    }
    
    // MARK: Fetch user location
    
    func presentUserLocation(response: ListPlaces.FetchUserLocation.Response) {
        var place = ListPlaces.FetchPlaces.ViewModel.Place(label: nil,
                                                           name: nil,
                                                           id: nil,
                                                           distance: nil,
                                                           type: .locationNotFound)
        if let userAddress = response.userAddress,
            let label = userAddress.label,
            let lon = userAddress.coord?.lon,
            let lat = userAddress.coord?.lat {
            place = ListPlaces.FetchPlaces.ViewModel.Place(label: String(format: "%@ - %@", "my_position".localized(), label),
                                                           name: label,
                                                           id: String(format: "%@;%@", lon, lat),
                                                           distance: nil,
                                                           type: .locationFound)
        }
        
        let userSection = ListPlaces.FetchPlaces.ViewModel.DisplayedSection(name: nil, places: [place])
        let viewModel = ListPlaces.FetchUserLocation.ViewModel(userSection: userSection)
        viewController?.displayUserLocation(viewModel: viewModel)
    }
    
    private func getSections(places: Places?) -> [ListPlaces.FetchPlaces.ViewModel.DisplayedSection] {
        var sections = [ListPlaces.FetchPlaces.ViewModel.DisplayedSection]()
        if let placesViewModel = getPlaces(places: places) {
            if placesViewModel.stopArea.count > 0 {
                let section = ListPlaces.FetchPlaces.ViewModel.DisplayedSection(name: "stops_stations".localized().uppercased(),
                                                                                 places: placesViewModel.stopArea)
                sections.append(section)
            }
            
            if placesViewModel.address.count > 0 {
                let section = ListPlaces.FetchPlaces.ViewModel.DisplayedSection(name: "address".localized().uppercased(),
                                                                                 places: placesViewModel.address)
                sections.append(section)
            }
            
            if placesViewModel.poi.count > 0 {
                let section = ListPlaces.FetchPlaces.ViewModel.DisplayedSection(name: "points_of_interest".localized().uppercased(),
                                                                                 places: placesViewModel.poi)
                sections.append(section)
            }
        }
        
        return sections
    }
    
    private func getPlaces(places: Places?) -> (stopArea: [ListPlaces.FetchPlaces.ViewModel.Place], address: [ListPlaces.FetchPlaces.ViewModel.Place], poi: [ListPlaces.FetchPlaces.ViewModel.Place])? {
        guard let places = places?.places else {
            return nil
        }
        
        var stopArea = [ListPlaces.FetchPlaces.ViewModel.Place]()
        var address = [ListPlaces.FetchPlaces.ViewModel.Place]()
        var poi = [ListPlaces.FetchPlaces.ViewModel.Place]()
        
        for place in places {
            if let name = place.name,
                let id = place.id,
                let embeddedType = place.embeddedType?.rawValue,
                let type = ListPlaces.FetchPlaces.ViewModel.ModelType(rawValue: embeddedType) {
                let placeViewModel = ListPlaces.FetchPlaces.ViewModel.Place(label: nil, name: name, id: id, distance: getDistance(distance: place.distance), type: type)

                if place.embeddedType == .stopArea {
                    stopArea.append(placeViewModel)
                } else if place.embeddedType == .address || place.embeddedType == .administrativeRegion {
                    address.append(placeViewModel)
                } else if place.embeddedType == .poi {
                    poi.append(placeViewModel)
                }
            }
        }
        
        return (stopArea: stopArea, address: address, poi: poi)
    }
    
    private func getDistance(distance: String?) -> String? {
        guard let distance = distance, let convert = Int(distance), convert != 0 else {
            return nil
        }
        
        if convert < 1000 {
            return String(format: "%d m", convert)
        }
        
        return String(format: "%.1f km", Float(convert) / 1000)
    }
}
