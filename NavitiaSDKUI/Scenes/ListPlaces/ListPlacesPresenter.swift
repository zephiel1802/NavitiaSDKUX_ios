//
//  ListPlacesPresenter.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol ListPlacesPresentationLogic {
    
    func presentDisplayedSearch(response: ListPlaces.DisplaySearch.Response)
    func presentHistoryPlace(response: [Journeysss], locationAddress: Address?)
    func presentSomething(response: ListPlaces.FetchPlaces.Response)
}

class ListPlacesPresenter: ListPlacesPresentationLogic {
    
    weak var viewController: ListPlacesDisplayLogic?
    
    // MARK: Do something
    
    func presentDisplayedSearch(response: ListPlaces.DisplaySearch.Response) {
        let viewModel = ListPlaces.DisplaySearch.ViewModel(fromName: response.info == "from" ? response.from?.name : response.from?.name ?? response.from?.label ?? response.from?.id,
                                                           toName: response.info == "to" ?  response.to?.name : response.to?.name ?? response.to?.label ?? response.to?.id,
                                                           info: response.info)
        
        viewController?.displaySearch(viewModel: viewModel)
    }
    
    func presentSomething(response: ListPlaces.FetchPlaces.Response) {
        let viewModel = ListPlaces.FetchPlaces.ViewModel(displayedSections: getSection(places: response.places, address: response.locationAddress))
        
        viewController?.displaySomething(viewModel: viewModel)
    }
    
    func presentHistoryPlace(response: [Journeysss], locationAddress: Address?) {
        var sections = [ListPlaces.FetchPlaces.ViewModel.DisplayedSections]()
        var placesNew = [ListPlaces.FetchPlaces.ViewModel.Place]()

        if let label = locationAddress?.label, let lon = locationAddress?.coord?.lon, let lat = locationAddress?.coord?.lat {
            let place = ListPlaces.FetchPlaces.ViewModel.Place(label: "Ma position", name: label, id: String(format: "%@;%@", lon, lat), type: .location)
            let section = ListPlaces.FetchPlaces.ViewModel.DisplayedSections(/*type: .location,*/
                name: nil,
                places: [place])
            sections.append(section)
        }

        for i in response {
            if let embeddedType = ListPlaces.FetchPlaces.ViewModel.ModelType(rawValue: i.type) {
                let place = ListPlaces.FetchPlaces.ViewModel.Place(label: nil, name: i.name, id: i.idNavitia, type: embeddedType)
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
            let place = ListPlaces.FetchPlaces.ViewModel.Place(label: nil, name: label, id: String(format: "%@;%@", lon, lat), type: .location)
            let section = ListPlaces.FetchPlaces.ViewModel.DisplayedSections(name: nil,
                                                                   places: [place])
            sections.append(section)
        }
        
        if let placesViewModel = getPlaces(places: places) {
            if placesViewModel.stopArea.count > 0 {
                let section = ListPlaces.FetchPlaces.ViewModel.DisplayedSections(name: String(format: "%@ - %@", "stops".localized(), "stations".localized()).uppercased(),
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
                let placeViewModel = ListPlaces.FetchPlaces.ViewModel.Place(label: nil, name: name, id: id, type: type)

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
}
