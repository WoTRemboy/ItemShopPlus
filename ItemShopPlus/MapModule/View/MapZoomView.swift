//
//  MapZoomView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 19.02.2024.
//

import UIKit

final class MapZoomView: UIScrollView {
    
    // MARK: - Properties
        
    private var initialTouchPoint: CGPoint = CGPoint.zero
    private var centerSuperView: CGPoint = .zero
    
    // MARK: - UI Elements
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc private func handleDoubleTap(gesture: UITapGestureRecognizer) {
        if zoomScale == 1 {
            zoom(to: zoomForScale(scale: 2, center: gesture.location(in: gesture.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
    
    // MARK: - Zoom Rules
    
    private func zoomForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let centerNew = imageView.convert(center, from: self)
        zoomRect.origin.x = centerNew.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = zoomRect.size.height / 2.0
        return zoomRect
    }
    
    // MARK: - UI Setups

    private func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.2),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -UIScreen.main.bounds.height / 13)
        ])
    }
    
    private func setupScrollView() {
        minimumZoomScale = 1
        maximumZoomScale = 5
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        scrollsToTop = false
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
    }
}

// MARK: - UIScrollViewDelegate

extension MapZoomView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

