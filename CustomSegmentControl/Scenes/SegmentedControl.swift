//
//  SegmentedControl.swift
//  CustomSegmentControl
//
//  Created by 조유진 on 2/24/25.
//

import UIKit

final class SegmentedControl: UISegmentedControl {
    private lazy var underlineView: UIView = {
        let selectedSegment = subviews[0]
        let segFrame = selectedSegment.frame
    
        // 선택된 세그먼트의 타이틀 가져오기
        let title = titleForSegment(at: 0) ?? ""

        // 세그먼트에 적용된 폰트 구하기
        let selectedAttributes = titleTextAttributes(for: .selected)
        let selectedFont = (selectedAttributes?[.font] as? UIFont) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)

        // 텍스트 실제 폭 계산
        let textWidth = title.size(withAttributes: [.font: selectedFont]).width

        let underlineWidth = textWidth

        
        // 세그먼트의 중간 지점
        let segCenterX = segFrame.midX
        
        let underlineHeight: CGFloat = 1
        
        let frame = CGRect(
            x: segCenterX - underlineWidth / 2,
            y: self.bounds.height - underlineHeight,
            width: underlineWidth,
            height: underlineHeight
        )
        let view = UIView()
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
        
        guard selectedSegmentIndex >= 0, selectedSegmentIndex < numberOfSegments else { return }
        
        // 세그먼트 서브뷰들을 x좌표 순서대로 정렬
        let segmentSubviews = subviews
            .filter { $0 != underlineView } // underlineView는 제외
        
        guard selectedSegmentIndex < segmentSubviews.count else { return }
        
        let selectedSegment = segmentSubviews[selectedSegmentIndex]
        let segFrame = selectedSegment.frame  // (내부 좌표)
    
        // 선택된 세그먼트의 타이틀 가져오기
        guard let title = titleForSegment(at: selectedSegmentIndex) else { return }

        // 세그먼트에 적용된 폰트 구하기
        let selectedAttributes = titleTextAttributes(for: .selected)
        let selectedFont = (selectedAttributes?[.font] as? UIFont) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)

        // 텍스트 실제 폭 계산
        let textWidth = title.size(withAttributes: [.font: selectedFont]).width
        print(textWidth)

        let underlineWidth = textWidth

        
        // 세그먼트의 중간 지점
        let segCenterX = segFrame.midX
        
        let underlineHeight: CGFloat = 1
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame = CGRect(
                x: segCenterX - underlineWidth / 2,
                y: self.bounds.height - underlineHeight,
                width: underlineWidth,
                height: underlineHeight
            )
        }
    }
}

