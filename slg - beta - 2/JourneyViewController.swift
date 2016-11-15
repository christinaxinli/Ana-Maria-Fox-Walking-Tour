

import UIKit

class JourneyViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var currentFox: String = "NA"
    var pageNames: [String] = []
    
    func createNames () -> [String] {
        switch currentFox {
        case "Fox1":
            let Fox1: [String] = ["Fox1_pg1","Fox1_pg2","Fox1_pg3"]
            pageNames.append(contentsOf: Fox1)
            
        case "Fox2":
            let Fox2: [String] = ["Fox2_pg1","Fox2_pg2","Fox2_pg3"]
            pageNames.append(contentsOf: Fox2)
            
        case "Fox3":
            let Fox3: [String] = ["start_pg1","start_pg2","start_pg3"]
            pageNames.append(contentsOf: Fox3)
            
        default:
            pageNames.append("InstructionsViewController")
        }
        
        return pageNames
    }
    
    
    func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
        
    }
    
    lazy var VCArr: [UIViewController] = {
        var names = self.createNames()
        var VCs: [UIViewController] = []
        for i in 0..<names.count {
            VCs.append(self.VCInstance(name: names[i]))
        }
        return VCs
    } ()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        if let firstVC = VCArr.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            print("check1")
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            print("check2")
            return VCArr.first
        }
        
        guard VCArr.count > previousIndex else {
            print("check3")
            return nil
        }
        
        print("check4")
        
        return VCArr[previousIndex]
        
    }
    
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            print("check5")
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArr.count else {
            print("check6")
            return VCArr.first
        }
        
        guard VCArr.count > nextIndex else {
            print("check7")
            return nil
        }
        print("check8")
        return VCArr[nextIndex]
        
    }
    
    internal func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArr.count
    }
    
    internal func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = VCArr.index(of: firstViewController) else {
            return 0
        }
        
        return firstViewControllerIndex
    }
    
}

