//
//  ListPlacesPresenter.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol ListPlacesPresentationLogic {
    
    func presentSomething(response: ListPlaces.FetchPlaces.Response)
}

class ListPlacesPresenter: ListPlacesPresentationLogic {
    
    weak var viewController: ListPlacesDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: ListPlaces.FetchPlaces.Response) {
        let viewModel = ListPlaces.FetchPlaces.ViewModel(sections: getSection(places: response.places))
        
        viewController?.displaySomething(viewModel: viewModel)
    }
    
    private func geoloc() {
        
    }
    
    private func getSection(places: Places?) -> [ListPlaces.FetchPlaces.ViewModel.Section] {
        var sections = [ListPlaces.FetchPlaces.ViewModel.Section]()
        
        if let placesViewModel = getPlaces(places: places) {
            if placesViewModel.stopArea.count > 0 {
                let section = ListPlaces.FetchPlaces.ViewModel.Section(type: .stopArea,
                                                                       name: "ARRÊTS - STATIONS",
                                                                       places: placesViewModel.stopArea)
                sections.append(section)
            }
            if placesViewModel.address.count > 0 {
                let section = ListPlaces.FetchPlaces.ViewModel.Section(type: .address,
                                                                       name: "ADRESSE",
                                                                       places: placesViewModel.address)
                sections.append(section)
            }
            if placesViewModel.poi.count > 0 {
                let section = ListPlaces.FetchPlaces.ViewModel.Section(type: .poi,
                                                                       name: "POINTS D'INTERÊT",
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
            let placeViewModel = ListPlaces.FetchPlaces.ViewModel.Place(name: place.name ?? "", id: place.id ?? "")
            
            if place.embeddedType == .stopArea {
                stopArea.append(placeViewModel)
            } else if place.embeddedType == .address || place.embeddedType == .administrativeRegion {
                address.append(placeViewModel)
            } else if place.embeddedType == .poi {
                poi.append(placeViewModel)
            }
        }
        
        return (stopArea: stopArea, address: address, poi: poi)
    }
}
