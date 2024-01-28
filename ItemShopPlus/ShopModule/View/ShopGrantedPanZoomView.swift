//
//  ShopGrantedPanZoomView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 27.01.2024.
//

import UIKit

protocol ShopGrantedPanZoomViewDelegate: AnyObject {
    func didDismiss()
}

class ShopGrantedPanZoomView: UIScrollView {
    
    weak var panZoomDelegate: ShopGrantedPanZoomViewDelegate?
    
    private var initialTouchPoint: CGPoint = CGPoint.zero
    private var centerSuperView: CGPoint = .zero
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupScrollView()
        setupPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: String, presentingViewController: UIViewController) {
        self.init(frame: .zero)
        ImageLoader.loadAndShowImage(from: image, to: imageView)
    }
    
    @objc private func handleDoubleTap(gesture: UITapGestureRecognizer) {
        if zoomScale == 1 {
            zoom(to: zoomForScale(scale: maximumZoomScale, center: gesture.location(in: gesture.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        
        if centerSuperView == CGPoint(x: 0, y: 0) {
            centerSuperView = frame.origin
        }
        let touchPoint = gesture.location(in: superview)
        
        if gesture.state == .began {
            initialTouchPoint = touchPoint
        } else if gesture.state == .changed {
            if zoomScale == 1 {
                let yOffset = touchPoint.y - initialTouchPoint.y
                let alpha = 1 - abs(yOffset) / superview.frame.height
                imageView.alpha = alpha
                center.y = superview.center.y + yOffset
            } else {
                let xOffset = touchPoint.x - initialTouchPoint.x
                self.contentOffset.x = max(0, min(self.contentOffset.x - xOffset, self.contentSize.width - self.bounds.width))
                initialTouchPoint = touchPoint
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            let dismissThreshold: CGFloat = 100
            
            if abs(frame.origin.y) > dismissThreshold {
                dismissViewController()
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.frame.origin = self.centerSuperView
                    self.imageView.alpha = 1
                }
            }
        }
    }
    
    private func zoomForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let centerNew = imageView.convert(center, from: self)
        zoomRect.origin.x = centerNew.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = zoomRect.size.height / 2.0
        return zoomRect
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
    }
    
    private func dismissViewController() {
        panZoomDelegate?.didDismiss()
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -UIScreen.main.bounds.height / 13)
        ])
    }
    
    private func setupScrollView() {
        minimumZoomScale = 1
        maximumZoomScale = 2
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        scrollsToTop = false
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
    }
}

extension ShopGrantedPanZoomView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
