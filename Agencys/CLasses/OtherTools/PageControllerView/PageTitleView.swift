//
//  PageTitleView.swift
//  Agencys
//
//  Created by WuXingLin on 2018/4/12.
//  Copyright © 2018年 WuXingLin. All rights reserved.
//

import UIKit

// MARK:- 定义协议
protocol PageTitleViewDelegate : class {
    func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int)
}

// MARK:- 定义常量
private let kScrollLineH : CGFloat = 2
//private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (102, 102, 102)


// MARK:- 定义PageTitleView类
class PageTitleView: UIView {
    
    // MARK:- 定义属性
    fileprivate var currentIndex : Int = 0
    fileprivate var titles : [String]
    weak var delegate : PageTitleViewDelegate?
    
    // MARK:- 懒加载属性
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var verticalLineViews : [UIView] = [UIView]()
    
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    fileprivate lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = NAV_BG_COLOR
        return scrollLine
    }()
    
    //底部小黄条的宽度
    var labelW : CGFloat = 0 {
        didSet{
            scrollLine.width = labelW
            scrollLine.centerX = SCREENW * 0.25
        }
    }
    
    //是否显示小竖条
    var isHiddenVerticalLineView: Bool = false {
        didSet{
            if isHiddenVerticalLineView {
                for lineView in verticalLineViews {
                    lineView.isHidden = isHiddenVerticalLineView
                }
            }
        }
    }
    
    var kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 117, 67) {
        didSet{
            titleLabels[0].textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        }
        
    }
    
    //底部小黄条宽度为控件的一半
    var isScrollLineFull: Bool = false{
        didSet{
            if isScrollLineFull {
                scrollLine.width = labelW
                scrollLine.centerX = SCREENW * 0.25
            }
        }
    }
    
    //是否隐藏底部小黄条
    var hiddenScrollLine: Bool = false {
        didSet {
            scrollLine.isHidden = hiddenScrollLine
        }
    }
    
    // MARK:- 自定义构造函数
    init(frame: CGRect, titles : [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        // 设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func labelSize(text:String ,attributes : [NSObject : AnyObject]) -> CGRect{
        var size = CGRect();
        let size2 = CGSize(width: 100, height: 0);//设置label的最大宽度
        size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as? [NSAttributedStringKey : Any] , context: nil);
        return size
    }
    
    
    
}


// MARK:- 设置UI界面
extension PageTitleView {
    fileprivate func setupUI() {
        // 1.添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2.添加title对应的Label
        setupTitleLabels()
        
        // 3.设置底线和滚动的滑块
        setupBottomLineAndScrollLine()
    }
    
    fileprivate func setupTitleLabels() {
        
        // 0.确定label的一些frame的值
        labelW = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        
        
        for (index, title) in titles.enumerated() {
            // 1.创建UILabel
            let label = UILabel()
            
            // 2.设置Label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 17.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            
            // 3.设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4.将label添加到scrollView中
            scrollView.addSubview(label)
            if (index < titles.count - 1) {
                let lineView = UIView()
                lineView.backgroundColor = UIColor.gray
                lineView.frame = CGRect(x: label.frame.origin.x + label.frame.size.width, y: 10, width: 0.5,height: label.frame.size.height * 0.4)
                lineView.center = CGPoint(x: lineView.center.x,y: label.center.y)
                scrollView.addSubview(lineView)
                verticalLineViews.append(lineView)
            }
            
            titleLabels.append(label)
            
            
            // 5.给Label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    fileprivate func setupBottomLineAndScrollLine() {
        // 1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = SUP_NORMAL_COLOR;
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 2.添加scrollLine
        // 2.1.获取第一个Label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        // 2.2.设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        
        let attributes = [NSAttributedStringKey.font: firstLabel.font!]//计算label的字体
        let rect = labelSize(text: firstLabel.text!, attributes: attributes as [NSObject : AnyObject])
        
        
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: rect.width, height: kScrollLineH)
        var center = scrollLine.center
        center.x = firstLabel.center.x
        scrollLine.center = center
    }
}


// MARK:- 监听Label的点击
extension PageTitleView {
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer) {
        
        // 0.获取当前Label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        // 1.如果是重复点击同一个Title,那么直接返回
        if currentLabel.tag == currentIndex { return }
        
        changeSelectLable(lable: currentLabel)
    }
    
    func selectTitleItem(index: Int, animation: Bool = true) {
        
        if currentIndex == index {
            return
        }
        
        if titleLabels.count > index {
            let currentLabel = titleLabels[index]
            changeSelectLable(lable: currentLabel, animation: animation)
        }
    }
    
    private func changeSelectLable(lable: UILabel, animation: Bool = true) {
        // 2.获取之前的Label
        let oldLabel = titleLabels[currentIndex]
        
        // 3.切换文字的颜色
        lable.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 4.保存最新Label的下标值
        currentIndex = lable.tag
        
        // 5.滚动条位置发生改变
        UIView.animate(withDuration: animation ? 0.15 : 0.0, animations: {
            var center = self.scrollLine.center
            center.x = lable.center.x
            self.scrollLine.center = center
        })
        
        // 6.通知代理
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
        
    }
    
}

// MARK:- 对外暴露的方法
extension PageTitleView {
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.处理滑块的逻辑
        let moveTotalX = targetLabel.centerX - sourceLabel.centerX
        let moveX = moveTotalX * progress
        scrollLine.centerX = sourceLabel.centerX + moveX
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
    }
}
