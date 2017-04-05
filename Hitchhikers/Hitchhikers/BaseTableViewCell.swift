//
//  BaseTableViewCell.swift
//  Hitchhikers
//
//  Created by Aneel Yelamanchili on 4/5/17.
//  Copyright © 2017 William Z Wang. All rights reserved.
//

import UIKit

open class BaseTableViewCell : UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
        print("hello setup")
    }
    
    open class func height() -> CGFloat {
        return 48
    }
    
    open func setData(_ data: Any?) {
        //self.backgroundColor = UIColor(red:0.96, green:0.98, blue:0.93, alpha:1.00)
        //self.backgroundColor = UIColor(red:0.19, green:0.27, blue:0.31, alpha:1.0)
        self.textLabel?.textColor = UIColor(red:0.19, green:0.27, blue:0.31, alpha:1.0)
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        //self.textLabel?.textColor = UIColor(red:0.68, green:0.68, blue:0.68, alpha:1.00)
        if let menuText = data as? String {
            self.textLabel?.text = menuText
        }
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }
    
    // ignore the default handling
    override open func setSelected(_ selected: Bool, animated: Bool) {
    }
    
}

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.characters.count
    }
}
