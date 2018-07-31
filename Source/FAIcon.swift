import Foundation
import UIKit

public extension UITextField {
    
    public func setRightViewFAIcon(icon: FAType, rightViewMode: UITextFieldViewMode = .always, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = .black, backgroundColor: UIColor = .clear, size: CGSize? = nil) {
        FontLoader.loadFont(icon)
        
        let image = UIImage(icon: icon, size: size ?? CGSize(width: 30, height: 30), orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
        let imageView = UIImageView.init(image: image)
        
        self.rightView = imageView
        self.rightViewMode = rightViewMode
    }
    
    public func setLeftViewFAIcon(icon: FAType, leftViewMode: UITextFieldViewMode = .always, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = .black, backgroundColor: UIColor = .clear, size: CGSize? = nil) {
        FontLoader.loadFont(icon)
        
        let image = UIImage(icon: icon, size: size ?? CGSize(width: 30, height: 30), orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
        let imageView = UIImageView.init(image: image)
        
        self.leftView = imageView
        self.leftViewMode = leftViewMode
    }
}

public extension UIBarButtonItem {
    
    /**
     To set an icon, use i.e. `barName.FAIcon = FAType.FAGithub`
     */
    func setFAIcon(icon: FAType, iconSize: CGFloat) {
        FontLoader.loadFont(icon)
        let font = UIFont(name: icon.fontName(), size: iconSize)
        assert(font != nil, FAStruct.ErrorAnnounce)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .selected)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .highlighted)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .disabled)
        title = icon.text
    }
    
    /**
     To set an icon, use i.e. `barName.setFAIcon(FAType.FAGithub, iconSize: 35)`
     */
    var FAIcon: FAType? {
        set {
            FontLoader.loadFont(newValue!)
            let font = UIFont(name: newValue!.fontName(), size: 23)
            assert(font != nil,FAStruct.ErrorAnnounce)
            setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
            setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .selected)
            setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .highlighted)
            setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .disabled)
            title = newValue?.text
        }
        get {
            guard let title = title, let index = FATypeHelper.index(of: title, type: self) else { return nil }
            return FATypeHelper.rawValue(rawValue: index, type: self)
        }
    }
    
    func setFAText(prefixText: String, icon: FAType?, postfixText: String, size: CGFloat) {
        FontLoader.loadFont(icon!)
        let font = UIFont(name: icon!.fontName(), size: size)
        assert(font != nil, FAStruct.ErrorAnnounce)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .selected)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .highlighted)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .disabled)
        
        var text = prefixText
        if let iconText = icon?.text {
            text += iconText
        }
        text += postfixText
        title = text
    }
}


public extension UIButton {
    
    /**
     To set an icon, use i.e. `buttonName.setFAIcon(FAType.FAGithub, forState: .Normal)`
     */
    func setFAIcon(icon: FAType, forState state: UIControlState) {
        FontLoader.loadFont(icon)
        guard let titleLabel = titleLabel else { return }
        setAttributedTitle(nil, for: state)
        let font = UIFont(name: icon.fontName(), size: titleLabel.font.pointSize)
        assert(font != nil, FAStruct.ErrorAnnounce)
        titleLabel.font = font!
        setTitle(icon.text, for: state)
    }
    
    /**
     To set an icon, use i.e. `buttonName.setFAIcon(FAType.FAGithub, iconSize: 35, forState: .Normal)`
     */
    func setFAIcon(icon: FAType, iconSize: CGFloat, forState state: UIControlState) {
        setFAIcon(icon: icon, forState: state)
        guard let fontName = titleLabel?.font.fontName else { return }
        titleLabel?.font = UIFont(name: fontName, size: iconSize)
    }
    
    func setFAText(prefixText: String, icon: FAType?, postfixText: String, size: CGFloat?, forState state: UIControlState, iconSize: CGFloat? = nil) {
        setTitle(nil, for: state)
        FontLoader.loadFont(icon!)
        guard let titleLabel = titleLabel else { return }
        let attributedText = attributedTitle(for: .normal) ?? NSAttributedString()
        let  startFont =  attributedText.length == 0 ? nil : attributedText.attribute(NSAttributedStringKey.font, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attributedText.length == 0 ? nil : attributedText.attribute(NSAttributedStringKey.font, at: attributedText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = titleLabel.font
        if let f = startFont , f.fontName != icon!.fontName()  {
            textFont = f
        } else if let f = endFont , f.fontName != icon!.fontName()  {
            textFont = f
        }
        if let fontSize = size {
            textFont = textFont?.withSize(fontSize)
        }
        var textColor: UIColor = .black
        attributedText.enumerateAttribute(NSAttributedStringKey.foregroundColor, in:NSMakeRange(0,attributedText.length), options:.longestEffectiveRangeNotRequired) {
            value, range, stop in
            if value != nil {
                textColor = value as! UIColor
            }
        }
        
        let textAttributes = [NSAttributedStringKey.font: textFont!, NSAttributedStringKey.foregroundColor: textColor] as [NSAttributedStringKey : Any]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttributes)
        
        if let iconText = icon?.text {
            let iconFont = UIFont(name: icon!.fontName(), size: iconSize ?? size ?? titleLabel.font.pointSize)!
            let iconAttributes = [NSAttributedStringKey.font: iconFont, NSAttributedStringKey.foregroundColor: textColor] as [NSAttributedStringKey : Any]
            
            let iconString = NSAttributedString(string: iconText, attributes: iconAttributes)
            prefixTextAttribured.append(iconString)
        }
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttributes)
        prefixTextAttribured.append(postfixTextAttributed)
        
        setAttributedTitle(prefixTextAttribured, for: state)
    }
    
    func setFATitleColor(color: UIColor, forState state: UIControlState = .normal) {
        if let faIcon = self.titleLabel?.FAIcon {
            FontLoader.loadFont(faIcon)
        }
        
        let attributedString = NSMutableAttributedString(attributedString: attributedTitle(for: state) ?? NSAttributedString())
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSMakeRange(0, attributedString.length))
        
        setAttributedTitle(attributedString, for: state)
        setTitleColor(color, for: state)
    }
}


public extension UILabel {
    
    /**
     To set an icon, use i.e. `labelName.FAIcon = FAType.FAGithub`
     */
    var FAIcon: FAType? {
        set {
            guard let newValue = newValue else { return }
            FontLoader.loadFont(newValue)
            let fontAwesome = UIFont(name: newValue.fontName(), size: self.font.pointSize)
            assert(font != nil, FAStruct.ErrorAnnounce)
            font = fontAwesome!
            text = newValue.text
        }
        get {
            guard let text = text, let index = FATypeHelper.index(of: text, type: self) else { return nil }
            return FATypeHelper.rawValue(rawValue: index, type: self)
        }
    }
    
    /**
     To set an icon, use i.e. `labelName.setFAIcon(FAType.FAGithub, iconSize: 35)`
     */
    func setFAIcon(icon: FAType, iconSize: CGFloat) {
        FAIcon = icon
        font = UIFont(name: font.fontName, size: iconSize)
    }
    
    func setFAColor(color: UIColor) {
        FontLoader.loadFont(FAIcon!)
        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString())
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSMakeRange(0, attributedText!.length))
        textColor = color
    }
    
    func setFAText(prefixText: String, icon: FAType?, postfixText: String, size: CGFloat?, iconSize: CGFloat? = nil) {
        text = nil
        FontLoader.loadFont(icon!)
        
        let attrText = attributedText ?? NSAttributedString()
        let startFont = attrText.length == 0 ? nil : attrText.attribute(NSAttributedStringKey.font, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attrText.length == 0 ? nil : attrText.attribute(NSAttributedStringKey.font, at: attrText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = font
        if let f = startFont , f.fontName != icon!.fontName()  {
            textFont = f
        } else if let f = endFont , f.fontName != icon!.fontName()  {
            textFont = f
        }
        let textAttribute = [NSAttributedStringKey.font : textFont!]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttribute)
        
        if let iconText = icon?.text {
            let iconFont = UIFont(name: icon!.fontName(), size: iconSize ?? size ?? font.pointSize)!
            let iconAttribute = [NSAttributedStringKey.font : iconFont]
            
            let iconString = NSAttributedString(string: iconText, attributes: iconAttribute)
            prefixTextAttribured.append(iconString)
        }
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttribute)
        prefixTextAttribured.append(postfixTextAttributed)
        
        attributedText = prefixTextAttribured
    }
}


// Original idea from https://github.com/thii/FontAwesome.swift/blob/master/FontAwesome/FontAwesome.swift
public extension UIImageView {
    
    /**
     Create UIImage from FAType
     */
    public func setFAIconWithName(icon: FAType, textColor: UIColor, orientation: UIImageOrientation = UIImageOrientation.down, backgroundColor: UIColor = UIColor.clear, size: CGSize? = nil) {
        FontLoader.loadFont(icon)
        self.image = UIImage(icon: icon, size: size ?? frame.size, orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
    }
}


public extension UITabBarItem {
    
    public func setFAIcon(icon: FAType, size: CGSize? = nil, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear, selectedTextColor: UIColor = UIColor.black, selectedBackgroundColor: UIColor = UIColor.clear) {
        FontLoader.loadFont(icon)
        let tabBarItemImageSize = size ?? CGSize(width: 30, height: 30)
        
        image = UIImage(icon: icon, size: tabBarItemImageSize, orientation: orientation, textColor: textColor, backgroundColor: backgroundColor).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        selectedImage = UIImage(icon: icon, size: tabBarItemImageSize, orientation: orientation, textColor: selectedTextColor, backgroundColor: selectedBackgroundColor).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        setTitleTextAttributes([NSAttributedStringKey.foregroundColor: textColor], for: .normal)
        setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedTextColor], for: .selected)
    }
}


public extension UISegmentedControl {
    
    public func setFAIcon(icon: FAType, forSegmentAtIndex segment: Int) {
        FontLoader.loadFont(icon)
        let font = UIFont(name: icon.fontName(), size: 23)
        assert(font != nil, FAStruct.ErrorAnnounce)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        setTitle(icon.text, forSegmentAt: segment)
    }
}


public extension UIStepper {
    
    public func setFABackgroundImage(icon: FAType, forState state: UIControlState) {
        FontLoader.loadFont(icon)
        let backgroundSize = CGSize(width: 47, height: 29)
        let image = UIImage(icon: icon, size: backgroundSize)
        setBackgroundImage(image, for: state)
    }
    
    public func setFAIncrementImage(icon: FAType, forState state: UIControlState) {
        FontLoader.loadFont(icon)
        let incrementSize = CGSize(width: 16, height: 16)
        let image = UIImage(icon: icon, size: incrementSize)
        setIncrementImage(image, for: state)
    }
    
    public func setFADecrementImage(icon: FAType, forState state: UIControlState) {
        FontLoader.loadFont(icon)
        let decrementSize = CGSize(width: 16, height: 16)
        let image = UIImage(icon: icon, size: decrementSize)
        setDecrementImage(image, for: state)
    }
}


public extension UIImage {
    
    public convenience init(icon: FAType, size: CGSize, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) {
        FontLoader.loadFont(icon)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        
        let fontAspectRatio: CGFloat = 1.28571429
        let fontSize = min(size.width / fontAspectRatio, size.height)
        let font = UIFont(name: icon.fontName(), size: fontSize)
        assert(font != nil, FAStruct.ErrorAnnounce)
        let attributes = [NSAttributedStringKey.font: font!, NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.backgroundColor: backgroundColor, NSAttributedStringKey.paragraphStyle: paragraph]
        
        let attributedString = NSAttributedString(string: icon.text!, attributes: attributes)
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) * 0.5, width: size.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        if let image = image {
            var imageOrientation = image.imageOrientation
            
            if(orientation != UIImageOrientation.down){
                imageOrientation = orientation
            }
            
            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: imageOrientation)
        } else {
            self.init()
        }
    }
    
    public convenience init(bgIcon: FAType, orientation: UIImageOrientation = UIImageOrientation.down, bgTextColor: UIColor = .black, bgBackgroundColor: UIColor = .clear, topIcon: FAType, topTextColor: UIColor = .black, bgLarge: Bool? = true, size: CGSize? = nil) {
        
        let bgSize: CGSize!
        let topSize: CGSize!
        let bgRect: CGRect!
        let topRect: CGRect!
        
        if bgLarge! {
            topSize = size ?? CGSize(width: 30, height: 30)
            bgSize = CGSize(width: 2 * topSize.width, height: 2 * topSize.height)
        } else {
            bgSize = size ?? CGSize(width: 30, height: 30)
            topSize = CGSize(width: 2 * bgSize.width, height: 2 * bgSize.height)
        }
        
        let bgImage = UIImage.init(icon: bgIcon, size: bgSize, orientation: orientation, textColor: bgTextColor)
        let topImage = UIImage.init(icon: topIcon, size: topSize, orientation: orientation, textColor: topTextColor)
        
        if bgLarge! {
            bgRect = CGRect(x: 0, y: 0, width: bgSize.width, height: bgSize.height)
            topRect = CGRect(x: topSize.width/2, y: topSize.height/2, width: topSize.width, height: topSize.height)
            UIGraphicsBeginImageContextWithOptions(bgImage.size, false, 0.0)
        } else {
            topRect = CGRect(x: 0, y: 0, width: topSize.width, height: topSize.height)
            bgRect = CGRect(x: bgSize.width/2, y: bgSize.height/2, width: bgSize.width, height: bgSize.height)
            UIGraphicsBeginImageContextWithOptions(topImage.size, false, 0.0)
            
        }
        
        bgImage.draw(in: bgRect)
        topImage.draw(in: topRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            var imageOrientation = image.imageOrientation
            
            if(orientation != UIImageOrientation.down){
                imageOrientation = orientation
            }
            
            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: imageOrientation)
        } else {
            self.init()
        }
    }
}


public extension UISlider {
    
    func setFAMaximumValueImage(icon: FAType, orientation: UIImageOrientation = UIImageOrientation.down, customSize: CGSize? = nil) {
        maximumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25,height: 25), orientation: orientation)
    }
    
    func setFAMinimumValueImage(icon: FAType, orientation: UIImageOrientation = UIImageOrientation.down, customSize: CGSize? = nil) {
        minimumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25,height: 25), orientation: orientation)
    }
}

public extension UIViewController {
    var FATitle: FAType? {
        set {
            FontLoader.loadFont(newValue!)
            let font = UIFont(name: newValue!.fontName(), size: 23)
            assert(font != nil,FAStruct.ErrorAnnounce)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: font!]
            title = newValue?.text
        }
        get {
            guard let title = title, let index = FATypeHelper.index(of: title, type: self) else { return nil }
            return FATypeHelper.rawValue(rawValue: index, type: self)
        }
    }
}

private struct FAStruct {
    
    static let ErrorAnnounce = "****** FONT AWESOME SWIFT - FontAwesome font not found in the bundle or not associated with Info.plist when manual installation was performed. ******"
}

private class FontLoader {
    class func loadFont(_ faType: FAType) {
        if(UIFont.fontNames(forFamilyName: faType.fontFamilyName()).count == 0){
            let bundle = Bundle(for: FontLoader.self)
            let identifier = bundle.bundleIdentifier
            
            var fontURL: URL
            if identifier?.hasPrefix("org.cocoapods") == true {
                // If this framework is added using CocoaPods, resources is placed under a subdirectory
                fontURL = bundle.url(forResource: faType.fontFilename(), withExtension: "otf", subdirectory: "Font-Awesome-Swift.bundle")!
            } else {
                fontURL = bundle.url(forResource: faType.fontFilename(), withExtension: "otf")!
            }
            
            guard
                let data = try? Data(contentsOf: fontURL),
                let provider = CGDataProvider(data: data as CFData),
                let font = CGFont(provider)
                else { return }
            
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
                guard let nsError = error?.takeUnretainedValue() as AnyObject as? NSError else { return }
                NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
            }
        }
    }
}

/**
 List of all icons in Font Awesome
 */

public protocol FAType {
    static var count:Int{ get }
    var text: String? {get}
    func fontName() -> String
    func fontFilename() -> String
    func fontFamilyName() -> String
}

public enum FATypeHelper:FAType {
    public var text: String? {
        return ""
    }
    
    public func fontName() -> String {
        return ""
    }
    
    public func fontFilename() -> String {
        return ""
    }
    
    public func fontFamilyName() -> String {
        return ""
    }
    
    public static var count: Int {
        return FARegularIcons.count + FABrandsIcons.count + FASolidIcons.count
    }
    
    public static func index(of title: String, type:Any) -> Int? {
        if type is FARegular.Type {
            return FARegularIcons.index(of: title)
        }
        else if type is FASolid.Type {
            return FASolidIcons.index(of: title)
        }
        else if type is FABrands.Type {
            return FABrandsIcons.index(of: title)
        }
        return nil
    }
    
    public static func rawValue(rawValue:Int, type:Any) -> FAType? {
        if type is FARegular.Type {
            let realValue = rawValue - FABrandsIcons.count;
            return FARegular.init(rawValue: realValue)
        }
        else if type is FASolid.Type {
            let realValue = rawValue - FABrandsIcons.count - FARegularIcons.count;
            return FASolid.init(rawValue: realValue)
        }
        else if type is FABrands.Type {
            return FABrands.init(rawValue: rawValue)
        }
        return nil
    }
}

public enum FARegular:Int,FAType {
    public func fontName() -> String {
        return "FontAwesome5FreeRegular"
    }
    
    public func fontFilename() -> String {
        return "Font-Awesome-5-Free-Regular-400"
    }
    
    public func fontFamilyName() -> String {
        return "Font Awesome 5 Free"
    }
    
    public static var count: Int {
        return FARegularIcons.count
    }
    
    public var text: String? {
        return FARegularIcons[rawValue]
    }
    case FARAddressBook, FARAddressCard, FARAngry, FARArrowAltCircleDown, FARArrowAltCircleLeft, FARArrowAltCircleRight, FARArrowAltCircleUp, FARBell, FARBellSlash, FARBookmark, FARBuilding, FARCalendar, FARCalendarAlt, FARCalendarCheck, FARCalendarMinus, FARCalendarPlus, FARCalendarTimes, FARCaretSquareDown, FARCaretSquareLeft, FARCaretSquareRight, FARCaretSquareUp, FARChartBar, FARCheckCircle, FARCheckSquare, FARCircle, FARClipboard, FARClock, FARClone, FARClosedCaptioning, FARComment, FARCommentAlt, FARCommentDots, FARComments, FARCompass, FARCopy, FARCopyright, FARCreditCard, FARDizzy, FARDotCircle, FAREdit, FAREnvelope, FAREnvelopeOpen, FAREye, FAREyeSlash, FARFile, FARFileAlt, FARFileArchive, FARFileAudio, FARFileCode, FARFileExcel, FARFileImage, FARFilePdf, FARFilePowerpoint, FARFileVideo, FARFileWord, FARFlag, FARFlushed, FARFolder, FARFolderOpen, FARFrown, FARFrownOpen, FARFutbol, FARGem, FARGrimace, FARGrin, FARGrinAlt, FARGrinBeam, FARGrinBeamSweat, FARGrinHearts, FARGrinSquint, FARGrinSquintTears, FARGrinStars, FARGrinTears, FARGrinTongue, FARGrinTongueSquint, FARGrinTongueWink, FARGrinWink, FARHandLizard, FARHandPaper, FARHandPeace, FARHandPointDown, FARHandPointLeft, FARHandPointRight, FARHandPointUp, FARHandPointer, FARHandRock, FARHandScissors, FARHandSpock, FARHandshake, FARHdd, FARHeart, FARHospital, FARHourglass, FARIdBadge, FARIdCard, FARImage, FARImages, FARKeyboard, FARKiss, FARKissBeam, FARKissWinkHeart, FARLaugh, FARLaughBeam, FARLaughSquint, FARLaughWink, FARLemon, FARLifeRing, FARLightbulb, FARListAlt, FARMap, FARMeh, FARMehBlank, FARMehRollingEyes, FARMinusSquare, FARMoneyBillAlt, FARMoon, FARNewspaper, FARObjectGroup, FARObjectUngroup, FARPaperPlane, FARPauseCircle, FARPlayCircle, FARPlusSquare, FARQuestionCircle, FARRegistered, FARSadCry, FARSadTear, FARSave, FARShareSquare, FARSmile, FARSmileBeam, FARSmileWink, FARSnowflake, FARSquare, FARStar, FARStarHalf, FARStickyNote, FARStopCircle, FARSun, FARSurprise, FARThumbsDown, FARThumbsUp, FARTimesCircle, FARTired, FARTrashAlt, FARUser, FARUserCircle, FARWindowClose, FARWindowMaximize, FARWindowMinimize, FARWindowRestore
}
private let FARegularIcons = ["\u{f2b9}", "\u{f2bb}", "\u{f556}", "\u{f358}", "\u{f359}", "\u{f35a}", "\u{f35b}", "\u{f0f3}", "\u{f1f6}", "\u{f02e}", "\u{f1ad}", "\u{f133}", "\u{f073}", "\u{f274}", "\u{f272}", "\u{f271}", "\u{f273}", "\u{f150}", "\u{f191}", "\u{f152}", "\u{f151}", "\u{f080}", "\u{f058}", "\u{f14a}", "\u{f111}", "\u{f328}", "\u{f017}", "\u{f24d}", "\u{f20a}", "\u{f075}", "\u{f27a}", "\u{f4ad}", "\u{f086}", "\u{f14e}", "\u{f0c5}", "\u{f1f9}", "\u{f09d}", "\u{f567}", "\u{f192}", "\u{f044}", "\u{f0e0}", "\u{f2b6}", "\u{f06e}", "\u{f070}", "\u{f15b}", "\u{f15c}", "\u{f1c6}", "\u{f1c7}", "\u{f1c9}", "\u{f1c3}", "\u{f1c5}", "\u{f1c1}", "\u{f1c4}", "\u{f1c8}", "\u{f1c2}", "\u{f024}", "\u{f579}", "\u{f07b}", "\u{f07c}", "\u{f119}", "\u{f57a}", "\u{f1e3}", "\u{f3a5}", "\u{f57f}", "\u{f580}", "\u{f581}", "\u{f582}", "\u{f583}", "\u{f584}", "\u{f585}", "\u{f586}", "\u{f587}", "\u{f588}", "\u{f589}", "\u{f58a}", "\u{f58b}", "\u{f58c}", "\u{f258}", "\u{f256}", "\u{f25b}", "\u{f0a7}", "\u{f0a5}", "\u{f0a4}", "\u{f0a6}", "\u{f25a}", "\u{f255}", "\u{f257}", "\u{f259}", "\u{f2b5}", "\u{f0a0}", "\u{f004}", "\u{f0f8}", "\u{f254}", "\u{f2c1}", "\u{f2c2}", "\u{f03e}", "\u{f302}", "\u{f11c}", "\u{f596}", "\u{f597}", "\u{f598}", "\u{f599}", "\u{f59a}", "\u{f59b}", "\u{f59c}", "\u{f094}", "\u{f1cd}", "\u{f0eb}", "\u{f022}", "\u{f279}", "\u{f11a}", "\u{f5a4}", "\u{f5a5}", "\u{f146}", "\u{f3d1}", "\u{f186}", "\u{f1ea}", "\u{f247}", "\u{f248}", "\u{f1d8}", "\u{f28b}", "\u{f144}", "\u{f0fe}", "\u{f059}", "\u{f25d}", "\u{f5b3}", "\u{f5b4}", "\u{f0c7}", "\u{f14d}", "\u{f118}", "\u{f5b8}", "\u{f4da}", "\u{f2dc}", "\u{f0c8}", "\u{f005}", "\u{f089}", "\u{f249}", "\u{f28d}", "\u{f185}", "\u{f5c2}", "\u{f165}", "\u{f164}", "\u{f057}", "\u{f5c8}", "\u{f2ed}", "\u{f007}", "\u{f2bd}", "\u{f410}", "\u{f2d0}", "\u{f2d1}", "\u{f2d2}"]

public enum FASolid:Int,FAType {
    public func fontName() -> String {
        return "FontAwesome5FreeSolid"
    }
    
    public func fontFilename() -> String {
        return "Font-Awesome-5-Free-Solid-900"
    }
    
    public func fontFamilyName() -> String {
        return "Font Awesome 5 Free"
    }
    
    public static var count: Int {
        return FASolidIcons.count
    }
    
    public var text: String? {
        return FASolidIcons[rawValue]
    }
    case FASAddressBook, FASAddressCard, FASAdjust, FASAirFreshener, FASAlignCenter, FASAlignJustify, FASAlignLeft, FASAlignRight, FASAllergies, FASAmbulance, FASAmericanSignLanguageInterpreting, FASAnchor, FASAngleDoubleDown, FASAngleDoubleLeft, FASAngleDoubleRight, FASAngleDoubleUp, FASAngleDown, FASAngleLeft, FASAngleRight, FASAngleUp, FASAngry, FASAppleAlt, FASArchive, FASArchway, FASArrowAltCircleDown, FASArrowAltCircleLeft, FASArrowAltCircleRight, FASArrowAltCircleUp, FASArrowCircleDown, FASArrowCircleLeft, FASArrowCircleRight, FASArrowCircleUp, FASArrowDown, FASArrowLeft, FASArrowRight, FASArrowUp, FASArrowsAlt, FASArrowsAltH, FASArrowsAltV, FASAssistiveListeningSystems, FASAsterisk, FASAt, FASAtlas, FASAtom, FASAudioDescription, FASAward, FASBackspace, FASBackward, FASBalanceScale, FASBan, FASBandAid, FASBarcode, FASBars, FASBaseballBall, FASBasketballBall, FASBath, FASBatteryEmpty, FASBatteryFull, FASBatteryHalf, FASBatteryQuarter, FASBatteryThreeQuarters, FASBed, FASBeer, FASBell, FASBellSlash, FASBezierCurve, FASBicycle, FASBinoculars, FASBirthdayCake, FASBlender, FASBlind, FASBold, FASBolt, FASBomb, FASBone, FASBong, FASBook, FASBookOpen, FASBookReader, FASBookmark, FASBowlingBall, FASBox, FASBoxOpen, FASBoxes, FASBraille, FASBrain, FASBriefcase, FASBriefcaseMedical, FASBroadcastTower, FASBroom, FASBrush, FASBug, FASBuilding, FASBullhorn, FASBullseye, FASBurn, FASBus, FASBusAlt, FASCalculator, FASCalendar, FASCalendarAlt, FASCalendarCheck, FASCalendarMinus, FASCalendarPlus, FASCalendarTimes, FASCamera, FASCameraRetro, FASCannabis, FASCapsules, FASCar, FASCarAlt, FASCarBattery, FASCarCrash, FASCarSide, FASCaretDown, FASCaretLeft, FASCaretRight, FASCaretSquareDown, FASCaretSquareLeft, FASCaretSquareRight, FASCaretSquareUp, FASCaretUp, FASCartArrowDown, FASCartPlus, FASCertificate, FASChalkboard, FASChalkboardTeacher, FASChargingStation, FASChartArea, FASChartBar, FASChartLine, FASChartPie, FASCheck, FASCheckCircle, FASCheckDouble, FASCheckSquare, FASChess, FASChessBishop, FASChessBoard, FASChessKing, FASChessKnight, FASChessPawn, FASChessQueen, FASChessRook, FASChevronCircleDown, FASChevronCircleLeft, FASChevronCircleRight, FASChevronCircleUp, FASChevronDown, FASChevronLeft, FASChevronRight, FASChevronUp, FASChild, FASChurch, FASCircle, FASCircleNotch, FASClipboard, FASClipboardCheck, FASClipboardList, FASClock, FASClone, FASClosedCaptioning, FASCloud, FASCloudDownloadAlt, FASCloudUploadAlt, FASCocktail, FASCode, FASCodeBranch, FASCoffee, FASCog, FASCogs, FASCoins, FASColumns, FASComment, FASCommentAlt, FASCommentDots, FASCommentSlash, FASComments, FASCompactDisc, FASCompass, FASCompress, FASConciergeBell, FASCookie, FASCookieBite, FASCopy, FASCopyright, FASCouch, FASCreditCard, FASCrop, FASCropAlt, FASCrosshairs, FASCrow, FASCrown, FASCube, FASCubes, FASCut, FASDatabase, FASDeaf, FASDesktop, FASDiagnoses, FASDice, FASDiceFive, FASDiceFour, FASDiceOne, FASDiceSix, FASDiceThree, FASDiceTwo, FASDigitalTachograph, FASDirections, FASDivide, FASDizzy, FASDna, FASDollarSign, FASDolly, FASDollyFlatbed, FASDonate, FASDoorClosed, FASDoorOpen, FASDotCircle, FASDove, FASDownload, FASDraftingCompass, FASDrawPolygon, FASDrum, FASDrumSteelpan, FASDumbbell, FASEdit, FASEject, FASEllipsisH, FASEllipsisV, FASEnvelope, FASEnvelopeOpen, FASEnvelopeSquare, FASEquals, FASEraser, FASEuroSign, FASExchangeAlt, FASExclamation, FASExclamationCircle, FASExclamationTriangle, FASExpand, FASExpandArrowsAlt, FASExternalLinkAlt, FASExternalLinkSquareAlt, FASEye, FASEyeDropper, FASEyeSlash, FASFastBackward, FASFastForward, FASFax, FASFeather, FASFeatherAlt, FASFemale, FASFighterJet, FASFile, FASFileAlt, FASFileArchive, FASFileAudio, FASFileCode, FASFileContract, FASFileDownload, FASFileExcel, FASFileExport, FASFileImage, FASFileImport, FASFileInvoice, FASFileInvoiceDollar, FASFileMedical, FASFileMedicalAlt, FASFilePdf, FASFilePowerpoint, FASFilePrescription, FASFileSignature, FASFileUpload, FASFileVideo, FASFileWord, FASFill, FASFillDrip, FASFilm, FASFilter, FASFingerprint, FASFire, FASFireExtinguisher, FASFirstAid, FASFish, FASFlag, FASFlagCheckered, FASFlask, FASFlushed, FASFolder, FASFolderOpen, FASFont, FASFootballBall, FASForward, FASFrog, FASFrown, FASFrownOpen, FASFutbol, FASGamepad, FASGasPump, FASGavel, FASGem, FASGenderless, FASGift, FASGlassMartini, FASGlassMartiniAlt, FASGlasses, FASGlobe, FASGlobeAfrica, FASGlobeAmericas, FASGlobeAsia, FASGolfBall, FASGraduationCap, FASGreaterThan, FASGreaterThanEqual, FASGrimace, FASGrin, FASGrinAlt, FASGrinBeam, FASGrinBeamSweat, FASGrinHearts, FASGrinSquint, FASGrinSquintTears, FASGrinStars, FASGrinTears, FASGrinTongue, FASGrinTongueSquint, FASGrinTongueWink, FASGrinWink, FASGripHorizontal, FASGripVertical, FASHSquare, FASHandHolding, FASHandHoldingHeart, FASHandHoldingUsd, FASHandLizard, FASHandPaper, FASHandPeace, FASHandPointDown, FASHandPointLeft, FASHandPointRight, FASHandPointUp, FASHandPointer, FASHandRock, FASHandScissors, FASHandSpock, FASHands, FASHandsHelping, FASHandshake, FASHashtag, FASHdd, FASHeading, FASHeadphones, FASHeadphonesAlt, FASHeadset, FASHeart, FASHeartbeat, FASHelicopter, FASHighlighter, FASHistory, FASHockeyPuck, FASHome, FASHospital, FASHospitalAlt, FASHospitalSymbol, FASHotTub, FASHotel, FASHourglass, FASHourglassEnd, FASHourglassHalf, FASHourglassStart, FASICursor, FASIdBadge, FASIdCard, FASIdCardAlt, FASImage, FASImages, FASInbox, FASIndent, FASIndustry, FASInfinity, FASInfo, FASInfoCircle, FASItalic, FASJoint, FASKey, FASKeyboard, FASKiss, FASKissBeam, FASKissWinkHeart, FASKiwiBird, FASLanguage, FASLaptop, FASLaptopCode, FASLaugh, FASLaughBeam, FASLaughSquint, FASLaughWink, FASLayerGroup, FASLeaf, FASLemon, FASLessThan, FASLessThanEqual, FASLevelDownAlt, FASLevelUpAlt, FASLifeRing, FASLightbulb, FASLink, FASLiraSign, FASList, FASListAlt, FASListOl, FASListUl, FASLocationArrow, FASLock, FASLockOpen, FASLongArrowAltDown, FASLongArrowAltLeft, FASLongArrowAltRight, FASLongArrowAltUp, FASLowVision, FASLuggageCart, FASMagic, FASMagnet, FASMale, FASMap, FASMapMarked, FASMapMarkedAlt, FASMapMarker, FASMapMarkerAlt, FASMapPin, FASMapSigns, FASMarker, FASMars, FASMarsDouble, FASMarsStroke, FASMarsStrokeH, FASMarsStrokeV, FASMedal, FASMedkit, FASMeh, FASMehBlank, FASMehRollingEyes, FASMemory, FASMercury, FASMicrochip, FASMicrophone, FASMicrophoneAlt, FASMicrophoneAltSlash, FASMicrophoneSlash, FASMicroscope, FASMinus, FASMinusCircle, FASMinusSquare, FASMobile, FASMobileAlt, FASMoneyBill, FASMoneyBillAlt, FASMoneyBillWave, FASMoneyBillWaveAlt, FASMoneyCheck, FASMoneyCheckAlt, FASMonument, FASMoon, FASMortarPestle, FASMotorcycle, FASMousePointer, FASMusic, FASNeuter, FASNewspaper, FASNotEqual, FASNotesMedical, FASObjectGroup, FASObjectUngroup, FASOilCan, FASOutdent, FASPaintBrush, FASPaintRoller, FASPalette, FASPallet, FASPaperPlane, FASPaperclip, FASParachuteBox, FASParagraph, FASParking, FASPassport, FASPaste, FASPause, FASPauseCircle, FASPaw, FASPen, FASPenAlt, FASPenFancy, FASPenNib, FASPenSquare, FASPencilAlt, FASPencilRuler, FASPeopleCarry, FASPercent, FASPercentage, FASPhone, FASPhoneSlash, FASPhoneSquare, FASPhoneVolume, FASPiggyBank, FASPills, FASPlane, FASPlaneArrival, FASPlaneDeparture, FASPlay, FASPlayCircle, FASPlug, FASPlus, FASPlusCircle, FASPlusSquare, FASPodcast, FASPoo, FASPoop, FASPortrait, FASPoundSign, FASPowerOff, FASPrescription, FASPrescriptionBottle, FASPrescriptionBottleAlt, FASPrint, FASProcedures, FASProjectDiagram, FASPuzzlePiece, FASQrcode, FASQuestion, FASQuestionCircle, FASQuidditch, FASQuoteLeft, FASQuoteRight, FASRandom, FASReceipt, FASRecycle, FASRedo, FASRedoAlt, FASRegistered, FASReply, FASReplyAll, FASRetweet, FASRibbon, FASRoad, FASRobot, FASRocket, FASRoute, FASRss, FASRssSquare, FASRubleSign, FASRuler, FASRulerCombined, FASRulerHorizontal, FASRulerVertical, FASRupeeSign, FASSadCry, FASSadTear, FASSave, FASSchool, FASScrewdriver, FASSearch, FASSearchMinus, FASSearchPlus, FASSeedling, FASServer, FASShapes, FASShare, FASShareAlt, FASShareAltSquare, FASShareSquare, FASShekelSign, FASShieldAlt, FASShip, FASShippingFast, FASShoePrints, FASShoppingBag, FASShoppingBasket, FASShoppingCart, FASShower, FASShuttleVan, FASSign, FASSignInAlt, FASSignLanguage, FASSignOutAlt, FASSignal, FASSignature, FASSitemap, FASSkull, FASSlidersH, FASSmile, FASSmileBeam, FASSmileWink, FASSmoking, FASSmokingBan, FASSnowflake, FASSolarPanel, FASSort, FASSortAlphaDown, FASSortAlphaUp, FASSortAmountDown, FASSortAmountUp, FASSortDown, FASSortNumericDown, FASSortNumericUp, FASSortUp, FASSpa, FASSpaceShuttle, FASSpinner, FASSplotch, FASSprayCan, FASSquare, FASSquareFull, FASStamp, FASStar, FASStarHalf, FASStarHalfAlt, FASStarOfLife, FASStepBackward, FASStepForward, FASStethoscope, FASStickyNote, FASStop, FASStopCircle, FASStopwatch, FASStore, FASStoreAlt, FASStream, FASStreetView, FASStrikethrough, FASStroopwafel, FASSubscript, FASSubway, FASSuitcase, FASSuitcaseRolling, FASSun, FASSuperscript, FASSurprise, FASSwatchbook, FASSwimmer, FASSwimmingPool, FASSync, FASSyncAlt, FASSyringe, FASTable, FASTableTennis, FASTablet, FASTabletAlt, FASTablets, FASTachometerAlt, FASTag, FASTags, FASTape, FASTasks, FASTaxi, FASTeeth, FASTeethOpen, FASTerminal, FASTextHeight, FASTextWidth, FASTh, FASThLarge, FASThList, FASTheaterMasks, FASThermometer, FASThermometerEmpty, FASThermometerFull, FASThermometerHalf, FASThermometerQuarter, FASThermometerThreeQuarters, FASThumbsDown, FASThumbsUp, FASThumbtack, FASTicketAlt, FASTimes, FASTimesCircle, FASTint, FASTintSlash, FASTired, FASToggleOff, FASToggleOn, FASToolbox, FASTooth, FASTrademark, FASTrafficLight, FASTrain, FASTransgender, FASTransgenderAlt, FASTrash, FASTrashAlt, FASTree, FASTrophy, FASTruck, FASTruckLoading, FASTruckMonster, FASTruckMoving, FASTruckPickup, FASTshirt, FASTty, FASTv, FASUmbrella, FASUmbrellaBeach, FASUnderline, FASUndo, FASUndoAlt, FASUniversalAccess, FASUniversity, FASUnlink, FASUnlock, FASUnlockAlt, FASUpload, FASUser, FASUserAlt, FASUserAltSlash, FASUserAstronaut, FASUserCheck, FASUserCircle, FASUserClock, FASUserCog, FASUserEdit, FASUserFriends, FASUserGraduate, FASUserLock, FASUserMd, FASUserMinus, FASUserNinja, FASUserPlus, FASUserSecret, FASUserShield, FASUserSlash, FASUserTag, FASUserTie, FASUserTimes, FASUsers, FASUsersCog, FASUtensilSpoon, FASUtensils, FASVectorSquare, FASVenus, FASVenusDouble, FASVenusMars, FASVial, FASVials, FASVideo, FASVideoSlash, FASVolleyballBall, FASVolumeDown, FASVolumeOff, FASVolumeUp, FASWalking, FASWallet, FASWarehouse, FASWeight, FASWeightHanging, FASWheelchair, FASWifi, FASWindowClose, FASWindowMaximize, FASWindowMinimize, FASWindowRestore, FASWineGlass, FASWineGlassAlt, FASWonSign, FASWrench, FASXRay, FASYenSign
}
private let FASolidIcons = ["\u{f2b9}", "\u{f2bb}", "\u{f042}", "\u{f5d0}", "\u{f037}", "\u{f039}", "\u{f036}", "\u{f038}", "\u{f461}", "\u{f0f9}", "\u{f2a3}", "\u{f13d}", "\u{f103}", "\u{f100}", "\u{f101}", "\u{f102}", "\u{f107}", "\u{f104}", "\u{f105}", "\u{f106}", "\u{f556}", "\u{f5d1}", "\u{f187}", "\u{f557}", "\u{f358}", "\u{f359}", "\u{f35a}", "\u{f35b}", "\u{f0ab}", "\u{f0a8}", "\u{f0a9}", "\u{f0aa}", "\u{f063}", "\u{f060}", "\u{f061}", "\u{f062}", "\u{f0b2}", "\u{f337}", "\u{f338}", "\u{f2a2}", "\u{f069}", "\u{f1fa}", "\u{f558}", "\u{f5d2}", "\u{f29e}", "\u{f559}", "\u{f55a}", "\u{f04a}", "\u{f24e}", "\u{f05e}", "\u{f462}", "\u{f02a}", "\u{f0c9}", "\u{f433}", "\u{f434}", "\u{f2cd}", "\u{f244}", "\u{f240}", "\u{f242}", "\u{f243}", "\u{f241}", "\u{f236}", "\u{f0fc}", "\u{f0f3}", "\u{f1f6}", "\u{f55b}", "\u{f206}", "\u{f1e5}", "\u{f1fd}", "\u{f517}", "\u{f29d}", "\u{f032}", "\u{f0e7}", "\u{f1e2}", "\u{f5d7}", "\u{f55c}", "\u{f02d}", "\u{f518}", "\u{f5da}", "\u{f02e}", "\u{f436}", "\u{f466}", "\u{f49e}", "\u{f468}", "\u{f2a1}", "\u{f5dc}", "\u{f0b1}", "\u{f469}", "\u{f519}", "\u{f51a}", "\u{f55d}", "\u{f188}", "\u{f1ad}", "\u{f0a1}", "\u{f140}", "\u{f46a}", "\u{f207}", "\u{f55e}", "\u{f1ec}", "\u{f133}", "\u{f073}", "\u{f274}", "\u{f272}", "\u{f271}", "\u{f273}", "\u{f030}", "\u{f083}", "\u{f55f}", "\u{f46b}", "\u{f1b9}", "\u{f5de}", "\u{f5df}", "\u{f5e1}", "\u{f5e4}", "\u{f0d7}", "\u{f0d9}", "\u{f0da}", "\u{f150}", "\u{f191}", "\u{f152}", "\u{f151}", "\u{f0d8}", "\u{f218}", "\u{f217}", "\u{f0a3}", "\u{f51b}", "\u{f51c}", "\u{f5e7}", "\u{f1fe}", "\u{f080}", "\u{f201}", "\u{f200}", "\u{f00c}", "\u{f058}", "\u{f560}", "\u{f14a}", "\u{f439}", "\u{f43a}", "\u{f43c}", "\u{f43f}", "\u{f441}", "\u{f443}", "\u{f445}", "\u{f447}", "\u{f13a}", "\u{f137}", "\u{f138}", "\u{f139}", "\u{f078}", "\u{f053}", "\u{f054}", "\u{f077}", "\u{f1ae}", "\u{f51d}", "\u{f111}", "\u{f1ce}", "\u{f328}", "\u{f46c}", "\u{f46d}", "\u{f017}", "\u{f24d}", "\u{f20a}", "\u{f0c2}", "\u{f381}", "\u{f382}", "\u{f561}", "\u{f121}", "\u{f126}", "\u{f0f4}", "\u{f013}", "\u{f085}", "\u{f51e}", "\u{f0db}", "\u{f075}", "\u{f27a}", "\u{f4ad}", "\u{f4b3}", "\u{f086}", "\u{f51f}", "\u{f14e}", "\u{f066}", "\u{f562}", "\u{f563}", "\u{f564}", "\u{f0c5}", "\u{f1f9}", "\u{f4b8}", "\u{f09d}", "\u{f125}", "\u{f565}", "\u{f05b}", "\u{f520}", "\u{f521}", "\u{f1b2}", "\u{f1b3}", "\u{f0c4}", "\u{f1c0}", "\u{f2a4}", "\u{f108}", "\u{f470}", "\u{f522}", "\u{f523}", "\u{f524}", "\u{f525}", "\u{f526}", "\u{f527}", "\u{f528}", "\u{f566}", "\u{f5eb}", "\u{f529}", "\u{f567}", "\u{f471}", "\u{f155}", "\u{f472}", "\u{f474}", "\u{f4b9}", "\u{f52a}", "\u{f52b}", "\u{f192}", "\u{f4ba}", "\u{f019}", "\u{f568}", "\u{f5ee}", "\u{f569}", "\u{f56a}", "\u{f44b}", "\u{f044}", "\u{f052}", "\u{f141}", "\u{f142}", "\u{f0e0}", "\u{f2b6}", "\u{f199}", "\u{f52c}", "\u{f12d}", "\u{f153}", "\u{f362}", "\u{f12a}", "\u{f06a}", "\u{f071}", "\u{f065}", "\u{f31e}", "\u{f35d}", "\u{f360}", "\u{f06e}", "\u{f1fb}", "\u{f070}", "\u{f049}", "\u{f050}", "\u{f1ac}", "\u{f52d}", "\u{f56b}", "\u{f182}", "\u{f0fb}", "\u{f15b}", "\u{f15c}", "\u{f1c6}", "\u{f1c7}", "\u{f1c9}", "\u{f56c}", "\u{f56d}", "\u{f1c3}", "\u{f56e}", "\u{f1c5}", "\u{f56f}", "\u{f570}", "\u{f571}", "\u{f477}", "\u{f478}", "\u{f1c1}", "\u{f1c4}", "\u{f572}", "\u{f573}", "\u{f574}", "\u{f1c8}", "\u{f1c2}", "\u{f575}", "\u{f576}", "\u{f008}", "\u{f0b0}", "\u{f577}", "\u{f06d}", "\u{f134}", "\u{f479}", "\u{f578}", "\u{f024}", "\u{f11e}", "\u{f0c3}", "\u{f579}", "\u{f07b}", "\u{f07c}", "\u{f031}", "\u{f44e}", "\u{f04e}", "\u{f52e}", "\u{f119}", "\u{f57a}", "\u{f1e3}", "\u{f11b}", "\u{f52f}", "\u{f0e3}", "\u{f3a5}", "\u{f22d}", "\u{f06b}", "\u{f000}", "\u{f57b}", "\u{f530}", "\u{f0ac}", "\u{f57c}", "\u{f57d}", "\u{f57e}", "\u{f450}", "\u{f19d}", "\u{f531}", "\u{f532}", "\u{f57f}", "\u{f580}", "\u{f581}", "\u{f582}", "\u{f583}", "\u{f584}", "\u{f585}", "\u{f586}", "\u{f587}", "\u{f588}", "\u{f589}", "\u{f58a}", "\u{f58b}", "\u{f58c}", "\u{f58d}", "\u{f58e}", "\u{f0fd}", "\u{f4bd}", "\u{f4be}", "\u{f4c0}", "\u{f258}", "\u{f256}", "\u{f25b}", "\u{f0a7}", "\u{f0a5}", "\u{f0a4}", "\u{f0a6}", "\u{f25a}", "\u{f255}", "\u{f257}", "\u{f259}", "\u{f4c2}", "\u{f4c4}", "\u{f2b5}", "\u{f292}", "\u{f0a0}", "\u{f1dc}", "\u{f025}", "\u{f58f}", "\u{f590}", "\u{f004}", "\u{f21e}", "\u{f533}", "\u{f591}", "\u{f1da}", "\u{f453}", "\u{f015}", "\u{f0f8}", "\u{f47d}", "\u{f47e}", "\u{f593}", "\u{f594}", "\u{f254}", "\u{f253}", "\u{f252}", "\u{f251}", "\u{f246}", "\u{f2c1}", "\u{f2c2}", "\u{f47f}", "\u{f03e}", "\u{f302}", "\u{f01c}", "\u{f03c}", "\u{f275}", "\u{f534}", "\u{f129}", "\u{f05a}", "\u{f033}", "\u{f595}", "\u{f084}", "\u{f11c}", "\u{f596}", "\u{f597}", "\u{f598}", "\u{f535}", "\u{f1ab}", "\u{f109}", "\u{f5fc}", "\u{f599}", "\u{f59a}", "\u{f59b}", "\u{f59c}", "\u{f5fd}", "\u{f06c}", "\u{f094}", "\u{f536}", "\u{f537}", "\u{f3be}", "\u{f3bf}", "\u{f1cd}", "\u{f0eb}", "\u{f0c1}", "\u{f195}", "\u{f03a}", "\u{f022}", "\u{f0cb}", "\u{f0ca}", "\u{f124}", "\u{f023}", "\u{f3c1}", "\u{f309}", "\u{f30a}", "\u{f30b}", "\u{f30c}", "\u{f2a8}", "\u{f59d}", "\u{f0d0}", "\u{f076}", "\u{f183}", "\u{f279}", "\u{f59f}", "\u{f5a0}", "\u{f041}", "\u{f3c5}", "\u{f276}", "\u{f277}", "\u{f5a1}", "\u{f222}", "\u{f227}", "\u{f229}", "\u{f22b}", "\u{f22a}", "\u{f5a2}", "\u{f0fa}", "\u{f11a}", "\u{f5a4}", "\u{f5a5}", "\u{f538}", "\u{f223}", "\u{f2db}", "\u{f130}", "\u{f3c9}", "\u{f539}", "\u{f131}", "\u{f610}", "\u{f068}", "\u{f056}", "\u{f146}", "\u{f10b}", "\u{f3cd}", "\u{f0d6}", "\u{f3d1}", "\u{f53a}", "\u{f53b}", "\u{f53c}", "\u{f53d}", "\u{f5a6}", "\u{f186}", "\u{f5a7}", "\u{f21c}", "\u{f245}", "\u{f001}", "\u{f22c}", "\u{f1ea}", "\u{f53e}", "\u{f481}", "\u{f247}", "\u{f248}", "\u{f613}", "\u{f03b}", "\u{f1fc}", "\u{f5aa}", "\u{f53f}", "\u{f482}", "\u{f1d8}", "\u{f0c6}", "\u{f4cd}", "\u{f1dd}", "\u{f540}", "\u{f5ab}", "\u{f0ea}", "\u{f04c}", "\u{f28b}", "\u{f1b0}", "\u{f304}", "\u{f305}", "\u{f5ac}", "\u{f5ad}", "\u{f14b}", "\u{f303}", "\u{f5ae}", "\u{f4ce}", "\u{f295}", "\u{f541}", "\u{f095}", "\u{f3dd}", "\u{f098}", "\u{f2a0}", "\u{f4d3}", "\u{f484}", "\u{f072}", "\u{f5af}", "\u{f5b0}", "\u{f04b}", "\u{f144}", "\u{f1e6}", "\u{f067}", "\u{f055}", "\u{f0fe}", "\u{f2ce}", "\u{f2fe}", "\u{f619}", "\u{f3e0}", "\u{f154}", "\u{f011}", "\u{f5b1}", "\u{f485}", "\u{f486}", "\u{f02f}", "\u{f487}", "\u{f542}", "\u{f12e}", "\u{f029}", "\u{f128}", "\u{f059}", "\u{f458}", "\u{f10d}", "\u{f10e}", "\u{f074}", "\u{f543}", "\u{f1b8}", "\u{f01e}", "\u{f2f9}", "\u{f25d}", "\u{f3e5}", "\u{f122}", "\u{f079}", "\u{f4d6}", "\u{f018}", "\u{f544}", "\u{f135}", "\u{f4d7}", "\u{f09e}", "\u{f143}", "\u{f158}", "\u{f545}", "\u{f546}", "\u{f547}", "\u{f548}", "\u{f156}", "\u{f5b3}", "\u{f5b4}", "\u{f0c7}", "\u{f549}", "\u{f54a}", "\u{f002}", "\u{f010}", "\u{f00e}", "\u{f4d8}", "\u{f233}", "\u{f61f}", "\u{f064}", "\u{f1e0}", "\u{f1e1}", "\u{f14d}", "\u{f20b}", "\u{f3ed}", "\u{f21a}", "\u{f48b}", "\u{f54b}", "\u{f290}", "\u{f291}", "\u{f07a}", "\u{f2cc}", "\u{f5b6}", "\u{f4d9}", "\u{f2f6}", "\u{f2a7}", "\u{f2f5}", "\u{f012}", "\u{f5b7}", "\u{f0e8}", "\u{f54c}", "\u{f1de}", "\u{f118}", "\u{f5b8}", "\u{f4da}", "\u{f48d}", "\u{f54d}", "\u{f2dc}", "\u{f5ba}", "\u{f0dc}", "\u{f15d}", "\u{f15e}", "\u{f160}", "\u{f161}", "\u{f0dd}", "\u{f162}", "\u{f163}", "\u{f0de}", "\u{f5bb}", "\u{f197}", "\u{f110}", "\u{f5bc}", "\u{f5bd}", "\u{f0c8}", "\u{f45c}", "\u{f5bf}", "\u{f005}", "\u{f089}", "\u{f5c0}", "\u{f621}", "\u{f048}", "\u{f051}", "\u{f0f1}", "\u{f249}", "\u{f04d}", "\u{f28d}", "\u{f2f2}", "\u{f54e}", "\u{f54f}", "\u{f550}", "\u{f21d}", "\u{f0cc}", "\u{f551}", "\u{f12c}", "\u{f239}", "\u{f0f2}", "\u{f5c1}", "\u{f185}", "\u{f12b}", "\u{f5c2}", "\u{f5c3}", "\u{f5c4}", "\u{f5c5}", "\u{f021}", "\u{f2f1}", "\u{f48e}", "\u{f0ce}", "\u{f45d}", "\u{f10a}", "\u{f3fa}", "\u{f490}", "\u{f3fd}", "\u{f02b}", "\u{f02c}", "\u{f4db}", "\u{f0ae}", "\u{f1ba}", "\u{f62e}", "\u{f62f}", "\u{f120}", "\u{f034}", "\u{f035}", "\u{f00a}", "\u{f009}", "\u{f00b}", "\u{f630}", "\u{f491}", "\u{f2cb}", "\u{f2c7}", "\u{f2c9}", "\u{f2ca}", "\u{f2c8}", "\u{f165}", "\u{f164}", "\u{f08d}", "\u{f3ff}", "\u{f00d}", "\u{f057}", "\u{f043}", "\u{f5c7}", "\u{f5c8}", "\u{f204}", "\u{f205}", "\u{f552}", "\u{f5c9}", "\u{f25c}", "\u{f637}", "\u{f238}", "\u{f224}", "\u{f225}", "\u{f1f8}", "\u{f2ed}", "\u{f1bb}", "\u{f091}", "\u{f0d1}", "\u{f4de}", "\u{f63b}", "\u{f4df}", "\u{f63c}", "\u{f553}", "\u{f1e4}", "\u{f26c}", "\u{f0e9}", "\u{f5ca}", "\u{f0cd}", "\u{f0e2}", "\u{f2ea}", "\u{f29a}", "\u{f19c}", "\u{f127}", "\u{f09c}", "\u{f13e}", "\u{f093}", "\u{f007}", "\u{f406}", "\u{f4fa}", "\u{f4fb}", "\u{f4fc}", "\u{f2bd}", "\u{f4fd}", "\u{f4fe}", "\u{f4ff}", "\u{f500}", "\u{f501}", "\u{f502}", "\u{f0f0}", "\u{f503}", "\u{f504}", "\u{f234}", "\u{f21b}", "\u{f505}", "\u{f506}", "\u{f507}", "\u{f508}", "\u{f235}", "\u{f0c0}", "\u{f509}", "\u{f2e5}", "\u{f2e7}", "\u{f5cb}", "\u{f221}", "\u{f226}", "\u{f228}", "\u{f492}", "\u{f493}", "\u{f03d}", "\u{f4e2}", "\u{f45f}", "\u{f027}", "\u{f026}", "\u{f028}", "\u{f554}", "\u{f555}", "\u{f494}", "\u{f496}", "\u{f5cd}", "\u{f193}", "\u{f1eb}", "\u{f410}", "\u{f2d0}", "\u{f2d1}", "\u{f2d2}", "\u{f4e3}", "\u{f5ce}", "\u{f159}", "\u{f0ad}", "\u{f497}", "\u{f157}"]

public enum FABrands:Int,FAType {
    public func fontName() -> String {
        return "FontAwesome5BrandsRegular"
    }
    
    public func fontFilename() -> String {
        return "Font-Awesome-5-Brands-Regular-400"
    }
    
    public func fontFamilyName() -> String {
        return "Font Awesome 5 Brands"
    }
    
    public static var count: Int {
        return FABrandsIcons.count
    }
    
    public var text: String? {
        return FABrandsIcons[rawValue]
    }
    case FAB500px, FABAccessibleIcon, FABAccusoft, FABAdn, FABAdversal, FABAffiliatetheme, FABAlgolia, FABAmazon, FABAmazonPay, FABAmilia, FABAndroid, FABAngellist, FABAngrycreative, FABAngular, FABAppStore, FABAppStoreIos, FABApper, FABApple, FABApplePay, FABAsymmetrik, FABAudible, FABAutoprefixer, FABAvianex, FABAviato, FABAws, FABBandcamp, FABBehance, FABBehanceSquare, FABBimobject, FABBitbucket, FABBitcoin, FABBity, FABBlackTie, FABBlackberry, FABBlogger, FABBloggerB, FABBluetooth, FABBluetoothB, FABBtc, FABBuromobelexperte, FABBuysellads, FABCcAmazonPay, FABCcAmex, FABCcApplePay, FABCcDinersClub, FABCcDiscover, FABCcJcb, FABCcMastercard, FABCcPaypal, FABCcStripe, FABCcVisa, FABCentercode, FABChrome, FABCloudscale, FABCloudsmith, FABCloudversify, FABCodepen, FABCodiepie, FABConnectdevelop, FABContao, FABCpanel, FABCreativeCommons, FABCreativeCommonsBy, FABCreativeCommonsNc, FABCreativeCommonsNcEu, FABCreativeCommonsNcJp, FABCreativeCommonsNd, FABCreativeCommonsPd, FABCreativeCommonsPdAlt, FABCreativeCommonsRemix, FABCreativeCommonsSa, FABCreativeCommonsSampling, FABCreativeCommonsSamplingPlus, FABCreativeCommonsShare, FABCss3, FABCss3Alt, FABCuttlefish, FABDAndD, FABDashcube, FABDelicious, FABDeploydog, FABDeskpro, FABDeviantart, FABDigg, FABDigitalOcean, FABDiscord, FABDiscourse, FABDochub, FABDocker, FABDraft2digital, FABDribbble, FABDribbbleSquare, FABDropbox, FABDrupal, FABDyalog, FABEarlybirds, FABEbay, FABEdge, FABElementor, FABEllo, FABEmber, FABEmpire, FABEnvira, FABErlang, FABEthereum, FABEtsy, FABExpeditedssl, FABFacebook, FABFacebookF, FABFacebookMessenger, FABFacebookSquare, FABFirefox, FABFirstOrder, FABFirstOrderAlt, FABFirstdraft, FABFlickr, FABFlipboard, FABFly, FABFontAwesome, FABFontAwesomeAlt, FABFontAwesomeFlag, FABFonticons, FABFonticonsFi, FABFortAwesome, FABFortAwesomeAlt, FABForumbee, FABFoursquare, FABFreeCodeCamp, FABFreebsd, FABFulcrum, FABGalacticRepublic, FABGalacticSenate, FABGetPocket, FABGg, FABGgCircle, FABGit, FABGitSquare, FABGithub, FABGithubAlt, FABGithubSquare, FABGitkraken, FABGitlab, FABGitter, FABGlide, FABGlideG, FABGofore, FABGoodreads, FABGoodreadsG, FABGoogle, FABGoogleDrive, FABGooglePlay, FABGooglePlus, FABGooglePlusG, FABGooglePlusSquare, FABGoogleWallet, FABGratipay, FABGrav, FABGripfire, FABGrunt, FABGulp, FABHackerNews, FABHackerNewsSquare, FABHackerrank, FABHips, FABHireAHelper, FABHooli, FABHornbill, FABHotjar, FABHouzz, FABHtml5, FABHubspot, FABImdb, FABInstagram, FABInternetExplorer, FABIoxhost, FABItunes, FABItunesNote, FABJava, FABJediOrder, FABJenkins, FABJoget, FABJoomla, FABJs, FABJsSquare, FABJsfiddle, FABKaggle, FABKeybase, FABKeycdn, FABKickstarter, FABKickstarterK, FABKorvue, FABLaravel, FABLastfm, FABLastfmSquare, FABLeanpub, FABLess, FABLine, FABLinkedin, FABLinkedinIn, FABLinode, FABLinux, FABLyft, FABMagento, FABMailchimp, FABMandalorian, FABMarkdown, FABMastodon, FABMaxcdn, FABMedapps, FABMedium, FABMediumM, FABMedrt, FABMeetup, FABMegaport, FABMicrosoft, FABMix, FABMixcloud, FABMizuni, FABModx, FABMonero, FABNapster, FABNeos, FABNimblr, FABNintendoSwitch, FABNode, FABNodeJs, FABNpm, FABNs8, FABNutritionix, FABOdnoklassniki, FABOdnoklassnikiSquare, FABOldRepublic, FABOpencart, FABOpenid, FABOpera, FABOptinMonster, FABOsi, FABPage4, FABPagelines, FABPalfed, FABPatreon, FABPaypal, FABPeriscope, FABPhabricator, FABPhoenixFramework, FABPhoenixSquadron, FABPhp, FABPiedPiper, FABPiedPiperAlt, FABPiedPiperHat, FABPiedPiperPp, FABPinterest, FABPinterestP, FABPinterestSquare, FABPlaystation, FABProductHunt, FABPushed, FABPython, FABQq, FABQuinscape, FABQuora, FABRProject, FABRavelry, FABReact, FABReadme, FABRebel, FABRedRiver, FABReddit, FABRedditAlien, FABRedditSquare, FABRendact, FABRenren, FABReplyd, FABResearchgate, FABResolving, FABRev, FABRocketchat, FABRockrms, FABSafari, FABSass, FABSchlix, FABScribd, FABSearchengin, FABSellcast, FABSellsy, FABServicestack, FABShirtsinbulk, FABShopware, FABSimplybuilt, FABSistrix, FABSith, FABSkyatlas, FABSkype, FABSlack, FABSlackHash, FABSlideshare, FABSnapchat, FABSnapchatGhost, FABSnapchatSquare, FABSoundcloud, FABSpeakap, FABSpotify, FABSquarespace, FABStackExchange, FABStackOverflow, FABStaylinked, FABSteam, FABSteamSquare, FABSteamSymbol, FABStickerMule, FABStrava, FABStripe, FABStripeS, FABStudiovinari, FABStumbleupon, FABStumbleuponCircle, FABSuperpowers, FABSupple, FABTeamspeak, FABTelegram, FABTelegramPlane, FABTencentWeibo, FABThemeco, FABThemeisle, FABTradeFederation, FABTrello, FABTripadvisor, FABTumblr, FABTumblrSquare, FABTwitch, FABTwitter, FABTwitterSquare, FABTypo3, FABUber, FABUikit, FABUniregistry, FABUntappd, FABUsb, FABUssunnah, FABVaadin, FABViacoin, FABViadeo, FABViadeoSquare, FABViber, FABVimeo, FABVimeoSquare, FABVimeoV, FABVine, FABVk, FABVnv, FABVuejs, FABWeebly, FABWeibo, FABWeixin, FABWhatsapp, FABWhatsappSquare, FABWhmcs, FABWikipediaW, FABWindows, FABWix, FABWolfPackBattalion, FABWordpress, FABWordpressSimple, FABWpbeginner, FABWpexplorer, FABWpforms, FABXbox, FABXing, FABXingSquare, FABYCombinator, FABYahoo, FABYandex, FABYandexInternational, FABYelp, FABYoast, FABYoutube, FABYoutubeSquare, FABZhihu
}
private let FABrandsIcons = ["\u{f26e}", "\u{f368}", "\u{f369}", "\u{f170}", "\u{f36a}", "\u{f36b}", "\u{f36c}", "\u{f270}", "\u{f42c}", "\u{f36d}", "\u{f17b}", "\u{f209}", "\u{f36e}", "\u{f420}", "\u{f36f}", "\u{f370}", "\u{f371}", "\u{f179}", "\u{f415}", "\u{f372}", "\u{f373}", "\u{f41c}", "\u{f374}", "\u{f421}", "\u{f375}", "\u{f2d5}", "\u{f1b4}", "\u{f1b5}", "\u{f378}", "\u{f171}", "\u{f379}", "\u{f37a}", "\u{f27e}", "\u{f37b}", "\u{f37c}", "\u{f37d}", "\u{f293}", "\u{f294}", "\u{f15a}", "\u{f37f}", "\u{f20d}", "\u{f42d}", "\u{f1f3}", "\u{f416}", "\u{f24c}", "\u{f1f2}", "\u{f24b}", "\u{f1f1}", "\u{f1f4}", "\u{f1f5}", "\u{f1f0}", "\u{f380}", "\u{f268}", "\u{f383}", "\u{f384}", "\u{f385}", "\u{f1cb}", "\u{f284}", "\u{f20e}", "\u{f26d}", "\u{f388}", "\u{f25e}", "\u{f4e7}", "\u{f4e8}", "\u{f4e9}", "\u{f4ea}", "\u{f4eb}", "\u{f4ec}", "\u{f4ed}", "\u{f4ee}", "\u{f4ef}", "\u{f4f0}", "\u{f4f1}", "\u{f4f2}", "\u{f13c}", "\u{f38b}", "\u{f38c}", "\u{f38d}", "\u{f210}", "\u{f1a5}", "\u{f38e}", "\u{f38f}", "\u{f1bd}", "\u{f1a6}", "\u{f391}", "\u{f392}", "\u{f393}", "\u{f394}", "\u{f395}", "\u{f396}", "\u{f17d}", "\u{f397}", "\u{f16b}", "\u{f1a9}", "\u{f399}", "\u{f39a}", "\u{f4f4}", "\u{f282}", "\u{f430}", "\u{f5f1}", "\u{f423}", "\u{f1d1}", "\u{f299}", "\u{f39d}", "\u{f42e}", "\u{f2d7}", "\u{f23e}", "\u{f09a}", "\u{f39e}", "\u{f39f}", "\u{f082}", "\u{f269}", "\u{f2b0}", "\u{f50a}", "\u{f3a1}", "\u{f16e}", "\u{f44d}", "\u{f417}", "\u{f2b4}", "\u{f35c}", "\u{f425}", "\u{f280}", "\u{f3a2}", "\u{f286}", "\u{f3a3}", "\u{f211}", "\u{f180}", "\u{f2c5}", "\u{f3a4}", "\u{f50b}", "\u{f50c}", "\u{f50d}", "\u{f265}", "\u{f260}", "\u{f261}", "\u{f1d3}", "\u{f1d2}", "\u{f09b}", "\u{f113}", "\u{f092}", "\u{f3a6}", "\u{f296}", "\u{f426}", "\u{f2a5}", "\u{f2a6}", "\u{f3a7}", "\u{f3a8}", "\u{f3a9}", "\u{f1a0}", "\u{f3aa}", "\u{f3ab}", "\u{f2b3}", "\u{f0d5}", "\u{f0d4}", "\u{f1ee}", "\u{f184}", "\u{f2d6}", "\u{f3ac}", "\u{f3ad}", "\u{f3ae}", "\u{f1d4}", "\u{f3af}", "\u{f5f7}", "\u{f452}", "\u{f3b0}", "\u{f427}", "\u{f592}", "\u{f3b1}", "\u{f27c}", "\u{f13b}", "\u{f3b2}", "\u{f2d8}", "\u{f16d}", "\u{f26b}", "\u{f208}", "\u{f3b4}", "\u{f3b5}", "\u{f4e4}", "\u{f50e}", "\u{f3b6}", "\u{f3b7}", "\u{f1aa}", "\u{f3b8}", "\u{f3b9}", "\u{f1cc}", "\u{f5fa}", "\u{f4f5}", "\u{f3ba}", "\u{f3bb}", "\u{f3bc}", "\u{f42f}", "\u{f3bd}", "\u{f202}", "\u{f203}", "\u{f212}", "\u{f41d}", "\u{f3c0}", "\u{f08c}", "\u{f0e1}", "\u{f2b8}", "\u{f17c}", "\u{f3c3}", "\u{f3c4}", "\u{f59e}", "\u{f50f}", "\u{f60f}", "\u{f4f6}", "\u{f136}", "\u{f3c6}", "\u{f23a}", "\u{f3c7}", "\u{f3c8}", "\u{f2e0}", "\u{f5a3}", "\u{f3ca}", "\u{f3cb}", "\u{f289}", "\u{f3cc}", "\u{f285}", "\u{f3d0}", "\u{f3d2}", "\u{f612}", "\u{f5a8}", "\u{f418}", "\u{f419}", "\u{f3d3}", "\u{f3d4}", "\u{f3d5}", "\u{f3d6}", "\u{f263}", "\u{f264}", "\u{f510}", "\u{f23d}", "\u{f19b}", "\u{f26a}", "\u{f23c}", "\u{f41a}", "\u{f3d7}", "\u{f18c}", "\u{f3d8}", "\u{f3d9}", "\u{f1ed}", "\u{f3da}", "\u{f3db}", "\u{f3dc}", "\u{f511}", "\u{f457}", "\u{f2ae}", "\u{f1a8}", "\u{f4e5}", "\u{f1a7}", "\u{f0d2}", "\u{f231}", "\u{f0d3}", "\u{f3df}", "\u{f288}", "\u{f3e1}", "\u{f3e2}", "\u{f1d6}", "\u{f459}", "\u{f2c4}", "\u{f4f7}", "\u{f2d9}", "\u{f41b}", "\u{f4d5}", "\u{f1d0}", "\u{f3e3}", "\u{f1a1}", "\u{f281}", "\u{f1a2}", "\u{f3e4}", "\u{f18b}", "\u{f3e6}", "\u{f4f8}", "\u{f3e7}", "\u{f5b2}", "\u{f3e8}", "\u{f3e9}", "\u{f267}", "\u{f41e}", "\u{f3ea}", "\u{f28a}", "\u{f3eb}", "\u{f2da}", "\u{f213}", "\u{f3ec}", "\u{f214}", "\u{f5b5}", "\u{f215}", "\u{f3ee}", "\u{f512}", "\u{f216}", "\u{f17e}", "\u{f198}", "\u{f3ef}", "\u{f1e7}", "\u{f2ab}", "\u{f2ac}", "\u{f2ad}", "\u{f1be}", "\u{f3f3}", "\u{f1bc}", "\u{f5be}", "\u{f18d}", "\u{f16c}", "\u{f3f5}", "\u{f1b6}", "\u{f1b7}", "\u{f3f6}", "\u{f3f7}", "\u{f428}", "\u{f429}", "\u{f42a}", "\u{f3f8}", "\u{f1a4}", "\u{f1a3}", "\u{f2dd}", "\u{f3f9}", "\u{f4f9}", "\u{f2c6}", "\u{f3fe}", "\u{f1d5}", "\u{f5c6}", "\u{f2b2}", "\u{f513}", "\u{f181}", "\u{f262}", "\u{f173}", "\u{f174}", "\u{f1e8}", "\u{f099}", "\u{f081}", "\u{f42b}", "\u{f402}", "\u{f403}", "\u{f404}", "\u{f405}", "\u{f287}", "\u{f407}", "\u{f408}", "\u{f237}", "\u{f2a9}", "\u{f2aa}", "\u{f409}", "\u{f40a}", "\u{f194}", "\u{f27d}", "\u{f1ca}", "\u{f189}", "\u{f40b}", "\u{f41f}", "\u{f5cc}", "\u{f18a}", "\u{f1d7}", "\u{f232}", "\u{f40c}", "\u{f40d}", "\u{f266}", "\u{f17a}", "\u{f5cf}", "\u{f514}", "\u{f19a}", "\u{f411}", "\u{f297}", "\u{f2de}", "\u{f298}", "\u{f412}", "\u{f168}", "\u{f169}", "\u{f23b}", "\u{f19e}", "\u{f413}", "\u{f414}", "\u{f1e9}", "\u{f2b1}", "\u{f167}", "\u{f431}", "\u{f63f}"]
