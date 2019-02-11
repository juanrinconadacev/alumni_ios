//
//  CreateEventPageViewController.swift
//  AlumniCev
//
//  Created by alumnos on 24/1/18.
//  Copyright © 2018 Victor Serrano. All rights reserved.
//

import UIKit

class CreateEventPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var titleEvent: String?
    var descriptionEvent: String?
    var imageEvent:String?
    var idTypeEvent:Int?
    var idsGroups:[Int] = [Int]()
    
    lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "TipeEventViewController"),
            self.getViewController(withIdentifier: "GroupEventViewController"),
            self.getViewController(withIdentifier: "TitleEventViewController"),
            self.getViewController(withIdentifier: "ImageEventViewController"),
            self.getViewController(withIdentifier: "WebUrlViewController"),
            self.getViewController(withIdentifier: "LocalizationCreateEventViewController"),
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = pages.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0          else { return nil /*pages.last*/ }
        
        guard pages.count > previousIndex else { return nil        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return nil /*pages.first*/ }
        
        guard pages.count > nextIndex else { return nil         }
        
        return pages[nextIndex]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventCreated = Event()
        
        self.dataSource = self
        self.delegate   = self
        
        UIPageControl.appearance().pageIndicatorTintColor = cevColor
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.darkGray
        UIPageControl.appearance().backgroundColor = UIColor.white
        
        if let firstVC = pages.first
        {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func goNextPage(fowardTo position: Int) {
        let viewController = self.pages[position]
        setViewControllers([viewController], direction:
            UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }

}

