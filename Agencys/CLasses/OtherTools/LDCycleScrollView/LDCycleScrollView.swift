//
//  LDCycleScrollView.swift
//  ExpressSystem
//
//  Created by 祁志远 on 2017/6/29.
//  Copyright © 2017年 Kean. All rights reserved.
//

import UIKit


private let middleIndex = 1 //大于等于1
private let endIndex = 3  //最少大于3

private let kCycleCellID = "LDCycleScrollViewCell"

typealias KCellDidSelectItemAt = (_ indexPathRow :Int) ->()

class LDCycleScrollView: UIView {
    
    fileprivate var collectionView: UICollectionView!

    fileprivate var pageControl: UIPageControl!
    
    
    var cellDidSelectBlock: KCellDidSelectItemAt!
    
    var isGesture: Bool = false
    
    var koffsetX: CGFloat?
    
    var KcurrentPage: Int?
    
    var cycleTimerTime: CGFloat = 5.0 {
        didSet{
            //先移除定时器
            removeCycleTimer()
            // 4.添加定时器
            addCycleTimer()
        }
    }
    
    var pageControlOrginY: CGFloat? {
        didSet{
            if pageControlOrginY! > 0 {
                self.pageControl.y = self.bounds.size.height-20 - pageControlOrginY!
            }
        }
    }
    
    
    // MARK: 定义属性 定时器
    var cycleTimer : Timer?
    
    var cycleModels: [CycleViewModel]? {
        didSet{
            // 1.刷新collectionView
            collectionView?.reloadData()
            
            // 2.设置pageControl个数
            pageControl.numberOfPages = cycleModels?.count ?? 0
            
            // 3.默认滚动到中间某一个位置
            if (cycleModels?.count)! > 1 {
                pageControl.isHidden = false
                //先移除定时器
                removeCycleTimer()

                let indexPath = IndexPath(item: (cycleModels?.count ?? 0) * middleIndex, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
                // 4.添加定时器
                addCycleTimer()
            } else {
                pageControl.isHidden = true
                removeCycleTimer()
            }
           
        }
    }
    
    public func addCycleAllTimer(){
        removeCycleTimer()
        addCycleTimer()
    }
    public func clearCycleTimer(){
        removeCycleTimer()
    }
    
    init(frame: CGRect, isGesture: Bool) {
        super.init(frame: frame)
        self.isGesture = isGesture
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupUI(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.size.width, height:self.bounds.size.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height), collectionViewLayout: layout)
        collectionView.backgroundColor = BG_COLOR;
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.register(UINib(nibName: "LDCycleScrollViewCell", bundle: nil),  forCellWithReuseIdentifier: kCycleCellID)
        collectionView.register(LDCycleViewScrollViewCell.self, forCellWithReuseIdentifier: kCycleCellID)

        self.addSubview(collectionView)
        

        
        pageControl = UIPageControl.init(frame: CGRect(x:0, y:self.bounds.size.height-20, width:self.bounds.size.width, height:20)) as  UIPageControl
        pageControl.currentPageIndicatorTintColor = NAV_BG_COLOR
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.numberOfPages = 1
        pageControl.addTarget(self, action: #selector(pageTurn(_:)), for: .touchUpInside)
        self.addSubview(pageControl)

    }
    
    deinit {
        print("didinit-------------")
    }
    
    @objc func pageTurn(_ sender: UIPageControl) {
        
        if (cycleModels?.count)! > 1 {
            removeCycleTimer()
            //让其偏移量始终在中间部分
            collectionView.setContentOffset(CGPoint(x: CGFloat(sender.currentPage + pageControl.numberOfPages) * collectionView.bounds.width, y: 0), animated: false)
            addCycleTimer()

        }
    }
}



extension LDCycleScrollView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.cycleModels != nil) {
            //无线轮播
            if (cycleModels?.count)! > 1 {
                return (cycleModels?.count ?? 0) * endIndex
            } else {
                return (cycleModels?.count ?? 0)
            }
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! LDCycleViewScrollViewCell
        cell.isGesture = self.isGesture
        cell.cycleModel = cycleModels![(indexPath as NSIndexPath).item % cycleModels!.count]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let indexPathRow = indexPath.row % (cycleModels?.count)!
        if self.cellDidSelectBlock != nil {
            self.cellDidSelectBlock(indexPathRow)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (cycleModels?.count)! > 1 {
            // 1.获取滚动的偏移量
            let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
            // 2.计算pageControl的currentIndex
            koffsetX  = offsetX
            
            pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
            KcurrentPage = pageControl.currentPage
            
        }
        
    }
    //开始拖拽 结束定时器
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //无线轮播
        if (cycleModels?.count)! > 1 {
            removeCycleTimer()
        }
        
    }
    //结束拖拽 开启定时器
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (cycleModels?.count)! > 1 {
            addCycleTimer()
        }
        
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (cycleModels?.count)! > 1 {
            let page = Int(scrollView.contentOffset.x / collectionView.bounds.width)
            //当其滑到第一个图时，让其滑到中间的图
            if page == 0 {
                let count1 = (cycleModels?.count)! * middleIndex
                let offsetX  =  collectionView.bounds.width * CGFloat(count1)
                collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
            }
            
            //当滑动到最后一个图时，让其便宜到第一列的最后一个图
            if page == (cycleModels?.count)! * endIndex - 1 {
                let count1 = (cycleModels?.count)! * middleIndex - 1
                let offsetX  =  collectionView.bounds.width * CGFloat(count1)
                collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
            }
        }
    }
    

}


extension LDCycleScrollView {
    fileprivate func removeCycleTimer() {
        cycleTimer?.invalidate() // 从运行循环中移除
        cycleTimer = nil
    }
    
    fileprivate func addCycleTimer(){
        cycleTimer = Timer(timeInterval: TimeInterval(cycleTimerTime), target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoopMode.commonModes)
    }
    
    
    @objc fileprivate func scrollToNext() {
        if (self.cycleModels != nil) {
            // 1.获取滚动的偏移量
            let currentOffsetX = collectionView.contentOffset.x
            let count = (cycleModels?.count)! * endIndex - 1
            var offsetX = currentOffsetX + collectionView.bounds.width
            //当其便宜亮为最后一个时
            if currentOffsetX == (collectionView.bounds.width * CGFloat(count)){
                let count1 = (cycleModels?.count)! * middleIndex
                offsetX  =  collectionView.bounds.width * CGFloat(count1)
                collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
            } else {
                collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            }
        }else {
            self.clearCycleTimer()
        }
    }
}
