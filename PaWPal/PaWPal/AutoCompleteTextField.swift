//
//  AutoCompleteTextField.swift
//  Pods
//
//  Created by Neil Francis Hipona on 19/03/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
//

import Foundation
import UIKit


public class AutoCompleteTextField: UITextField {
    
    /// AutoCompleteTextField data source
    public weak var autoCompleteTextFieldDataSource: AutoCompleteTextFieldDataSource?
    
    // AutoCompleteTextField data source accessible through IB
    @IBOutlet weak internal var dataSource: AnyObject! {
        didSet {
            autoCompleteTextFieldDataSource = dataSource as? AutoCompleteTextFieldDataSource
        }
    }
    
    /// AutoCompleteTextField delegate
    public weak var autoCompleteTextFieldDelegate: AutoCompleteTextFieldDelegate!
    
    // AutoCompleteTextField delegate accessible through IB
    weak public override var delegate: UITextFieldDelegate? {
        set (x) { autoCompleteTextFieldDelegate = x as? AutoCompleteTextFieldDelegate }
        get { return autoCompleteTextFieldDelegate }
    }
    
    private var autoCompleteLbl: UILabel!
    private var delimiter: NSCharacterSet?
    
    private var xOffsetCorrection: CGFloat {
        get {
            switch borderStyle {
            case .Bezel, .RoundedRect:
                return 6.0
            case .Line:
                return 1.0
                
            default:
                return 0.0
            }
        }
    }
    
    private var yOffsetCorrection: CGFloat {
        get {
            switch borderStyle {
            case .Line, .RoundedRect:
                return 0.5
                
            default:
                return 0.0
            }
        }
    }
    
    /// Auto completion flag
    public var autoCompleteDisabled: Bool = false
    
    /// Case search
    public var ignoreCase: Bool = true
    
    /// Randomize suggestion flag. Default to ``false, will always use first found suggestion
    public var isRandomSuggestion: Bool = false
    
    /// Supported domain names
    static public let domainNames: [String] = {
        return SupportedDomainNames
    }()
    
    /// Text font settings
    override public var font: UIFont? {
        didSet { autoCompleteLbl.font = font }
    }
    
    override public var textColor: UIColor? {
        didSet {
            autoCompleteLbl.textColor = textColor?.colorWithAlphaComponent(0.5)
        }
    }
    
    // MARK: - Initialization
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareAutoCompleteTextFieldLayers()
        setupTargetObserver()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareAutoCompleteTextFieldLayers()
        setupTargetObserver()
    }
    
    /// Initialize `AutoCompleteTextField` with `AutoCompleteTextFieldDataSource` and optional `AutoCompleteTextFieldDelegate`
    convenience public init(frame: CGRect, autoCompleteTextFieldDataSource dataSource: AutoCompleteTextFieldDataSource, autoCompleteTextFieldDelegate delegate: AutoCompleteTextFieldDelegate! = nil) {
        self.init(frame: frame)
        
        autoCompleteTextFieldDataSource = dataSource
        autoCompleteTextFieldDelegate = delegate
        
        prepareAutoCompleteTextFieldLayers()
        setupTargetObserver()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        prepareAutoCompleteTextFieldLayers()
        setupTargetObserver()
    }
    
    
    // MARK: - R
    override public func becomeFirstResponder() -> Bool {
        let becomeFirstResponder = super.becomeFirstResponder()
        
        if !autoCompleteDisabled {
            autoCompleteLbl.hidden = false
            
            if clearsOnBeginEditing {
                autoCompleteLbl.text = ""
            }
            
            processAutoCompleteEvent()
        }
        
        return becomeFirstResponder
    }
    
    override public func resignFirstResponder() -> Bool {
        let resignFirstResponder = super.resignFirstResponder()
        
        if !autoCompleteDisabled {
            autoCompleteLbl.hidden = true
            
            processAutoCompleteEvent()
            commitAutocompleteText()
        }
        
        return resignFirstResponder
    }
    
    
    // MARK: - Private Funtions
    private func prepareAutoCompleteTextFieldLayers() {
        
        autoCompleteLbl = UILabel(frame: .zero)
        addSubview(autoCompleteLbl)
        
        autoCompleteLbl.font = font
        autoCompleteLbl.backgroundColor = .clearColor()
        autoCompleteLbl.textColor = .lightGrayColor()
        autoCompleteLbl.lineBreakMode = .ByClipping
        autoCompleteLbl.baselineAdjustment = .AlignCenters
        autoCompleteLbl.hidden = true
        
    }
    
    private func setupTargetObserver() {
        
        removeTarget(self, action: #selector(AutoCompleteTextField.autoCompleteTextFieldDidChanged(_:)), forControlEvents: .EditingChanged)
        addTarget(self, action: #selector(AutoCompleteTextField.autoCompleteTextFieldDidChanged(_:)), forControlEvents: .EditingChanged)
        
        super.delegate = self
    }
    
    private func performStringSuggestionsSearch(textToLookFor: String) -> String {
        
        // handle nil data source
        guard let autoCompleteTextFieldDataSource = autoCompleteTextFieldDataSource else { return processDataSource(SupportedDomainNames, textToLookFor: textToLookFor) }
        
        let dataSource = autoCompleteTextFieldDataSource.autoCompleteTextFieldDataSource(self)
        
        return processDataSource(dataSource, textToLookFor: textToLookFor)
    }
    
    private func processDataSource(dataSource: [String], textToLookFor: String) -> String {
        
        let stringFilter = ignoreCase ? textToLookFor.lowercaseString : textToLookFor
        let suggestedStrings: [String] = dataSource.filter { (suggestedString) -> Bool in
            if ignoreCase {
                return suggestedString.lowercaseString.hasPrefix(stringFilter)
            }else{
                return suggestedString.hasPrefix(stringFilter)
            }
        }
        
        if suggestedStrings.isEmpty {
            return ""
        }

        if isRandomSuggestion {
            let maxSuggestionCount = suggestedStrings.count
            let randomIdx = arc4random_uniform(UInt32(maxSuggestionCount))
            let suggestedString = suggestedStrings[Int(randomIdx)]
            
            return performStringReplacement(suggestedString, stringFilter: stringFilter)
        }else{

            let suggestedString = suggestedStrings.sort({ (elementOne, elementTwo) -> Bool in
                return elementOne.characters.count < elementTwo.characters.count
            }).first ?? ""
            return performStringReplacement(suggestedString, stringFilter: stringFilter)
        }
    }
    
    private func performStringReplacement(suggestedString: String, stringFilter: String) -> String {
        guard let filterRange = ignoreCase ? suggestedString.lowercaseString.rangeOfString(stringFilter) : suggestedString.rangeOfString(stringFilter) else { return "" }
        
        let finalString = suggestedString.stringByReplacingCharactersInRange(filterRange, withString: "")
        return finalString
    }
    
    private func autocompleteBoundingRect(autocompleteString: String) -> CGRect {
        
        // get bounds for whole text area
        let textRectBounds = textRectForBounds(bounds)
        
        // get rect for actual text
        guard let textRange = textRangeFromPosition(beginningOfDocument, toPosition: endOfDocument) else { return .zero }
        
        let textRect = firstRectForRange(textRange).integral
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByCharWrapping
        
        let textAttributes: [String: AnyObject] = [NSFontAttributeName: font!, NSParagraphStyleAttributeName: paragraphStyle]
        
        let drawingOptions: NSStringDrawingOptions = [.UsesLineFragmentOrigin, .UsesFontLeading]
        
        let prefixTextRect = (text ?? "" as NSString).boundingRectWithSize(textRectBounds.size, options: drawingOptions, attributes: textAttributes, context: nil)
        
        let autoCompleteRectSize = CGSize(width: textRectBounds.width - prefixTextRect.width, height: textRectBounds.height)
        let autocompleteTextRect = (autocompleteString as NSString).boundingRectWithSize(autoCompleteRectSize, options: drawingOptions, attributes: textAttributes, context: nil)
        
        let xOrigin = textRect.maxX + xOffsetCorrection
        let autoCompleteLblFrame = autoCompleteLbl.frame
        let finalX = xOrigin + autocompleteTextRect.width
        let finalY = textRectBounds.minY + ((textRectBounds.height - autoCompleteLblFrame.height) / 2) - yOffsetCorrection
        
        if finalX >= textRectBounds.width {
            let autoCompleteRect = CGRect(x: textRectBounds.width, y: finalY, width: 0, height: autoCompleteLblFrame.height)
            
            return autoCompleteRect
            
        }else{
            let autoCompleteRect = CGRect(x: xOrigin, y: finalY, width: autocompleteTextRect.width, height: autoCompleteLblFrame.height)
            
            return autoCompleteRect
        }
    }
    
    private func processAutoCompleteEvent() {
        if autoCompleteDisabled {
            return
        }
        
        guard let textString = text else { return }
        
        if let delimiter = delimiter {
            guard let _ = textString.rangeOfCharacterFromSet(delimiter) else { return }
            
            let textComponents = textString.componentsSeparatedByCharactersInSet(delimiter)
            
            if textComponents.count > 2 { return }
            
            guard let textToLookFor = textComponents.last else { return }
            
            let autocompleteString = performStringSuggestionsSearch(textToLookFor)
            updateAutocompleteLabel(autocompleteString)
        }else{
            let autocompleteString = performStringSuggestionsSearch(textString)
            updateAutocompleteLabel(autocompleteString)
        }
    }
    
    private func updateAutocompleteLabel(autocompleteString: String) {
        autoCompleteLbl.text = autocompleteString
        autoCompleteLbl.sizeToFit()
        autoCompleteLbl.frame = autocompleteBoundingRect(autocompleteString)
    }
    
    private func commitAutocompleteText() {
        guard let autocompleteString = autoCompleteLbl.text where !autocompleteString.isEmpty else { return }
        let originalInputString = text ?? ""
        
        autoCompleteLbl.text = ""
        text = originalInputString + autocompleteString
    }
    
    // MARK: - Internal Controls
    
    internal func autoCompleteButtonDidTapped(sender: UIButton) {
        endEditing(true)
        
        processAutoCompleteEvent()
        commitAutocompleteText()
    }
    
    internal func autoCompleteTextFieldDidChanged(textField: UITextField) {
        
        processAutoCompleteEvent()
    }
    
    
    // MARK: - Public Controls
    
    /// Set delimiter. Will perform search if delimiter is found
    public func setDelimiter(delimiterString: String) {
        delimiter = NSCharacterSet(charactersInString: delimiterString)
    }
    
    /// Show completion button with custom image
    public func showAutoCompleteButton(buttonImage: UIImage? = UIImage(named: "checked", inBundle: NSBundle(forClass: AutoCompleteTextField.self), compatibleWithTraitCollection: nil), autoCompleteButtonViewMode: AutoCompleteButtonViewMode) {
        
        var buttonFrameH: CGFloat = 0.0
        var buttonOriginY: CGFloat = 0.0
        
        if frame.height > defaultAutoCompleteButtonHeight {
            buttonFrameH = defaultAutoCompleteButtonHeight
            buttonOriginY = (frame.height - defaultAutoCompleteButtonHeight) / 2
        }else{
            buttonFrameH = frame.height
            buttonOriginY = 0
        }
        
        let autoCompleteButton = UIButton(frame: CGRect(x: 0, y: buttonOriginY, width: defaultAutoCompleteButtonWidth, height: buttonFrameH))
        autoCompleteButton.setImage(buttonImage, forState: .Normal)
        autoCompleteButton.addTarget(self, action: #selector(AutoCompleteTextField.autoCompleteButtonDidTapped(_:)), forControlEvents: .TouchUpInside)
        
        let containerFrame = CGRect(x: 0, y: 0, width: defaultAutoCompleteButtonWidth, height: frame.height)
        let autoCompleteButtonContainerView = UIView(frame: containerFrame)
        autoCompleteButtonContainerView.addSubview(autoCompleteButton)
        
        rightView = autoCompleteButtonContainerView
        rightViewMode = autoCompleteButtonViewMode
    }
    
    /// Force text completion event
    public func forceRefreshAutocompleteText() {
        
        processAutoCompleteEvent()
    }
    
}