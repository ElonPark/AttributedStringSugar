//
//  Operator.swift
//  AttributedStringSugar
//
//  Created by Elon on 2020/03/17.
//

import UIKit

public func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(attributedString: lhs)
    attributedString.append(rhs)
    return attributedString
}

public func + (lhs: String, rhs: NSAttributedString) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: lhs)
    attributedString.append(rhs)
    return attributedString
}

public func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(attributedString: lhs)
    attributedString.append(NSAttributedString(string: rhs))
    return attributedString
}
