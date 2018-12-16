//
//  ASCalenderView.swift
//  ASCalender
//
//  Created by Ankit on 15/12/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate: class {
        func seletctedDate(_ value : Date?)
}

class ASCalenderView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var lblCurrentDate: UILabel!
    @IBOutlet weak var btnPreviousMonth: UIButton!
    @IBOutlet weak var btnNextMonth: UIButton!
    @IBOutlet weak var collectionViewCalender: UICollectionView!
    
    private var arrDates = [[Date]]()                                            /// arrDates in the Date for showing on collection view
    private var currentMonthDate = Date()                                 /// Set the latest month on calendar
    var selectedDate : Date?
    private var weeks = 0                                                             /// Need to add the weeks count as for collection section
 
    weak var delegate: CalendarViewDelegate?
    
    
    private lazy var dateFormatter: DateFormatter = {                           /// Date formater as to set proper format from Date()
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        return formatter
    }()
    
    lazy var appDateFormatter: DateFormatter = {                           /// Date formater as to set proper format used in App
        let formatter  = DateFormatter()
        formatter.dateFormat = appDateFormat
        formatter.timeZone = .current
        return formatter
    }()
    
    @IBInspectable open var appDateFormat: String = "EEE, MMM dd" {
        didSet {
            setCalendar(fromDate: currentMonthDate)
        }
    }
    
    // MARK: Methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    func loadView()  {
        Bundle.main.loadNibNamed("ASCalenderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = UIColor.darkGray
        contentView.translatesAutoresizingMaskIntoConstraints = true
        collectionViewCalender.register(ASCalenderDateCollectionViewCell.nib, forCellWithReuseIdentifier: ASCalenderDateCollectionViewCell.identifier)
        collectionViewCalender.delegate = self
        collectionViewCalender.dataSource = self
        self.setCalendar(fromDate:Date())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionViewCalender.reloadData()
    }
    
    
    @IBAction func btnNextMonthDidClicked(_ sender: Any) {
        if let sampleDate = Calendar.current.date(byAdding: .month, value: 1, to: currentMonthDate){
            currentMonthDate = sampleDate
            self.setCalendar(fromDate:sampleDate)
        }
        
    }
    @IBAction func btnPreviousMonthDidClicked(_ sender: Any) {
        if let sampleDate = Calendar.current.date(byAdding: .month, value: -1, to: currentMonthDate){
            currentMonthDate = sampleDate
            self.setCalendar(fromDate:sampleDate)
        }
    }
    
    func setCalendar(fromDate: Date) {
        let cal = Calendar.current
        let components = (cal as NSCalendar).components([.month, .day, .weekday, .year], from: fromDate)
        let year =  components.year
        let month = components.month
        let months = dateFormatter.monthSymbols
        let monthSymbol = (months![month!-1])
        _ = (cal as NSCalendar).range(of: .weekOfMonth, in: .month, for: fromDate)
        let dateRange = (cal as NSCalendar).range(of: .day, in: .month, for: fromDate)
        let numWeeks = weeksInMonth(month: month!, year: year!)
        weeks = numWeeks!
        _ = dateRange.length
        let totalMonthList = weeks * 7
        var dates = [Date]()
        var firstDate = dateFormatter.date(from: "\(year!)-\(month!)-1")!
        let componentsFromFirstDate = (cal as NSCalendar).components([.month, .day, .weekday, .year], from: firstDate)
        firstDate = (cal as NSCalendar).date(byAdding: [.day], value: -(componentsFromFirstDate.weekday!-1), to: firstDate, options: [])!
        for _ in 1 ... totalMonthList {
            if firstDate.isToday() {
                if selectedDate == nil {
                    selectedDate = firstDate
                }
            }
            dates.append(firstDate)
            firstDate = (cal as NSCalendar).date(byAdding: [.day], value: +1, to: firstDate, options: [])!
        }
        let maxCol = 7
        let maxRow = weeks
        arrDates.removeAll(keepingCapacity: false)
        var index = 0
        for _ in 0..<maxRow {
            var colItems = [Date]()
            for _ in 0..<maxCol {
                colItems.append(dates[index])
                index += 1
            }
            arrDates.append(colItems)
        }
        
        DispatchQueue.main.async {
            self.lblCurrentDate.text = "\(monthSymbol) \(year!)"
            self.lblSelectedDate.text = self.appDateFormatter.string(from:  self.selectedDate!)
        }
        self.collectionViewCalender.reloadData()
    }
    
    func weeksInMonth(month: Int, year: Int) -> (Int)? {
        let calendar = NSCalendar.current
        let comps = NSDateComponents()
        comps.month = month+1
        comps.year = year
        comps.day = 0
        guard let last = calendar.date(from: comps as DateComponents) else {
            return nil
        }
        // Note: Could get other options as well
        let gettag = calendar.dateComponents([.weekOfMonth, .weekOfYear,
                                              .yearForWeekOfYear, .weekday, .quarter], from: last)
        return gettag.weekOfMonth
    }

}

extension ASCalenderView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = arrDates[indexPath.section][indexPath.row]
        if (date.isBetweenDates(beginDate: currentMonthDate.startOfMonth(), endDate: currentMonthDate.endOfMonth())){
            selectedDate = arrDates[indexPath.section][indexPath.row]
            self.lblSelectedDate.text = self.appDateFormatter.string(from:  self.selectedDate!)
            collectionView.reloadData()
        }
        
    }
}

extension ASCalenderView : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return weeks //for number of weeks
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7 //for number of days in week
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ASCalenderDateCollectionViewCell.identifier, for: indexPath) as! ASCalenderDateCollectionViewCell
        cell.configureCell(date: arrDates[indexPath.section][indexPath.row], currentDate: currentMonthDate)
        let date = arrDates[indexPath.section][indexPath.row]
        
        switch date.compare(selectedDate!) {
        case .orderedAscending:
            cell.viewSelected.backgroundColor = UIColor.clear
        case .orderedSame:
            cell.viewSelected.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.3254901961, blue: 0.3764705882, alpha: 1)
        case .orderedDescending:
            cell.viewSelected.backgroundColor = UIColor.clear
        }
        
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width / 7.0, height: (collectionView.bounds.size.height/CGFloat(weeks)))
    }
    
}
