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
    
    private func getPrice(journey: Journey) -> String {
        guard let value = journey.fare?.total?.value, let price = Double(value) else {
            return "price_not_available".localized()
        }
        
        if price == 0.0 {
            return String(format: "%@.", "free".localized())
        }
        
        return String(format: "%.2f.", price)
    }
    
    private func getRidesharingOffers(ridesharingJourneys: [Journey]?) -> [ListRidesharingOffers.GetRidesharingOffers.ViewModel.DisplayedRidesharingOffer] {
        var displayedRidesharingOffers = [ListRidesharingOffers.GetRidesharingOffers.ViewModel.DisplayedRidesharingOffer]()
        
        guard let ridesharingJourneys = ridesharingJourneys else {
            return displayedRidesharingOffers
        }
        
        for journey in ridesharingJourneys {
            if let ridesharingSection = getRidesharingSection(ridesharingJourney: journey) {
                let network = ridesharingSection.ridesharingInformations?.network ?? ""
                let departure = ridesharingSection.departureDateTime?.toDate(format: Configuration.datetime)?.toString(format: Configuration.timeRidesharing) ?? ""
                let driverPictureURL = ridesharingSection.ridesharingInformations?.driver?.image ?? ""
                let driverNickname = ridesharingSection.ridesharingInformations?.driver?.alias ?? ""
                let driverGender = ridesharingSection.ridesharingInformations?.driver?.gender?.rawValue ?? ""
                let rating = ridesharingSection.ridesharingInformations?.driver?.rating?.value ?? 0
                let ratingCount = ridesharingSection.ridesharingInformations?.driver?.rating?.count ?? 0
                let seatsCount = ridesharingSection.ridesharingInformations?.seats?.available
                let price = getPrice(journey: journey)
                
                var ridesharingOffer = ListRidesharingOffers.GetRidesharingOffers.ViewModel.DisplayedRidesharingOffer(network: network,
                                                                                                                      departure: departure,
                                                                                                                      driverPictureURL: driverPictureURL,
                                                                                                                      driverNickname: driverNickname,
                                                                                                                      driverGender: driverGender,
                                                                                                                      rating: rating,
                                                                                                                      ratingCount: ratingCount,
                                                                                                                      seatsCount: seatsCount,
                                                                                                                      price: price,
                                                                                                                      accessiblityLabel: "")
                ridesharingOffer.accessiblityLabel = getAccessiblityLabel(ridesharingOffer: ridesharingOffer)
                displayedRidesharingOffers.append(ridesharingOffer)
            }
        }
        
        return displayedRidesharingOffers
    }
    
    private func getAccessiblityLabel(ridesharingOffer: ListRidesharingOffers.GetRidesharingOffers.ViewModel.DisplayedRidesharingOffer) -> String {
        var accessibilityLabel = String(format: "ridesharing_departure_at".localized(), ridesharingOffer.departure, ridesharingOffer.driverNickname)
        
        if let seatsCount = ridesharingOffer.seatsCount {
            accessibilityLabel.append(String(format: "ridesharing_available_places".localized(), seatsCount))
        }
        
        accessibilityLabel.append(ridesharingOffer.price)
        
        if ridesharingOffer.ratingCount == 0 {
            accessibilityLabel.append("no_rating".localized())
        } else {
            accessibilityLabel.append(String(format: "rating_out_of_five".localized(), String(ridesharingOffer.rating)))
        }
        
        accessibilityLabel.append("view_on_the_map".localized())
        
        return accessibilityLabel
    }
}
