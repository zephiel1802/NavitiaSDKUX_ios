//
//  EasyTickHeaderView.swift
//  EasyTick
//
//  Created by Nhan iOS on 11/5/18.
//  Copyright © 2018 elisoft. All rights reserved.
//

import UIKit
let titleHeaderTag = 113
let topHeaderViewTag = 114
typealias HeaderViewActionBlock = () -> Void
class HeaderView: UIView {

    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var ivActionIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwBackground: UIView!
    
    var actionBlock : HeaderViewActionBlock?
    
    static var identifier: String {
        return String(describing: self)
    }
    
    class func instanceFromNib() -> HeaderView {
        return UINib(nibName: identifier, bundle: NavitiaSDKUI.shared.bundle).instantiate(withOwner: nil, options: nil)[0] as! HeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTitle.font = FontManager.font(name: MontserratFont.semiBold.rawValue, size: CGFloat(22))
        lblTitle.textColor = .white
    }
    
    
    @IBAction func touchActionButton(){
        actionBlock?()
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        guard subviews.isEmpty else {
            return self
        }
        
        let searchView = HeaderView.instanceFromNib()
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.frame = self.bounds
        searchView.createDefaultGradientView()
        return searchView
    }
    
    static func setupHeaderView(in parentView: UIView, with title: String, showBackButton: Bool = false, action: HeaderViewActionBlock? = nil) {
        parentView.removeAllSubviews()
        let view = HeaderView.instanceFromNib()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            parentView.addSubview(view)
            parentView.addHorizontalConstraint(toView: view)
            parentView.addVerticalConstraint(toView: view)
            
            view.layoutIfNeeded()
            view.tag = topHeaderViewTag
            view.vwBackground.createDefaultGradientView()
            
            view.lblTitle.text = title
            view.lblTitle.tag = titleHeaderTag
            view.actionBlock = action
            view.ivActionIcon.image = showBackButton ? UIImage(named: "arrow_left") : UIImage(named: "arrow_left")
    }
}

enum MontserratFont: String {
    case light = "Montserrat-Light"
    case regular = "Montserrat-Regular"
    case semiBold = "Montserrat-SemiBold"
    case medium = "Montserrat-Medium"
    case bold = "Montserrat-Bold"
}

enum NunitoSansFont: String {
    case light = "NunitoSans-Light"
    case regular = "NunitoSans-Regular"
    case semiBold = "NunitoSans-SemiBold"
    case bold = "NunitoSans-Bold"
    case black = "NunitoSans-Black"
}

struct FontManager {
    static func printAllFonts(){
        for family: String in UIFont.familyNames
        {
            print(family)
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
    }
    
    static func font(name: String = MontserratFont.light.rawValue, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else { return UIFont.boldSystemFont(ofSize: size) }
        return font
    }
    
//    static let size8 = Device.size(small: 8, medium: 10, big: 12)
//    static let size10 = Device.size(small: 10, medium: 12, big: 14)
//    static let size12 = Device.size(small: 12, medium: 14, big: 16)
//    static let size14 = Device.size(small: 14, medium: 16, big: 18)
//    static let size16 = Device.size(small: 16, medium: 18, big: 20)
//    static let size18 = Device.size(small: 18, medium: 20, big: 22)
//    static let size20 = Device.size(small: 20, medium: 22, big: 24)
//    static let size22 = Device.size(small: 22, medium: 24, big: 26)
//    static let size24 = Device.size(small: 24, medium: 26, big: 28)
//    static let size42 = Device.size(small: 42, medium: 44, big: 46)
//    static let size52 = Device.size(small: 52, medium: 54, big: 56)
}

struct ColorManager {
    static var colorDic : Dictionary<String, String>?
    
    static func loadColors(){
        if let path = Bundle.main.path(forResource: "Colors", ofType: "plist"),
            let root = NSDictionary(contentsOfFile: path) as? Dictionary<String, String>{
            
            colorDic = root
            
            //            print(colorDic!)
        }
    }
    
    
    static func color(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
    }
    
    static func colorWithHex (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        var rgbValue:UInt32 = 0
        
        if ((cString.count) != 6) {
            let scanner = Scanner(string: cString.uppercased())
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                return UIColor(
                    red: CGFloat((hexNumber & 0x00FF0000) >> 16) / 255.0,
                    green: CGFloat((hexNumber & 0x0000FF00) >> 8) / 255.0,
                    blue: CGFloat(hexNumber & 0x000000FF) / 255.0,
                    alpha: CGFloat((hexNumber & 0xFF000000) >> 24) / 255
                )
            }
        }
        
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static var backgroundView : UIColor { //White
        if let dic = colorDic, let hex = dic["backgroundView"]{
            return colorWithHex(hex: hex)
        }
        
        return .white
    }
    
    static var colorActiveText : UIColor { //Color for title text - blue
        if let dic = colorDic, let hex = dic["colorActiveText"]{
            return colorWithHex(hex: hex)
        }
        
        return .black
    }
    
    static var colorActiveDarkText : UIColor { //Black
        return colorWithHex(hex: "#BF000000")
    }
    
    static var colorStartGradient : UIColor { //Gradient Pink
        return colorWithHex(hex: "#C53F82")
    }
    
    static var colorEndGradient : UIColor { //Gradient blue
        return colorWithHex(hex: "#1A3B87")
    }
    
    static var colorAccent : UIColor { //Color for text - Pink
        if let dic = colorDic, let hex = dic["colorAccent"]{
            return colorWithHex(hex: hex)
        }
        
        return .black
    }
    
    static var colorPrice : UIColor { //Color for price - Pink
        if let dic = colorDic, let hex = dic["colorPrice"]{
            return colorWithHex(hex: hex)
        }
        
        return .black
    }
    
    static var ticketStateActivatedColor : UIColor { //Color for ticket - green
        if let dic = colorDic, let hex = dic["ticketStateActivatedColor"]{
            return colorWithHex(hex: hex)
        }
        
        return .black
    }
    
    static var colorPrimary : UIColor { //light blue
        if let dic = colorDic, let hex = dic["colorPrimary"]{
            return colorWithHex(hex: hex)
        }
        
        return .black
    }
    
    static var deleteColor : UIColor { //red
        if let dic = colorDic, let hex = dic["deleteColor"]{
            return colorWithHex(hex: hex)
        }
        
        return .red
    }
    
    static var colorRipple : UIColor { //lightgray
        if let dic = colorDic, let hex = dic["colorRipple"]{
            return colorWithHex(hex: hex)
        }
        
        return .lightGray
    }
    
    static var ticketStateNotActiveColor : UIColor { //darkgray
        if let dic = colorDic, let hex = dic["ticketStateNotActiveColor"]{
            return colorWithHex(hex: hex)
        }
        
        return .darkGray
    }
}

extension UIView {
    
    func addsubviews(_ views: UIView...) {
        
        for subview in views {
            
            addSubview(subview)
        }
    }
    
    
    func createDefaultGradientView(){
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowColor = ColorManager.colorActiveDarkText.withAlphaComponent(0.3).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 8
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        gradient.colors = [ColorManager.colorStartGradient.cgColor,ColorManager.colorEndGradient.cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1.2, y: 1.7)
        gradient.endPoint = CGPoint(x: -0.1, y: -0.2)
        self.layer.addSublayer(gradient)
    }
    
    
    func createBorder(_ width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func createRoundCorner(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func createRoundedShadow(shadowColor: UIColor = .lightGray, radius: CGFloat) {
        layer.masksToBounds = false
        clipsToBounds = false
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 15
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func createTopShadow(shadowColor: UIColor = .lightGray){
        layer.masksToBounds = false
        clipsToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
    }
    
    func createBottomShadow(shadowColor: UIColor = .lightGray){
        layer.masksToBounds = false
        clipsToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
    }
    
    func createCustomShadow(shadowColor: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        clipsToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    func createImageGradident(startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            UIColor(red:1, green:1, blue:1, alpha:0).cgColor,
            UIColor(red:1, green:1, blue:1, alpha:0.75).cgColor,
            UIColor(red:1, green:1, blue:1, alpha:0.95).cgColor,
            UIColor.white.cgColor
        ]
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        self.layer.addSublayer(gradient)
    }
    
    func createCircleShape() {
        createRoundCorner(frame.size.width / 2)
    }
    
    func createImageFromView() -> UIImage {
        UIGraphicsBeginImageContext(bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func addHorizontalConstraint(toView view: UIView) {
        
        addConstraints(withFormat: "H:|[v0]|", views: view)
    }
    
    func addVerticalConstraint(toView view: UIView) {
        addConstraints(withFormat: "V:|[v0]|", views: view)
    }
    
    func addConstraints(withFormat format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for i in 0 ..< views.count {
            let key = "v\(i)"
            views[i].translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = views[i]
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func addConstraintsWith(withFormat format: String, views: UIView...) ->  [NSLayoutConstraint]{
        
        var viewsDictionary = [String: UIView]()
        
        for i in 0 ..< views.count {
            let key = "v\(i)"
            views[i].translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = views[i]
        }
        
        let thisConstraint = NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary)
        addConstraints(thisConstraint)
        return thisConstraint
    }
    
    func enableConstraint(constraints: [NSLayoutConstraint], isActive: Bool){
        for constraint in constraints{
            constraint.isActive = isActive
        }
    }
    
    func removeAllSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    
    
    func createCameraCorners(lineWidth: CGFloat, lineColor: UIColor) {
        
        //Calculate the length of corner to be shown
        let cornerLengthToShow = self.bounds.size.height * 0.10
        print(cornerLengthToShow)
        
        // Create Paths Using BeizerPath for all four corners
        let topLeftCorner = UIBezierPath()
        topLeftCorner.move(to: CGPoint(x: self.bounds.minX, y: self.bounds.minY + cornerLengthToShow))
        topLeftCorner.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.minY))
        topLeftCorner.addLine(to: CGPoint(x: self.bounds.minX + cornerLengthToShow, y: self.bounds.minY))
        
        let topRightCorner = UIBezierPath()
        topRightCorner.move(to: CGPoint(x: self.bounds.maxX - cornerLengthToShow, y: self.bounds.minY))
        topRightCorner.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        topRightCorner.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY + cornerLengthToShow))
        
        let bottomRightCorner = UIBezierPath()
        bottomRightCorner.move(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY - cornerLengthToShow))
        bottomRightCorner.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
        bottomRightCorner.addLine(to: CGPoint(x: self.bounds.maxX - cornerLengthToShow, y: self.bounds.maxY ))
        
        let bottomLeftCorner = UIBezierPath()
        bottomLeftCorner.move(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY - cornerLengthToShow))
        bottomLeftCorner.addLine(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY))
        bottomLeftCorner.addLine(to: CGPoint(x: self.bounds.minX + cornerLengthToShow, y: self.bounds.maxY))
        
        let combinedPath = CGMutablePath()
        combinedPath.addPath(topLeftCorner.cgPath)
        combinedPath.addPath(topRightCorner.cgPath)
        combinedPath.addPath(bottomRightCorner.cgPath)
        combinedPath.addPath(bottomLeftCorner.cgPath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = combinedPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        
        layer.addSublayer(shapeLayer)
    }
}
