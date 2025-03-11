//
//  ViewController.swift
//  CustomSegmentControl
//
//  Created by 조유진 on 2/24/25.
//

import UIKit

final class ViewController: UIViewController {
    enum PencilShopTabItem: String {
        case Buying = "구매하기"
        case Obtained = "얻은 연필"
        case Purchased = "구매한 연필"
        case Used = "사용한 연필"
    }
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = SegmentedControl(items: [
            PencilShopTabItem.Buying.rawValue,
            PencilShopTabItem.Obtained.rawValue,
            PencilShopTabItem.Purchased.rawValue,
            PencilShopTabItem.Used.rawValue
        ])
        segmentedControl.apportionsSegmentWidthsByContent = true
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .superLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
      vc.view.backgroundColor = .white
      return vc
    }()
    private let vc2: UIViewController = {
      let vc = UIViewController()
      vc.view.backgroundColor = .white
      return vc
    }()
    private let vc3: UIViewController = {
      let vc = UIViewController()
      vc.view.backgroundColor = .white
      return vc
    }()
    private let vc4: UIViewController = {
      let vc = UIViewController()
        vc.view.backgroundColor = .white
      return vc
    }()
    var viewControllers: [UIViewController] {
        [vc1, vc2, vc3, vc4]
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
        
        self.view.addSubview(self.dividerView)
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.pageViewController.view)

        NSLayoutConstraint.activate([
            self.segmentedControl.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            self.segmentedControl.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20),
            self.segmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            self.segmentedControl.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            self.dividerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.dividerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            self.dividerView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: -1),
            self.dividerView.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        NSLayoutConstraint.activate([
            self.pageViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            self.pageViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            self.pageViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            self.pageViewController.view.topAnchor.constraint(equalTo: self.dividerView.bottomAnchor, constant: 0),
        ])
        
        configureSegmentedControl()
        segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        changeValue(control: segmentedControl)
    }

    private func configureSegmentedControl() {
        segmentedControl.setTitleTextAttributes(
              [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
              ],
              for: .normal
            )
        segmentedControl.setTitleTextAttributes(
              [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                .font: UIFont.systemFont(ofSize: 14, weight: .bold)
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
