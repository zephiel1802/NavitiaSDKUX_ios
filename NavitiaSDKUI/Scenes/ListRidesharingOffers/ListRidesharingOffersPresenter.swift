//
//  ListRidesharingOffersPresenter.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import Foundation

protocol ListRidesharingOffersPresentationLogic {
    
    func presentRidesharingOffers(response: ListRidesharingOffers.GetRidesharingOffers.Response)
}

class ListRidesharingOffersPresenter: ListRidesharingOffersPresentationLogic {
    
    weak var viewController: ListRidesharingOffersDisplayLogic?
    
    func presentRidesharingOffers(response: ListRidesharingOffers.GetRidesharingOffers.Response) {
        guard let duration = response.journey.duration else {
            return
        }
        
        let displayedRidesharingOffers = getRidesharingOffers(ridesharingJourneys: response.ridesharingJourneys)
        let friezeSections = FriezePresenter().getDisplayedJourneySections(journey: response.journey, disruptions: response.disruptions)
        let frieze = ListRidesharingOffers.GetRidesharingOffers.ViewModel.Frieze(duration: duration, friezeSections: friezeSections)
        let viewModel = ListRidesharingOffers.GetRidesharingOffers.ViewModel(frieze: frieze, displayedRidesharingOffers: displayedRidesharingOffers)
        
        viewController?.displayRidesharingOffers(viewModel: viewModel)
    }
    
    private func getRidesharingSection(ridesharingJourney: Journey?) -> Section? {
        guard let ridesharingJourney = ridesharingJourney, let ridesharingSections = ridesharingJourney.sections else {
            return nil
        }
        
        for section in ridesharingSections {
            if section.type == .ridesharing {
                return section
            }
        }
        
        return nil
    }
    
    private func getRidesharingOffers(ridesharingJourneys: [Journey]?) -> [ListRidesharingOffers.GetRidesharingOffers.ViewModel.DisplayedRidesharingOffer] {
        var displayedRidesharingOffers = [ListRidesharingOffers.GetRidesharingOffers.ViewModel.DisplayedRidesharingOffer]()
        
        guard let ridesharingJourneys = ridesharingJourneys else {
            return displayedRidesharingOffers
        }
        
        for journey in ridesharingJourneys {
            if let ridesharingSection = getRidesharingSection(ridesharingJourney: journey) {
                let network = ridesharingSection.ridesharingInformations?.network ?? ""
                let departure = ridesharingSection.departureDateTime?.toDate(format: Configuration.date)?.toString(format: Configuration.timeRidesharing) ?? ""
                let driverPictureURL = ridesharingSection.ridesharingInformations?.driver?.image ?? ""
                let driverNickname = ridesharingSection.ridesharingInformations?.driver?.alias ?? ""
                let driverGender = ridesharingSection.ridesharingInformations?.driver?.gender?.rawValue ?? ""
                let rating = ridesharingSection.ridesharingInformations?.driver?.rating?.value ?? 0
                let ratingCount = ridesharingSection.ridesharingInformations?.driver?.rating?.count ?? 0
                let seatsCount = ridesharingSection.ridesharingInformations?.seats?.available
                let price = journey.fare?.total?.value ?? ""
                
                let ridesharingOffer = ListRidesharingOffers.GetRidesharingOffers.ViewModel.DisplayedRidesharingOffer(network: network,
                                                                                                                      departure: departure,
                                                                                                                      driverPictureURL: driverPictureURL,
                                                                                                                      driverNickname: driverNickname,
                                                                                                                      driverGender: driverGender,
                                                                                                                      rating: rating,
                                                                                                                      ratingCount: ratingCount,
                                                                                                                      seatsCount: seatsCount,
                                                                                                                      price: price)
                displayedRidesharingOffers.append(ridesharingOffer)
            }
        }
        
        return displayedRidesharingOffers
    }
}
