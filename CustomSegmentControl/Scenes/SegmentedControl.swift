//
//  SegmentedControl.swift
//  CustomSegmentControl
//
//  Created by 조유진 on 2/24/25.
//

import UIKit

final class SegmentedControl: UISegmentedControl {
    private lazy var underlineView: UIView = {
        let width = bounds.size.width / CGFloat(self.numberOfSegments)
        let height = 2.0
        let xPosition = CGFloat(selectedSegmentIndex * Int(width))
        let yPosition = bounds.size.height - 1.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = .black
        addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        removeBackgroundAndDivider()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        removeBackgroundAndDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        setBackgroundImage(image, for: .normal, barMetrics: .default)
        setBackgroundImage(image, for: .selected, barMetrics: .default)
        setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 선택된 세그먼트의 타이틀 가져오기
        guard let title = titleForSegment(at: selectedSegmentIndex) else { return }
        
        // 세그먼트에 적용된 폰트 구하기
        let selectedAttributes = titleTextAttributes(for: .selected)
        let selectedFont = (selectedAttributes?[.font] as? UIFont) ?? UIFont.systemFont(ofSize: 13, weight: .semibold)
        
        // 텍스트 실제 폭 계산
        let textWidth = title.size(withAttributes: [.font: selectedFont]).width
        print(textWidth)
        
        let horizontalPadding: CGFloat = 2
        let underlineWidth = textWidth + horizontalPadding * 2
        
        let segmentWidth = bounds.width / CGFloat(numberOfSegments)
        let segmentOriginX = segmentWidth * CGFloat(selectedSegmentIndex)
        
        // 세그먼트 수평 중앙
        let segmentCenterX = segmentOriginX + segmentWidth / 2
        
        let underlineHeight: CGFloat = 1
        let underlineX = segmentCenterX - underlineWidth / 2
        let underlineY = bounds.height - underlineHeight
        
        
        UIView.animate(withDuration: 0.1) {
            self.underlineView.frame = CGRect(
                x: underlineX,
                y: underlineY,
                width: underlineWidth,
                height: underlineHeight
            )
        }
    }
}

