//
//  Created by Kikacheishvili Bohdan on 22.12.2024.
//

import UIKit

class PulseTabBar: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: -
    // MARK: Variables
    
    private var distortionHeight: CGFloat
    private var backgroundColor: UIColor {
        didSet {
            self.updateBackgroundColor()
        }
    }
    
    private let backgroundLayer = CAShapeLayer()
    private let distortDuration: CFTimeInterval = 0.05
    private let resetDuration: CFTimeInterval = 0.4
    
    // MARK: -
    // MARK: Init
    
    public init(distortionHeight: CGFloat? = -10, backgroundColor: UIColor? = UIColor.systemGray6) {
        self.distortionHeight = -(distortionHeight ?? 10)
        self.backgroundColor = backgroundColor ?? UIColor.systemGray6
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.setupBackgroundLayer()
    }
    
    // MARK: -
    // MARK: Public
    
    public func background(color: UIColor) {
        self.backgroundColor = color
    }
    
    public func distortion(height: CGFloat) {
        self.distortionHeight = -height
    }
    
    // MARK: -
    // MARK: Private
    
    private func setupBackgroundLayer() {
        self.updateBackgroundColor()
        self.backgroundLayer.frame = self.tabBar.bounds
        self.backgroundLayer.path = path(with: nil)
        self.tabBar.layer.insertSublayer(self.backgroundLayer, at: 0)
    }
    
    private func updateBackgroundColor() {
        self.backgroundLayer.fillColor = self.backgroundColor.cgColor
        self.tabBar.backgroundColor = self.backgroundColor
    }

    private func path(with distortedIndex: Int?) -> CGPath {
        let tabBarHeight = self.tabBar.bounds.height
        let tabBarWidth = self.tabBar.bounds.width
        let tabWidth = tabBarWidth / CGFloat(tabBar.items?.count ?? 1)
        let topOffsetX = (tabWidth / 5)
        let bottomOffsetX = (tabWidth / 4)
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        for index in 0..<(tabBar.items?.count ?? 0) {
            let startX = CGFloat(index) * tabWidth
            let endX = startX + tabWidth
            let isDistorted = distortedIndex == index

            if isDistorted {
                let midX = startX + tabWidth / 2
                path.addCurve(
                    to: CGPoint(x: midX, y: self.distortionHeight),
                    controlPoint1: CGPoint(x: startX + bottomOffsetX, y: 0),
                    controlPoint2: CGPoint(x: midX - topOffsetX, y: self.distortionHeight)
                )
                path.addCurve(
                    to: CGPoint(x: endX, y: 0),
                    controlPoint1: CGPoint(x: midX + topOffsetX, y: self.distortionHeight),
                    controlPoint2: CGPoint(x: endX - bottomOffsetX, y: 0)
                )
            } else {
                path.addLine(to: CGPoint(x: startX + tabWidth / 2, y: 0))
                path.addLine(to: CGPoint(x: endX, y: 0))
            }
        }

        path.addLine(to: CGPoint(x: tabBarWidth, y: 0))
        path.addLine(to: CGPoint(x: tabBarWidth, y: tabBarHeight))
        path.addLine(to: CGPoint(x: 0, y: tabBarHeight))
        path.close()

        return path.cgPath
    }

    private func animate(for index: Int) {
        let distortAnimation = self.backgroundAnimation(index: index, isReset: false)
        let resetAnimation = self.backgroundAnimation(index: index, isReset: true)

        self.backgroundLayer.add(distortAnimation, forKey: "distortAnimation")
        self.backgroundLayer.add(resetAnimation, forKey: "resetAnimation")
        self.animateTabFor(index: index)
    }
    
    private func backgroundAnimation(index: Int, isReset: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = isReset ? self.path(with: index) : self.path(with: nil)
        animation.toValue =  isReset ? self.path(with: nil) : self.path(with: index)
        animation.beginTime = isReset ? CACurrentMediaTime() + self.distortDuration : CACurrentMediaTime()
        animation.duration = isReset ? self.resetDuration : self.distortDuration
        animation.timingFunction = isReset
            ? CAMediaTimingFunction(name: .easeIn)
            : CAMediaTimingFunction(name: .easeOut)
        
        return animation
    }
    
    private func animateTabFor(index: Int) {
        let itemView = self.tabBar.subviews[index + 1] as UIView
        UIView.animate(withDuration: self.distortDuration, animations: {
            itemView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: self.resetDuration) {
                itemView.transform = .identity
            }
        }
    }
    
    // MARK: -
    // MARK: UITabBarControllerDelegate

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let selectedIndex = viewControllers?.firstIndex(of: viewController) {
            self.animate(for: selectedIndex)
        }
    }
}
