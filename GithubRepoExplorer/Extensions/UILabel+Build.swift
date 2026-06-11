//
//  UILabel+Build.swift
//  GitHubRepoExplorer
//
//  Created by Dionicio Cruz Velázquez on 3/16/26.
//

import UIKit

extension UILabel {
    static func build(size: CGFloat, weight: UIFont.Weight = .regular, color: UIColor = .label, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension NSAttributedString {
    static func paragraphStyle(text: String, lineHeight: CGFloat, hyphenation: Float = 0.5) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        paragraphStyle.hyphenationFactor = hyphenation
        paragraphStyle.lineBreakStrategy = .pushOut
        
        return NSAttributedString(string: text, attributes: [.paragraphStyle: paragraphStyle])
    }
}
