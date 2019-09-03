//
//  ListPlacesPresenter.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol ListPlacesPresentationLogic {
    
    func presentDisplayedSearch(response: ListPlaces.DisplaySearch.Response)
    func presentHistoryPlace(response: [AutocompletionHistory], locationAddress: Address?)
    func presentFetchPlaces(response: ListPlaces.FetchPlaces.Response)
}

class ListPlacesPresenter: ListPlacesPresentationLogic {
    
    weak var viewController: ListPlacesDisplayLogic?
    
    // MARK: Display Search
    
    func presentDisplayedSearch(response: ListPlaces.DisplaySearch.Response) {
        // In one case, there is only one possibility of text to be displayed (name) and in the opposite case, several possibilities in a specific order (name > label > id)
        let viewModel = ListPlaces.DisplaySearch.ViewModel(fromName: response.info == "from" ? response.from?.name : response.from?.name ?? response.from?.label ?? response.from?.id,
                                                           toName: response.info == "to" ?  response.to?.name : response.to?.name ?? response.to?.label ?? response.to?.id,
                                                           info: response.info)
        
        viewController?.displaySearch(viewModel: viewModel)
    }
    
    // MARK: Fetch Places
    
    func presentFetchPlaces(response: ListPlaces.FetchPlaces.Response) {
        let viewModel = ListPlaces.FetchPlaces.ViewModel(displayedSections: getSection(places: response.places, address: response.locationAddress))
        
        viewController?.displaySomething(viewModel: viewModel)
    }
    
    // MARK: Fetch History Place
    
    func presentHistoryPlace(response: [AutocompletionHistory], locationAddress: Address?) {
        var sections = [ListPlaces.FetchPlaces.ViewModel.DisplayedSections]()
        var placesNew = [ListPlaces.FetchPlaces.ViewModel.Place]()

        if let label = locationAddress?.label, let lon = locationAddress?.coord?.lon, let lat = locationAddress?.coord?.lat {
            let place = ListPlaces.FetchPlaces.ViewModel.Place(label: String(format: "%@ - %@", "my_position".localized(), label),
                                                               name: label,
                                                               id: String(format: "%@;%@", lon, lat),
                                                               distance: nil,
                                                               type: .location)
            let section = ListPlaces.FetchPlaces.ViewModel.DisplayedSections(
                name: nil,
                places: [place])
            sections.append(section)
        }

        for line in response {
            if let embeddedType = ListPlaces.FetchPlaces.ViewModel.ModelType(rawValue: line.type) {
                let place = ListPlaces.FetchPlaces.ViewModel.Place(label: nil, name: line.name, id: line.idNavitia, distance: nil, type: embeddedType)
                placesNew.append(place)
            }
        }
        let section = ListPlaces.FetchPlaces.ViewModel.DisplayedSections(name: "history".localized().uppercased(), places: placesNew)
        sections.append(section)
        
        let viewModel = ListPlaces.FetchPlaces.ViewModel(displayedSections: sections)

        viewController?.displaySomething(viewModel: viewModel)

    }
    
    private func getSection(places: Places?, address: Address?) -> [ListPlaces.FetchPlaces.ViewModel.DisplayedSections] {
        var sections = [ListPlaces.FetchPlaces.ViewModel.DisplayedSections]()
        
        if let label = address?.label, let lon = address?.coord?.lon, let lat = address?.coord?.lat {
            let place = ListPlaces.FetchPlaces.ViewModel.Place(label: nil, name: label, id: String(format: "%@;%@", lon, lat), distance: nil, type: .location)
            let section = ListPlaces.FetchPlaces.ViewModel.DisplayedSections(name: nil,
                                                                   places: [place])
            sections.append(section)
        }
        
        if let placesViewModel = getPlaces(places: places) {
            if placesViewModel.stopArea.count > 0 {
                let section = ListPlaces.FetchPlaces.ViewModel.DisplayedSections(name: "stops_stations".localized().uppercased(),
                                                                                 places: placesViewModel.stopArea)
                sections.append(section)
            }
            if placesViewModel.address.count > 0 {
                let section = ListPlaces.FetchPlaces.ViewModel.DisplayedSections(name: "address".localized().uppercased(),
                                                                                 places: placesViewModel.address)
                sections.append(section)
            }
            if placesViewModel.poi.count > 0 {
                let section = ListPlaces.FetchPlaces.ViewModel.DisplayedSections(name: "points_of_interest".localized().uppercased(),
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
