//
    /******************************************************************
            File name:     FYScrollView.swift
            Author:        Qian
            Description:   简介
            History:      2020/5/9: File created.
    *******************************************************************/
    

import UIKit

class FYScrollView: UIScrollView, UIGestureRecognizerDelegate {

    //注意：为了让ScrollView上的多个手势能一起触发，我们要重写最底层绿色ScrollView的方法
    //https://www.jianshu.com/p/b867ed4ee9e3
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
