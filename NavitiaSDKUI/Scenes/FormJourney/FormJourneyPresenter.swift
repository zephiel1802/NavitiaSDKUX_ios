//
//  FormJourneyPresenter.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol FormJourneyPresentationLogic {

    func presentDisplayedSearch(response: FormJourney.DisplaySearch.Response)
}

class FormJourneyPresenter: FormJourneyPresentationLogic {
    
    weak var viewController: FormJourneyDisplayLogic?
    
    func presentDisplayedSearch(response: FormJourney.DisplaySearch.Response) {
        let fromName = response.journeysRequest.originLabel ??
            response.journeysRequest.originName ??
            response.journeysRequest.originId
        let toName =  response.journeysRequest.destinationLabel ??
            response.journeysRequest.destinationName ??
            response.journeysRequest.destinationId
        let viewModel = FormJourney.DisplaySearch.ViewModel(fromName: fromName, toName: toName)
        
        viewController?.displaySearch(viewModel: viewModel)
    }
}
