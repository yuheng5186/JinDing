//
//  DateSelectView.swift
//  DateCalendar
//
//  Created by 祁志远 on 2017/8/22.
//  Copyright © 2017年 祁志远. All rights reserved.
//

import UIKit

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWith = UIScreen.main.bounds.size.width

let kHeightRation = kScreenHeight / 670.0
let kWidthRation = kScreenWith / 375.0

private let kDateSelectViewCelldentifier = "DateSelectViewCell"

//,_ selectDate:Date
typealias KDateSelectViewButtonBlock = (_ button :UIButton,  _ dateStr: String, _ timeStr: String) ->()

enum DateSelectViewType: Int {
    /* 选择日期 */
    case dates = 0
    /* 选择时间 */
    case time
}


enum DateSelectEnableDateType: Int {
    /* 选择所有日期 */
    case  none = 0
    /* 选择当前时间之前 */
    case before
    /* 选择当前时间之后 */
    case after

    
}


class DateSelectView: UIView{
    
    var containerView: UIView! //
    var mainContainerView: UIView! //

    var lastYearBtutton: UIButton! //上年按钮
    var lastMonthBtutton: UIButton! //上月按钮
    var calenderLabel: UILabel! //显示当天事件
    var nextMonthButton: UIButton! //下月按钮
    var nextYearButton: UIButton! //下月按钮

    var collection: UICollectionView! //显示日历所有事件
    var tableView: UITableView! //显示日历所有事件
    var bottomView: UIView! //


    let calenderIdentifier = "CalenderCell"
    let dateIdentifier = "dateCell"
    
    var dateTimeTodayArr: [String] = [String]() { //今天的时间数组
        didSet {
            if self.dateTimeTodayArr.count > 0 {
                self.timeStr = dateTimeTodayArr[0]
                selectTimeButton.setTitle(dateTimeTodayArr[0], for: .normal)
            } else {
                selectTimeButton.setTitle("无可选时间", for: .normal)
            }

        }
    }
    var dateTimeTomorrowArr: [String]? //其他日期的时间数组

    
    var dateArray: [String] = ["日", "一", "二", "三", "四", "五", "六"]
    
    var isSelectMonth: Bool = false  //判断是否选择日期


    var date: Date = Date() //当前时间
    let month = DateHelper.month(date: Date()) //当前月
    let year = DateHelper.year(date: Date()) //当前年
    
    var selectIndex = 42
    var selectMonth = 13
    var selectYear = 0
    //创建运营时间
    var operatingTimeString: String? {
        didSet {
            operatingTimeLbel.text = "仓库运营时间：\(operatingTimeString!)"
        }
    }
    
    //日期字符串
    var selectDatesStr: String = ""
    var timeStr: String = ""
    
    var enableDate: Date = Date()
    
    
    
    
    var operatingTimeView: UIView! //选择营业时间View
    var operatingTimeLbel: UILabel!
    var selectTimeButton: DateSelectButton!
    
    var completeButton: UIButton!
    
    var  dateSelectViewType: DateSelectViewType = .time {
        didSet {
            
            switch dateSelectViewType {
            case .dates:
                self.operatingTimeView.frame = CGRect(x: 0, y: collection.frame.maxY, width: kScreenWith, height: 0)
                self.operatingTimeView.isHidden = true


            case .time:
                self.operatingTimeView.frame = CGRect(x: 0, y: collection.frame.maxY, width: kScreenWith, height: 90)
                self.operatingTimeView.isHidden = false

            }
            self.completeButton.frame = CGRect(x: 0, y: operatingTimeView.frame.maxY + 20, width: kScreenWith * 0.5, height: 38)
            completeButton.centerX = kScreenWith * 0.5
            
            self.mainContainerView.frame = CGRect(x: 0, y: 0, width: kScreenWith, height: completeButton.frame.maxY + 20)
            self.bottomView.frame = CGRect(x: 0, y: mainContainerView.frame.maxY, width: kScreenWith, height: kScreenHeight - mainContainerView.frame.maxY)
        }
    }
    
    //启用之前的时间或之后的时间
    var dateSelectEnableDateType:DateSelectEnableDateType = .none {
        didSet {
            switch dateSelectEnableDateType {
            case .none:
                printLog("所有")
            case .before:
                printLog("之前")
            case .after:
                printLog("之后")
            }
        }
    }
    
    
    
    var confirmBtnBlock: KDateSelectViewButtonBlock!
    

    
    /// 显示日期选择器
    ///
    /// - Parameters:
    ///   - dateSelectViewType: 日期类型： .dates 不显示时间 time 显示时间
    ///   - dateSelectEnableDateType: 时间禁用选择：.none 所有事件都可以选择 .before 对应日期之前的都可以点击 .after 对应日期之后的可以点击
    ///   - enableDateStr: 传入的对应选择时间（此状态必须选择dateSelectEnableDateType 为.before 或 .after）
    ///   - confirmBtnBlock: 成功回调
    class func show(dateSelectViewType: DateSelectViewType = .time,dateSelectEnableDateType:DateSelectEnableDateType = .none,enableDateStr: String = DateHelper.dateConvertString(date: Date()),confirmBtnBlock: @escaping (_ button :UIButton,  _ dateStr: String, _ timeStr: String) ->()){
        let dateSelectView = DateSelectView()
        dateSelectView.frame = UIScreen.main.bounds
        dateSelectView.dateSelectViewType = dateSelectViewType
        dateSelectView.dateSelectEnableDateType = dateSelectEnableDateType
        dateSelectView.enableDate = DateHelper.strConverDate(dateStr: enableDateStr)
        dateSelectView.confirmBtnBlock = confirmBtnBlock
        dateSelectView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        let window = UIApplication.shared.keyWindow
        window?.addSubview(dateSelectView)
    }
    
    /// 时间选择
    ///
    /// - Parameters:
    ///   - enableDateStr: 禁用日期 yyyy-MM-dd 之后
    ///   - dateTimeArrToday: 今天日期数组
    ///   - dateTimeTomorrowArr: 明天日期数组
    ///   - confirmBtnBlock: 回调
    class func showDateAndTime(enableDateStr: String = DateHelper.dateConvertString(date: Date()),dateTimeArrToday: [String], dateTimeTomorrowArr: [String], operatingTimeString: String, confirmBtnBlock: @escaping (_ button :UIButton,  _ dateStr: String, _ timeStr: String) ->()){
        let dateSelectView = DateSelectView()
        dateSelectView.frame = UIScreen.main.bounds
        dateSelectView.dateSelectViewType = .time
        dateSelectView.dateSelectEnableDateType = .after
        dateSelectView.enableDate = DateHelper.strConverDate(dateStr: enableDateStr)
        dateSelectView.dateTimeTodayArr = dateTimeArrToday
        dateSelectView.dateTimeTomorrowArr = dateTimeTomorrowArr
        dateSelectView.operatingTimeString = operatingTimeString
        dateSelectView.confirmBtnBlock = confirmBtnBlock
        dateSelectView.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.6)
        let window = UIApplication.shared.keyWindow
        window?.addSubview(dateSelectView)
    }

    
    func cancleAction(){
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.y = -kScreenHeight
            
        }) { (_) in
            self.removeFromSuperview()
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    

    fileprivate func setupUI() {
        
        containerView = UIView().then({ (containerView) in
            containerView.backgroundColor = UIColor.clear
            containerView.frame = CGRect(x: 0, y: -kScreenHeight, width: kScreenWith, height: kScreenHeight)
        })
        self.addSubview(containerView)
        
        mainContainerView = UIView().then({ (mainContainerView) in
            mainContainerView.backgroundColor = BG_COLOR
            mainContainerView.frame = CGRect(x: 0, y: 0, width: kScreenWith, height: kScreenHeight - 200)
        })
        containerView.addSubview(mainContainerView)
        
        
        let topView = UIView().then {
            $0.backgroundColor = NAV_BG_COLOR
            $0.frame = CGRect(x: 0, y: 0, width: kScreenWith, height: 64)
        }
        mainContainerView.addSubview(topView)
        
        let topNavVeiw = UIView().then { (topNavVeiw) in
            topNavVeiw.backgroundColor = UIColor.clear
            topNavVeiw.frame = CGRect(x: 0, y: 20, width: kScreenWith, height: 44)
        }
        topView.addSubview(topNavVeiw)
        
        //上一年
        lastYearBtutton = UIButton().then({ (lastYearBtutton) in
            lastYearBtutton.frame = CGRect(x: 10, y: (topNavVeiw.size.height - 25) * 0.5 , width: 25, height: 25)
            lastYearBtutton.setImage(UIImage(named:"calendar_year_left"), for: .normal)
            lastYearBtutton.addTarget(self, action: #selector(lastYearAction), for: .touchUpInside)
            lastYearBtutton.setTitleColor(UIColor.black, for: .normal)
        })
        topNavVeiw.addSubview(lastYearBtutton)
        
        //上一月
        lastMonthBtutton = UIButton().then({ (lastMonthBtutton) in
            lastMonthBtutton.frame = CGRect(x:lastYearBtutton.frame.maxX, y: (topNavVeiw.size.height - 25) * 0.5, width: 25, height: 25)
            lastMonthBtutton.setImage(UIImage(named:"calendar_month_left"), for: .normal)
            lastMonthBtutton.addTarget(self, action: #selector(lastMonthAction), for: .touchUpInside)
            lastMonthBtutton.setTitleColor(UIColor.black, for: .normal)
        })
        topNavVeiw.addSubview(lastMonthBtutton)
        
        
       
        
        //下一年
        nextYearButton = UIButton().then({ (nextYearButton) in
            nextYearButton.frame = CGRect(x: kScreenWith - 30, y: (topNavVeiw.size.height - 25) * 0.5, width: 25, height: 25)
            nextYearButton.setImage(UIImage(named:"calendar_year_right"), for: .normal)
            nextYearButton.setTitleColor(UIColor.black, for: .normal)
            nextYearButton.addTarget(self, action: #selector(nextYearAction), for: .touchUpInside)
        })
        
        topNavVeiw.addSubview(nextYearButton)
        
        
        //下一月
        nextMonthButton = UIButton().then({ (nextMonthButton) in
            nextMonthButton.frame = CGRect(x: nextYearButton.frame.minX - 30, y: (topNavVeiw.size.height - 25) * 0.5, width: 25, height: 25)
            nextMonthButton.setImage(UIImage(named:"calendar_month_right"), for: .normal)
            nextMonthButton.setTitleColor(UIColor.black, for: .normal)
            nextMonthButton.addTarget(self, action: #selector(nextMonthAction), for: .touchUpInside)
        })
        
        topNavVeiw.addSubview(nextMonthButton)
        
        
        calenderLabel = UILabel().then({ (calenderLabel) in
            calenderLabel.frame = CGRect(x: lastMonthBtutton.frame.maxX, y: (topNavVeiw.size.height - 30) * 0.5, width: nextMonthButton.frame.minX - lastMonthBtutton.frame.maxX , height: 30)
            calenderLabel.textAlignment = .center
            calenderLabel.text = "日期"
            calenderLabel.textColor = UIColor.white
            calenderLabel.font = UIFont.systemFont(ofSize: 18)
        })
        
        topNavVeiw.addSubview(calenderLabel)
        
        
        
        
        
        
        //MARK: -- collectionView

        let itemWidth = kScreenWith / 7 - 5
        let itemHeight = itemWidth
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        collection = UICollectionView(frame: CGRect(x: 0, y: topView.frame.maxY, width: kScreenWith, height: itemHeight * 7 + 10), collectionViewLayout: layout)
        collection.backgroundColor = BG_COLOR
        collection.register(UINib.init(nibName: "dateCell", bundle: nil), forCellWithReuseIdentifier: dateIdentifier )
        collection.register(UINib.init(nibName: "CalenderCell", bundle: nil), forCellWithReuseIdentifier: calenderIdentifier )
        collection.isScrollEnabled = false
        collection.dataSource = self
        collection.delegate = self
        mainContainerView.addSubview(collection)
        
        self.setCalenderLabelText()
        
        //MARK: -- 底部选择营业时间View
        operatingTimeView = UIView().then({ (operatingTimeView) in
            operatingTimeView.backgroundColor = UIColor.clear
            operatingTimeView.frame = CGRect(x: 0, y: collection.frame.maxY, width: kScreenWith, height: 90)
        })
        mainContainerView.addSubview(operatingTimeView)
        
        operatingTimeLbel = UILabel().then({ (operatingTimeLbel) in
            operatingTimeLbel.frame = CGRect(x: 10, y: 10, width: kScreenWith, height: 20)
            operatingTimeLbel.text = "仓库运营时间：9:00-18:00"
            operatingTimeLbel.font = UIFont.systemFont(ofSize: 14)
        })
        operatingTimeView.addSubview(operatingTimeLbel)
        
        let timeDescLabel = UILabel().then { (timeDescLabel) in
            timeDescLabel.frame = CGRect(x: 10, y: operatingTimeLbel.frame.maxY + 5, width: 40, height: 40)
            timeDescLabel.text = "时间"
            timeDescLabel.font = UIFont.systemFont(ofSize: 14)
        }
        operatingTimeView.addSubview(timeDescLabel)


        selectTimeButton = DateSelectButton().then({ (selectTimeButton) in
            selectTimeButton.frame = CGRect(x: timeDescLabel.frame.maxX, y: timeDescLabel.frame.minY, width: 130, height: 40)
            if self.dateTimeTodayArr.count > 0 {
                selectTimeButton.setTitle(dateTimeTodayArr[0], for: .normal)
            } else {
                selectTimeButton.setTitle("无可选时间", for: .normal)
            }
            selectTimeButton.setTitleColor(UIColor.black, for: .normal)
            selectTimeButton.setImage(UIImage(named: "date_arrow_down"), for: .normal)
            selectTimeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            selectTimeButton.layer.borderColor = SUP_SEGMENT_COLOR.cgColor
            selectTimeButton.layer.borderWidth = 0.5
            selectTimeButton.layer.cornerRadius = 2
            selectTimeButton.layer.masksToBounds = true
            selectTimeButton.addTarget(self, action: #selector(selectTimeButtonClick), for: .touchUpInside)

        })
        operatingTimeView.addSubview(selectTimeButton)
        
        //确定按钮
        completeButton = UIButton().then({ (completeButton) in
            completeButton.frame = CGRect(x: 0, y: operatingTimeView.frame.maxY + 20, width: kScreenWith * 0.5, height: 38)
            completeButton.centerX = kScreenWith * 0.5
            completeButton.backgroundColor = BTN_ORANGE
            completeButton.layer.cornerRadius = 38 * 0.5
            completeButton.layer.masksToBounds = true
            completeButton.setTitleColor(UIColor.white, for: .normal)
            completeButton.setTitle("确定", for: .normal)
            completeButton.addTarget(self, action: #selector(completeButtonClick(_ :)), for: .touchUpInside)
        })
        mainContainerView.addSubview(completeButton)
        
        mainContainerView.frame = CGRect(x: 0, y: 0, width: kScreenWith, height: completeButton.frame.maxY + 20)

        bottomView = UIView().then { (bottomView) in
            bottomView.frame = CGRect(x: 0, y: mainContainerView.frame.maxY, width: kScreenWith, height: kScreenHeight - mainContainerView.frame.maxY)
            bottomView.backgroundColor = UIColor.clear
        }
        
        containerView.addSubview(bottomView)
        
        let addTapgesture = UITapGestureRecognizer()
        addTapgesture.addTarget(self, action: #selector(dissmissInput(_:)))
        bottomView.addGestureRecognizer(addTapgesture)
    
        
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 30
        tableView.layer.borderColor = SUP_SEGMENT_COLOR.cgColor
        tableView.layer.borderWidth = 0.5
        tableView.layer.cornerRadius = 2
        tableView.layer.masksToBounds = true
//        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kDateSelectViewCelldentifier)

        tableView.frame = CGRect(x: selectTimeButton.frame.minX, y: selectTimeButton.frame.maxY + collection.frame.maxY, width: selectTimeButton.frame.size.width, height: 90)
        containerView.addSubview(tableView)
        
        tableView.isHidden = true
        
        let dateStr = String.init(format: "%02d-%02d-%02d", DateHelper.year(date: self.date), DateHelper.month(date: self.date), DateHelper.day(date: self.date))
        
        self.selectDatesStr = dateStr
        if self.dateTimeTodayArr.count > 0 {
            self.timeStr = dateTimeTodayArr[0]
        } else {
            selectTimeButton.setTitle("无可选时间", for: .normal)
        }
        
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        collection.addGestureRecognizer(swipeGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.left;
        collection.addGestureRecognizer(swipeLeftGesture)
        
    }

    //MARK: -- SwipeGesture
    //滑动手势
    @objc fileprivate func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        //划动的方向
        let direction = sender.direction
        //判断是上下左右
        switch (direction){
        case UISwipeGestureRecognizerDirection.left:
            self.nextMonthAction()
        case UISwipeGestureRecognizerDirection.right:
            self.lastMonthAction()

        case UISwipeGestureRecognizerDirection.up:
            printLog("Up")
        case UISwipeGestureRecognizerDirection.down:
            printLog("Down")
        default:
            break;
        }
    }
  
    
    
    @objc fileprivate func dissmissInput(_ sender: Any) {
        self.cancleAction()
    }
    
 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        UIView.animate(withDuration: 0.25) {
            self.containerView.y = 0
        }
    }
    
    fileprivate func setCalenderLabelText(){
        self.calenderLabel.text = "\(DateHelper.month(date: self.date))月-\(DateHelper.year(date: self.date))年"

    }
    
    //上个月
    @objc fileprivate func lastMonthAction(){
        UIView.transition(with: self.collection, duration: 0.5, options: .transitionCurlDown, animations: {
            self.date = DateHelper.lastMonth(date: self.date)
            self.setCalenderLabelText()
        }, completion: nil)
        self.collection.reloadData()
        
    }
    
    //下个月
    @objc fileprivate func nextMonthAction(){
        UIView.transition(with: self.collection, duration: 0.5, options: .transitionCurlUp, animations: {
            self.date = DateHelper.nextMonth(date: self.date)
            self.setCalenderLabelText()
        }, completion: nil)
        self.collection.reloadData()
        
    }
    
    
    //上一年
    @objc fileprivate func lastYearAction(){
        UIView.transition(with: self.collection, duration: 0.5, options: .transitionCurlDown, animations: {
            self.date = DateHelper.lastYear(date: self.date)
            self.setCalenderLabelText()
        }, completion: nil)
        self.collection.reloadData()
        
    }
    
    //下一年
    @objc fileprivate func nextYearAction(){
        UIView.transition(with: self.collection, duration: 0.5, options: .transitionCurlUp, animations: {
            self.date = DateHelper.nextYear(date: self.date)
            self.setCalenderLabelText()
        }, completion: nil)
        self.collection.reloadData()
        
    }
    
    //MARK: -- 选择时间按钮
    @objc fileprivate func selectTimeButtonClick(){
        
        if DateHelper.strConverDate(dateStr: DateHelper.dateConvertString(date: self.date)) == DateHelper.strConverDate(dateStr: DateHelper.dateConvertString(date: self.enableDate)) {
            if dateTimeTodayArr.count > 0 {
                tableView.isHidden = false
            }
        }else {
            tableView.isHidden = false
        }

    }

    //MARK: -- 确定按钮
    @objc fileprivate func completeButtonClick(_ sender: UIButton){
        
        if self.dateSelectViewType == .dates {
            if !isSelectMonth {
//                AJProgressHud.showText("请选择日期")
                return
            }
        }
        
        if self.confirmBtnBlock !=  nil {
            switch self.dateSelectViewType {
            case .dates:
                
                self.confirmBtnBlock(sender,self.selectDatesStr, "")

            case .time:
                if DateHelper.strConverDate(dateStr: DateHelper.dateConvertString(date: self.date)) == DateHelper.strConverDate(dateStr: DateHelper.dateConvertString(date: self.enableDate))  {
                    if self.dateTimeTodayArr.count > 0 {
                    } else {
//                        AJProgressHud.showText("今日不可选")
                        return
                    }
                }
                
                self.confirmBtnBlock(sender,self.selectDatesStr, self.timeStr)
            }

        }
        cancleAction()
    }
    

}

extension DateSelectView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return dateArray.count
        }else {
            //            let daysInThisMonth = DateHelper.totaldaysInMonth(date: self.date)
            //            let firstWeekday = DateHelper.firstWeekdayInThisMonth(date: self.date)
            //            var day: Int = 0
            //            day = daysInThisMonth - 1 + firstWeekday - 1 - 1 //当前月份的总天数
            return 42
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateIdentifier, for: indexPath) as! dateCell
            cell.dateLabel.text = dateArray[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calenderIdentifier, for: indexPath) as! CalenderCell
            let daysInThisMonth = DateHelper.totaldaysInMonth(date: date)
            
            let firstWeekday = DateHelper.firstWeekdayInThisMonth(date: date)
            
            var day: Int = 0
            let i = indexPath.row
            cell.timeLabel.text = ""
            cell.backgroundColor = UIColor.clear
            
            if i >= firstWeekday && i <= firstWeekday - 1  + daysInThisMonth - 1 {
                day = i - firstWeekday + 1
                cell.timeLabel.text = "\(day)"
                if selectIndex == i && selectMonth == DateHelper.month(date: self.date) && selectYear == DateHelper.year(date: self.date){
                    cell.isSelectedImage = true
                } else {
                    cell.isSelectedImage = false
                }
                
                //天数是当前填   月是当前月  年是当前年
                if day == DateHelper.day(date: Date()) && month == DateHelper.month(date: self.date) && year == DateHelper.year(date: self.date) {
                    cell.backgroundColor = NAV_BG_COLOR
                }
                switch dateSelectEnableDateType {
                case .none:
                    break
                case .before:
                    
                    if DateHelper.year(date: self.date) > DateHelper.year(date: self.enableDate) {
                        cell.backgroundColor = SUP_SEGMENT_COLOR
                    }else {
                        if DateHelper.month(date: self.date) > DateHelper.month(date: self.enableDate) &&  DateHelper.year(date: self.date) == DateHelper.year(date: self.enableDate){
                            cell.backgroundColor = SUP_SEGMENT_COLOR
                        } else {
                            if day > DateHelper.day(date: self.enableDate) && DateHelper.month(date: self.date) == DateHelper.month(date: self.enableDate) &&  DateHelper.year(date: self.date) == DateHelper.year(date: self.enableDate){
                                cell.backgroundColor = SUP_SEGMENT_COLOR
                            }
                        }
                        
                    }

                case .after:
                    if DateHelper.year(date: self.date) < DateHelper.year(date: self.enableDate) {
                        cell.backgroundColor = SUP_SEGMENT_COLOR
                    }else {
                        if DateHelper.month(date: self.date) < DateHelper.month(date: self.enableDate) &&  DateHelper.year(date: self.date) == DateHelper.year(date: self.enableDate){
                            cell.backgroundColor = SUP_SEGMENT_COLOR
                        } else {
                            if day < DateHelper.day(date: self.enableDate) && DateHelper.month(date: self.date) == DateHelper.month(date: self.enableDate) &&  DateHelper.year(date: self.date) == DateHelper.year(date: self.enableDate){
                                cell.backgroundColor = SUP_SEGMENT_COLOR
                            }
                        }
                    }
                }
                
                
                
            }else {
                cell.backgroundColor = UIColor.clear
                cell.isSelectedImage = false
            }

            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        isSelectMonth = true
        if indexPath.section == 1 {
            let i = indexPath.row
            
            let firstWeekday = DateHelper.firstWeekdayInThisMonth(date: date)
            
            let daysInThisMonth = DateHelper.totaldaysInMonth(date: date)
            var day: Int = 0
            
            
            if i >= firstWeekday && i <= firstWeekday - 1  + daysInThisMonth - 1 {
                day = i - firstWeekday + 1
                
                switch dateSelectEnableDateType {
                case .none:
                    break
                case .before:
                    
                    if DateHelper.year(date: self.date) > DateHelper.year(date: self.enableDate) {
                        return
                    }else {
                        if DateHelper.month(date: self.date) > DateHelper.month(date: self.enableDate) &&  DateHelper.year(date: self.date) == DateHelper.year(date: self.enableDate){
                            return
                        } else {
                            if day > DateHelper.day(date: self.enableDate) && DateHelper.month(date: self.date) == DateHelper.month(date: self.enableDate) &&  DateHelper.year(date: self.date) == DateHelper.year(date: self.enableDate){
                                return
                            }
                        }
                        
                    }
                    
                case .after:
                    if DateHelper.year(date: self.date) < DateHelper.year(date: self.enableDate) {
                        return
                    }else {
                        if DateHelper.month(date: self.date) < DateHelper.month(date: self.enableDate) &&  DateHelper.year(date: self.date) == DateHelper.year(date: self.enableDate){
                            return
                        } else {
                            if day < DateHelper.day(date: self.enableDate) && DateHelper.month(date: self.date) == DateHelper.month(date: self.enableDate) &&  DateHelper.year(date: self.date) == DateHelper.year(date: self.enableDate){
                                return
                            }
                        }
                        
                    }
                }
                

                
                selectIndex = indexPath.row
                selectMonth = DateHelper.month(date: self.date)
                selectYear = DateHelper.year(date: self.date)
                
                //let data = str.data!(using: String.Encoding.utf8.rawValue)!
                let dateStr = String.init(format: "%02d-%02d-%02d", selectYear, selectMonth, day)

                self.selectDatesStr = dateStr
                //保存当前时间
                self.date = DateHelper.strConverDate(dateStr: self.selectDatesStr)
                


                self.collection.reloadData()
                
                if dateSelectViewType == .time {
                    self.tableView.reloadData()
                    if DateHelper.strConverDate(dateStr: DateHelper.dateConvertString(date: self.date)) == DateHelper.strConverDate(dateStr: DateHelper.dateConvertString(date: self.enableDate)) {
                        if dateTimeTodayArr.count > 0 {
                            self.selectTimeButton.setTitle(dateTimeTodayArr[0], for: .normal)
                            self.timeStr = dateTimeTodayArr[0]
                        } else {
                            tableView.isHidden = false
                            selectTimeButton.setTitle("无可选时间", for: .normal)
                        }
                        
                    }else {
                        self.selectTimeButton.setTitle(dateTimeTomorrowArr![0], for: .normal)
                        self.timeStr = dateTimeTomorrowArr![0]
                    }
                }
                
            }
        }
    }
    
    
}



extension DateSelectView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dateSelectViewType == .time {
            if DateHelper.strConverDate(dateStr: DateHelper.dateConvertString(date: self.date)) == DateHelper.strConverDate(dateStr: DateHelper.dateConvertString(date: self.enableDate))  {
                if self.dateTimeTodayArr.count > 0 {
                    return dateTimeTodayArr.count
                } else {
                    return 0
                }
            }else {
                return dateTimeTomorrowArr!.count
            }
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kDateSelectViewCelldentifier, for: indexPath)
//        cell.selectionStyle = .none
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        if DateHelper.strConverDate(dateStr: DateHelper.dateConvertString(date: self.date)) == DateHelper.strConverDate(dateStr: DateHelper.dateConvertString(date: self.enableDate)) {
            cell.textLabel?.text = dateTimeTodayArr[indexPath.row]
        }else {
            cell.textLabel?.text = dateTimeTomorrowArr![indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if DateHelper.strConverDate(dateStr: DateHelper.dateConvertString(date: self.date)) == DateHelper.strConverDate(dateStr: DateHelper.dateConvertString(date: self.enableDate)) {
            self.selectTimeButton.setTitle(dateTimeTodayArr[indexPath.row], for: .normal)
            self.timeStr = dateTimeTodayArr[indexPath.row]
        }else {
            self.selectTimeButton.setTitle(dateTimeTomorrowArr![indexPath.row], for: .normal)
            self.timeStr = dateTimeTomorrowArr![indexPath.row]
        }
        
        
        self.tableView.isHidden = true
        
    }
}
