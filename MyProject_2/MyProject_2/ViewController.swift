//
    /******************************************************************
            File name:     ViewController.swift
            Author:        Qian
            Description:   scrollview和tableview嵌套
            History:      2020/5/8: File created.
    *******************************************************************/
    

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var scvMain: FYScrollView!
    var tableView: UITableView!
    let widthW = UIScreen.main.bounds.width
    let heightH = UIScreen.main.bounds.height
    var vcCanScroll = false
    var fingerIsTouch = false
    var canScroll = true
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        cell?.backgroundColor = .magenta
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .black
        return headerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        
        scvMain = FYScrollView(frame: self.view.bounds)
        self.view.addSubview(scvMain)
        scvMain.backgroundColor = .blue
        scvMain.contentSize = CGSize(width: widthW, height: heightH * 2)
        //注意：别忘记写
        scvMain.delegate = self
        
        tableView = UITableView(frame: CGRect(x: 0, y: 200, width: widthW, height: heightH), style: .plain)
        scvMain.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        tableView.sectionHeaderHeight = 50;
//        scvMain.setContentOffset(CGPoint(x: 0, y: 200), animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(changeScrollStatus), name: NSNotification.Name(rawValue: "leaveTop"), object: nil)
    }
    
    @objc func changeScrollStatus() -> Void {
        canScroll = true
        vcCanScroll = false
        tableView.contentOffset = .zero
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == tableView {
        self.fingerIsTouch = true;
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == tableView {
        self.fingerIsTouch = false;
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == scvMain {
            print("scvMain.contentOffset.y = \(scrollView.contentOffset.y)")
            let bottomCellOffset: CGFloat = 200
            if (scrollView.contentOffset.y >= bottomCellOffset) {
                scrollView.contentOffset = CGPoint(x: 0, y: bottomCellOffset);
                if (self.canScroll) {
                    self.canScroll = false;
                    self.vcCanScroll = true;
                }
            }else{
                if (!self.canScroll) {//子视图没到顶部
                    scrollView.contentOffset = CGPoint(x: 0, y: bottomCellOffset)
                }
            }
            self.tableView.showsVerticalScrollIndicator = !canScroll
            scvMain.showsVerticalScrollIndicator = canScroll
            
        }else if scrollView == tableView {
            print("tableView.contentOffset.y = \(scrollView.contentOffset.y)")
            if (!self.vcCanScroll) {
                scrollView.contentOffset = .zero;
            }
            if (scrollView.contentOffset.y <= 0) {
                //        if (!self.fingerIsTouch) {//这里的作用是在手指离开屏幕后也不让显示主视图，具体可以自己看看效果
                //            return;
                //        }
                self.vcCanScroll = false;
                scrollView.contentOffset = .zero;
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "leaveTop"), object: nil)
                //到顶通知父视图改变状态
            }
            self.tableView.showsVerticalScrollIndicator = vcCanScroll
            scvMain.showsVerticalScrollIndicator = !vcCanScroll
        }
        
    }


}

