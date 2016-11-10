//
//  AutoCompleteTextFieldProtocols.swift
//  Pods
//
//  Created by Neil Francis Hipona on 16/07/2016.
//  Copyright (c) 2016 Neil Francis Ramirez Hipona. All rights reserved.
//

import Foundation
import UIKit


// MARK: - AutoCompleteTextField Protocol

public protocol AutoCompleteTextFieldDataSource: NSObjectProtocol {
    
    // Required protocols
    
    func autoCompleteTextFieldDataSource(autoCompleteTextField: AutoCompleteTextField) -> [String] // called when in need of suggestions.
}

@objc public protocol AutoCompleteTextFieldDelegate: UITextFieldDelegate {
    
    // Optional protocols
    
    // return NO to disallow editing. Defaults to YES.
    optional func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    
    // became first responder
    optional func textFieldDidBeginEditing(textField: UITextField)
    
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end. Defaults to YES.
    optional func textFieldShouldEndEditing(textField: UITextField) -> Bool
    
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    optional func textFieldDidEndEditing(textField: UITextField)
    
    // return NO to not change text. Defaults to YES.
    optional func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    
    // called when clear button pressed. return NO to ignore (no notifications)
    optional func textFieldShouldClear(textField: UITextField) -> Bool
    
    // called when 'return' key pressed. return NO to ignore.
    optional func textFieldShouldReturn(textField: UITextField) -> Bool
    
}

// MARK: - UITextFieldDelegate

extension AutoCompleteTextField: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        guard let delegate = autoCompleteTextFieldDelegate, delegateCall = delegate.textFieldShouldBeginEditing else { return true }
        
        return delegateCall(self)
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        guard let delegate = autoCompleteTextFieldDelegate, delegateCall = delegate.textFieldDidBeginEditing else { return }
        
        delegateCall(self)
    }
    
    public func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        guard let delegate = autoCompleteTextFieldDelegate, delegateCall = delegate.textFieldShouldEndEditing else { return true }
        
        return delegateCall(self)
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        guard let delegate = autoCompleteTextFieldDelegate, delegateCall = delegate.textFieldDidEndEditing else { return }
        
        delegateCall(self)
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let delegate = autoCompleteTextFieldDelegate, delegateCall = delegate.textField(_:shouldChangeCharactersInRange:replacementString:) else { return true }
        
        return delegateCall(textField, shouldChangeCharactersInRange: range, replacementString: string)
    }
    
    public func textFieldShouldClear(textField: UITextField) -> Bool {
        guard let delegate = autoCompleteTextFieldDelegate, delegateCall = delegate.textFieldShouldClear else { return true }
        
        return delegateCall(self)
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let delegate = autoCompleteTextFieldDelegate, delegateCall = delegate.textFieldShouldReturn else { return endEditing(true) }
        
        return delegateCall(self)
    }
}