//
//  ASCalenderDateCollectionViewCell.swift
//  ASCalender
//
//  Created by Ankit on 15/12/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import UIKit

class ASCalenderDateCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet weak var viewSelected: UIView!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(date: Date, currentDate: Date){
        let cal = Calendar.current
        let components = (cal as NSCalendar).components([.day], from: date)
        let day = components.day!
        self.lblDate.text = "\(String(describing: day))"
        if (date.isBetweenDates(beginDate: currentDate.startOfMonth(), endDate: currentDate.endOfMonth())){
            self.lblDate.textColor =  UIColor.white
        }else{
            self.lblDate.textColor =  UIColor.gray
        }
    }
}
