//
//  PageViewController.swift
//  PaWPal
//
//  Created by Doren Lan on 11/2/16.
//  Copyright © 2016 HMC CS121 Group 5. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate {
    func getLine() -> LineChartViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("LineChart") as! LineChartViewController
    }
    
    func getPie() -> PieChartViewController {
        return storyboard!.instantiateViewControllerWithIdentifier("PieChart") as! PieChartViewController
    }
    
    override func viewDidLoad() {
        dataSource = self
        delegate = self
        // this sets the background color of the built-in paging dots
        view.backgroundColor = UIColor.orangeColor()
        setViewControllers([getLine()], direction: .Forward, animated: false, completion: nil)
    }
}

extension PageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(PieChartViewController) {
            return getLine()
        } else {
            return nil
        }
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if viewController.isKindOfClass(LineChartViewController) {
            return getPie()
        } else {
            return nil
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
//    private func stylePageControl() {
//        let pageControl = UIPageControl.appearanceWhenContainedInInstancesOfClasses([self.dynamicType])
//        
//        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()
//        pageControl.pageIndicatorTintColor = UIColor.clearColor()
//        pageControl.backgroundColor = UIColor.orangeColor()
//    }
    
}
