//
//  ListPlacesViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import UIKit

protocol ListPlacesViewControllerDelegate: class {
    
    func searchView(from: (name: String?, id: String), to: (name: String?, id: String))
}

protocol ListPlacesDisplayLogic: class {
    
    func displaySomething(viewModel: ListPlaces.FetchPlaces.ViewModel)
}

class ListPlacesViewController: UIViewController, ListPlacesDisplayLogic {
    
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var tableView: UITableView!
    
    var from: (name: String?, id: String)?
    var to: (name: String?, id: String)?
    
    weak var delegate: ListPlacesViewControllerDelegate?
    var firstBecome = "from"
    private var debouncedSearch: Debouncer?
    private var q: String = ""
    
    var interactor: ListPlacesBusinessLogic?
    var router: (NSObjectProtocol & ListPlacesRoutingLogic & ListPlacesDataPassing)?
    private var viewModel: ListPlaces.FetchPlaces.ViewModel?
    
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initArchitecture()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        title = "journeys".localized()
        
        initNavigationBar()
        initDebouncer()
        initHeader()
        initTableView()
        
        searchView.fromTextField.text = from?.name
        searchView.toTextField.text = to?.name
        
        searchView.background.backgroundColor = .clear
        searchView.switchIsHidden = true
        searchView.separatorView.isHidden = true
        
        
        hideKeyboardWhenTappedAround()
        if firstBecome == "from" {
            searchView.fromTextField.becomeFirstResponder()
            searchView.fromView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
            fetchPlaces(q: searchView.fromTextField.text)
        } else {
            searchView.toTextField.becomeFirstResponder()
            searchView.toView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
            fetchPlaces(q: searchView.toTextField.text)
        }
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.15) {
            self.searchView.animatedd()
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Setup
    
    private func initArchitecture() {
        let viewController = self
        let interactor = ListPlacesInteractor()
        let presenter = ListPlacesPresenter()
        let router = ListPlacesRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    private func initNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = Configuration.Color.main
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:  #selector(backButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = Configuration.Color.main.contrastColor()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Configuration.Color.main.contrastColor()]
    }
    
    private func initDebouncer() {
        debouncedSearch = Debouncer(delay: 0.15) {
            self.fetchPlaces(q: self.q)
        }
    }
    
    private func initHeader() {
        searchView.delegate = self
        searchView.dateTimeIsHidden = true
    }
    
    private func initTableView() {
        registerTableView()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
    
    private func registerTableView() {
        tableView.register(UINib(nibName: PlacesTableViewCell.identifier, bundle: self.nibBundle), forCellReuseIdentifier: PlacesTableViewCell.identifier)
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    
    // MARK: Do something

    func fetchPlaces(q: String?) {
        guard let q = q else {
            return
        }
        
        let request = ListPlaces.FetchPlaces.Request(q: q, coord: nil)
        
        interactor?.fetchJourneys(request: request)
    }
    
    func displaySomething(viewModel: ListPlaces.FetchPlaces.ViewModel) {
        self.viewModel = viewModel
        
        tableView.reloadData()
    }
    
    // MARK: - Events
    
    @objc func backButtonPressed() {
        UIView.animate(withDuration: 0.15) {
            self.searchView.animateddFalse()
            self.view.layoutIfNeeded()
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ListPlacesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.sections[section].name
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else {
            return nil
        }
        
        let view = PlacesHeaderView.instanceFromNib()
        
        if let name = viewModel.sections[section].name {
            view.title = name
        }
        
        if section == 0 {
            view.lineView.isHidden = true
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        
        return viewModel.sections[section].places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PlacesTableViewCell.identifier, for: indexPath) as? PlacesTableViewCell,
            let viewModel = viewModel {
                cell.nameLabel.text = viewModel.sections[indexPath.section].places[indexPath.row].name
                cell.type = viewModel.sections[indexPath.section].type
                
                return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let name = viewModel?.sections[indexPath.section].places[indexPath.row].name,
            let id = viewModel?.sections[indexPath.section].places[indexPath.row].id else {
                return
        }
        
        if firstBecome == "from" {
            from = (name: name, id: id)
            searchView.fromTextField.text = name
            searchView.fromView.backgroundColor = Configuration.Color.white
            if searchView.toTextField.text == "" {
                searchView.toTextField.becomeFirstResponder()
                searchView.toView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
                viewModel = nil
                tableView.reloadData()
                firstBecome = "to"
            } else {
                if let from = from, let to = to {
                    delegate?.searchView(from: from,
                                         to: to)
                }
                self.dismiss(animated: true, completion: nil)
            }
            
        } else {
            to = (name: name, id: id)
            searchView.toTextField.text = name
            searchView.toView.backgroundColor = Configuration.Color.white
            if searchView.fromTextField.text == "" {
                searchView.fromTextField.becomeFirstResponder()
                searchView.fromView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
                viewModel = nil
                tableView.reloadData()
                firstBecome = "from"
            } else {
                if let from = from, let to = to {
                    delegate?.searchView(from: from,
                                         to: to)
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        guard let _ = ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) else {
            return
        }
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ListPlacesViewController: SearchViewDelegate {
    
    func switchDepartureArrivalCoordinates() {}
    
    func fromFieldClicked(q: String?) {
        firstBecome = "from"
        searchView.fromView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
        searchView.toView.backgroundColor = Configuration.Color.white
        
        guard let q = q else {
            return
        }
        
        self.q = q
        
        debouncedSearch?.call()
    }
    
    func toFieldClicked(q: String?) {
        firstBecome = "to"
        searchView.fromView.backgroundColor = Configuration.Color.white
        searchView.toView.backgroundColor = Configuration.Color.white.withAlphaComponent(0.9)
        
        guard let q = q else {
            return
        }
        
        self.q = q
        
        debouncedSearch?.call()
    }
    
    func fromFieldDidChange(q: String?) {
        guard let q = q else {
            return
        }
        
        self.q = q
        
        debouncedSearch?.call()
    }
    
    func toFieldDidChange(q: String?) {
        guard let q = q else {
            return
        }
        
        self.q = q
        
        debouncedSearch?.call()
    }
}
