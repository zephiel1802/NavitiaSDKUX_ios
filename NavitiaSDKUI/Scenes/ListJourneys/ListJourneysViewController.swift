//
//  ListJourneysViewController.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

import UIKit

protocol ListJourneysLayoutDelegate: class {
    
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath, width: CGFloat) -> CGFloat
}

class ListJourneysLayout: UICollectionViewLayout {

    weak var delegate: ListJourneysLayoutDelegate!
    
    private var numberOfColumns = 1
    private var cellPadding: CGFloat = 5
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        let content = collectionView.bounds.width - (insets.left + insets.right)
        
        if #available(iOS 11.0, *) {
            let safeAreaInsets = collectionView.safeAreaInsets
            return content - (safeAreaInsets.left + safeAreaInsets.right)
        }
        
        return content
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        contentHeight = 0
        
        for numberOfSection in 0 ..< collectionView.numberOfSections {
            // 3. Iterates through the list of items in the first section
            
            for item in 0 ..< collectionView.numberOfItems(inSection: numberOfSection) {
                if item == 0 && numberOfSection == 1 {
                    let height = cellPadding * 2 + 30
                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                    
                    let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: numberOfSection))
                    attributes.frame = insetFrame
                    cache.append(attributes)
                    contentHeight = max(contentHeight, frame.maxY)
                    yOffset[column] = yOffset[column] + height
                    
                    column = column < (numberOfColumns - 1) ? (column + 1) : 0
                }
                let indexPath = IndexPath(item: item, section: numberOfSection)
                
                // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
                
                let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath, width: columnWidth)
                let height = cellPadding * 2 + photoHeight
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                // 6. Updates the collection view content height
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
        }
        

    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
        return attributes
    }
    
    func test() {
        cache.removeAll(keepingCapacity: false)
        
        guard let visibleCells = collectionView?.visibleCells else {
            return
        }
        for i in visibleCells {
            if let cell = i as? JourneySolutionCollectionViewCell {
                cell.friezeView.updatePositionFriezeSectionView()
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

protocol ListJourneysDisplayLogic: class {
    
    func displayFetchedJourneys(viewModel: ListJourneys.FetchJourneys.ViewModel)
}

open class ListJourneysViewController: UIViewController, ListJourneysDisplayLogic {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromPinLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toPinLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var journeysCollectionView: UICollectionView!
    @IBOutlet weak var switchDepartureArrivalImageView: UIImageView!
    @IBOutlet weak var switchDepartureArrivalButton: UIButton!
    
    public var journeysRequest: JourneysRequest?
    private var interactor: ListJourneysBusinessLogic?
    private var router: (NSObjectProtocol & ListJourneysViewRoutingLogic & ListJourneysDataPassing)?
    private var viewModel: ListJourneys.FetchJourneys.ViewModel?

    // MARK: - Initialization
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSDK()
        initArchitecture()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        title = "journeys".localized(withComment: "Journeys", bundle: NavitiaSDKUI.shared.bundle)
        
        initNavigationBar()
        initHeader()
        initCollectionView()

        fetchJourneys()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        journeysCollectionView.collectionViewLayout.invalidateLayout()
        reloadCollectionViewLayout()
    }
    
    private func initSDK() {
        NavitiaSDKUI.shared.bundle = self.nibBundle
        UIFont.registerFontWithFilenameString(filenameString: "SDKIcons.ttf", bundle: NavitiaSDKUI.shared.bundle)
    }
    
    private func initArchitecture() {
        let viewController = self
        let interactor = ListJourneysInteractor()
        let presenter = ListJourneysPresenter()
        let router = ListJourneysRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func initNavigationBar() {
        addBackButton(targetSelector: #selector(backButtonPressed))
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = Configuration.Color.main
    }
    
    private func initHeader() {
        switchDepartureArrivalImageView.image = UIImage(named: "switch", in: NavitiaSDKUI.shared.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        switchDepartureArrivalImageView.tintColor = Configuration.Color.main
        
        fromPinLabel.attributedText = NSMutableAttributedString()
            .icon("location-pin", color: Configuration.Color.origin, size: 22)
        
        toPinLabel.attributedText = NSMutableAttributedString()
            .icon("location-pin", color: Configuration.Color.destination, size: 22)
        
        if let backgroundColor = navigationController?.navigationBar.barTintColor {
            searchView.backgroundColor = backgroundColor
        }
    }
    
    private func initCollectionView() {
        if #available(iOS 11.0, *) {
            journeysCollectionView?.contentInsetAdjustmentBehavior = .always
        }
        
        registerCollectionView()
        let layout = ListJourneysLayout()
        layout.delegate = self
        journeysCollectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        journeysCollectionView.setCollectionViewLayout(layout, animated: true)
        
//        journeysCollectionView.setCollectionViewLayout(LiquidCollectionViewLayout(), animated: true)
//        (journeysCollectionView.collectionViewLayout as! LiquidCollectionViewLayout).delegate = self as! LiquidLayoutDelegate
    }
    
    private func registerCollectionView() {
        journeysCollectionView.register(UINib(nibName: JourneySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionCollectionViewCell.identifier)
        journeysCollectionView.register(UINib(nibName: JourneySolutionLoadCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneySolutionLoadCollectionViewCell.identifier)
        journeysCollectionView.register(UINib(nibName: RidesharingInformationCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: RidesharingInformationCollectionViewCell.identifier)
        journeysCollectionView.register(UINib(nibName: JourneyEmptySolutionCollectionViewCell.identifier, bundle: self.nibBundle), forCellWithReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier)
        journeysCollectionView.register(UINib(nibName: JourneyHeaderCollectionReusableView.identifier, bundle: self.nibBundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: JourneyHeaderCollectionReusableView.identifier)
    }
    
    // MARK: - Events
    
    @objc func backButtonPressed() {
        if isRootViewController() {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func switchDepartureArrivalCoordinates(_ sender: UIButton) {
        if journeysRequest != nil {
            switchDepartureArrivalButton.isEnabled = false
            journeysRequest!.switchOriginDestination()
            fetchJourneys()
        }
    }
    
    // MARK: - Fetch journeys
    
    private func fetchJourneys() {
        guard let journeysRequest = self.journeysRequest else {
            return
        }

        let request = ListJourneys.FetchJourneys.Request(journeysRequest: journeysRequest)
        
        interactor?.fetchJourneys(request: request)
    }
    
    func displayFetchedJourneys(viewModel: ListJourneys.FetchJourneys.ViewModel) {
        self.viewModel = viewModel
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        viewModel.loaded == true ? (switchDepartureArrivalButton.isEnabled = true) : (switchDepartureArrivalButton.isEnabled = false)

        fromLabel.attributedText = viewModel.headerInformations.origin
        toLabel.attributedText = viewModel.headerInformations.destination
        dateTimeLabel.attributedText = viewModel.headerInformations.dateTime
        journeysCollectionView.reloadData()
        
        reloadCollectionViewLayout()
    }
    
    private func reloadCollectionViewLayout() {
        guard let collectionViewLayout = journeysCollectionView.collectionViewLayout as? ListJourneysLayout else {
            return
        }
        
        collectionViewLayout.test()
    }
}

extension ListJourneysViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - CollectionView Data Source
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let journeysRequest = self.journeysRequest, let viewModel = self.viewModel else {
            return 0
        }
        // Journey + Carsharing
        if journeysRequest.ridesharingIsActive && viewModel.loaded {
            return 2
        }
        // Journey
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }
        // Loading
        if !viewModel.loaded {
            return 4
        }
        // Carsharing : Header + Empty
        if section == 1 && viewModel.displayedRidesharings.count == 0 {
            return 2
        }
        // Journey : Empty
        if section == 0 && viewModel.displayedJourneys.count == 0 {
            return 1
        }
        // Carsharing : Header + Solution
        if section == 1 {
            return viewModel.displayedRidesharings.count + 1
        }
        // Journey : Solution
        return viewModel.displayedJourneys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        
        // Loading
        if !viewModel.loaded {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionLoadCollectionViewCell.identifier, for: indexPath) as? JourneySolutionLoadCollectionViewCell {
                return cell
            }
        }
        // Journey
        if indexPath.section == 0 {
            // No journey
            if viewModel.displayedJourneys.count == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier, for: indexPath) as? JourneyEmptySolutionCollectionViewCell {
                    return cell
                }
            }
            // Result
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell {
                cell.setup(displayedJourney: viewModel.displayedJourneys[indexPath.row])
                return cell
            }
        }
        // Carsharing
        if indexPath.section == 1 {
            // Header
            if indexPath.row == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RidesharingInformationCollectionViewCell.identifier, for: indexPath) as? RidesharingInformationCollectionViewCell {
                    return cell
                }
            }
            // No journey
            if indexPath.row == 1 && viewModel.displayedRidesharings.count == 0 {
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyEmptySolutionCollectionViewCell.identifier, for: indexPath) as? JourneyEmptySolutionCollectionViewCell {
                    cell.text = "no_carpooling_options_found".localized(withComment: "No carpooling options found", bundle: NavitiaSDKUI.shared.bundle)
                    return cell
                }
            }
            // Result
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneySolutionCollectionViewCell.identifier, for: indexPath) as? JourneySolutionCollectionViewCell {
                cell.setup(displayedJourney: viewModel.displayedRidesharings[indexPath.row - 1])
                return cell
            }
        }
        // Other
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind.isEqual(UICollectionView.elementKindSectionHeader) {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: JourneyHeaderCollectionReusableView.identifier, for: indexPath) as! JourneyHeaderCollectionReusableView
            cell.title = "carpooling".localized(withComment: "Carpooling", bundle: NavitiaSDKUI.shared.bundle)
            
            return cell
        }
        
        return UICollectionReusableView()
    }

    // MARK: - CollectionView Delegate
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Carsharing : Header
        if section == 1 {
            return CGSize(width: 0, height: 30)
        }
        // Null
        return CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }
        
        var selector: Selector?
        
        if viewModel.loaded {
            if indexPath.section == 0 && viewModel.displayedJourneys.count > indexPath.row {
                selector = NSSelectorFromString("routeToJourneySolutionRoadmapWithIndexPath:")
            } else if indexPath.section == 1 && viewModel.displayedRidesharings.count > indexPath.row - 1 && indexPath.row != 0 {
                selector = NSSelectorFromString("routeToListRidesharingOffersWithIndexPath:")
            }
            
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: indexPath)
            }
        }
    }
}

extension ListJourneysViewController: ListJourneysLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        guard let viewModel = viewModel else {
            return 0
        }
        
        // Loading
        if !viewModel.loaded {
            return 130
        }
        // Journey
        if indexPath.section == 0 {
            if viewModel.displayedJourneys.count == 0 {
                // No journey
                return 35
            }
            var height: CGFloat = 60
            if let _ = viewModel.displayedJourneys[safe: indexPath.row]?.walkingInformation {
                height += 30
            }
            
            if let sections = viewModel.displayedJourneys[safe: indexPath.row]?.friezeSections {
                
                let frire = FriezeView(frame: CGRect(x: 0, y: 0, width: width - 20, height: 27))
                frire.addSection(friezeSections: sections)
                
                return height + frire.frame.size.height
            }
        }
        // Carsharing
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // Header
                return 75
            } else if indexPath.row == 1 && viewModel.displayedRidesharings.count == 0 {
                // No journey
                return 35
            }
            var height: CGFloat = 60
            if let _ = viewModel.displayedJourneys[safe: indexPath.row]?.walkingInformation {
                height += 30
            }
            
            if let sections = viewModel.displayedJourneys[safe: indexPath.row]?.friezeSections {
                
                let frire = FriezeView(frame: CGRect(x: 0, y: 0, width: width - 20, height: 27))
                frire.addSection(friezeSections: sections)
                
                return height + frire.frame.size.height
            }
        }
        // Other
        return 117
    }
}
