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
        let viewModel = FormJourney.DisplaySearch.ViewModel(fromName: response.fromName,
                                                            toName: response.toName)
        
        viewController?.displaySearch(viewModel: viewModel)
    }
}
