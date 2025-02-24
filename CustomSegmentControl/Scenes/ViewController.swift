//
//  ViewController.swift
//  CustomSegmentControl
//
//  Created by 조유진 on 2/24/25.
//

import UIKit

final class ViewController: UIViewController {
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = SegmentedControl(items: ["전체", "웹툰", "베스트도전"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.setViewControllers([self.viewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private let vc1: UIViewController = {
      let vc = UIViewController()
      vc.view.backgroundColor = .red
      return vc
    }()
    private let vc2: UIViewController = {
      let vc = UIViewController()
      vc.view.backgroundColor = .green
      return vc
    }()
    private let vc3: UIViewController = {
      let vc = UIViewController()
      vc.view.backgroundColor = .blue
      return vc
    }()
    var viewControllers: [UIViewController] {
        [vc1, vc2, vc3]
    }
    
    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            pageViewController.setViewControllers(
                [viewControllers[currentPage]],
                direction: direction,
                animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.pageViewController.view)
        
        NSLayoutConstraint.activate([
          self.segmentedControl.leftAnchor.constraint(equalTo: self.view.leftAnchor),
          self.segmentedControl.rightAnchor.constraint(equalTo: self.view.rightAnchor),
          self.segmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
          self.segmentedControl.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
          self.pageViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 4),
          self.pageViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -4),
          self.pageViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4),
          self.pageViewController.view.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 0),
        ])
        
        configureSegmentedControl()
        segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        changeValue(control: segmentedControl)
    }

    private func configureSegmentedControl() {
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        segmentedControl.setTitleTextAttributes(
              [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
              ],
              for: .selected
            )
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc private func changeValue(control: UISegmentedControl) {
        currentPage = control.selectedSegmentIndex
    }
}

extension ViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?[0],
              let index = viewControllers.firstIndex(of: viewController) else { return }
        currentPage = index
        segmentedControl.selectedSegmentIndex = index
    }
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController),
              index - 1 >= 0 else { return nil }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController),
              index + 1 < viewControllers.count else { return nil }
        return viewControllers[index + 1]
    }
}
