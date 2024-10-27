//
//  MapZoomView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 19.02.2024.
//

import UIKit

/// A custom scroll view subclass that provides zooming functionality for an image
final class MapZoomView: UIScrollView {
    
    // MARK: - Properties
        
    /// Stores the initial touch point for gesture recognition
    private var initialTouchPoint: CGPoint = .zero
    /// Stores the center point of the superview, used for calculating zooming
    private var centerSuperView: CGPoint = .zero
    
    // MARK: - UI Elements
    
    /// The image view displayed inside the scroll view, which can be zoomed
    internal let imageView: UIImageView = {
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
    
    /// Handles double-tap gestures to zoom in and out
    /// - Parameter gesture: The double-tap gesture recognizer
    @objc private func handleDoubleTap(gesture: UITapGestureRecognizer) {
        if zoomScale == 1 {
            zoom(to: zoomForScale(scale: 2, center: gesture.location(in: gesture.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
    
    // MARK: - Zoom Rules
    
    /// Calculates the zoom rectangle based on the scale and center point of the zoom
    /// - Parameters:
    ///   - scale: The desired zoom scale
    ///   - center: The center point where the zoom should occur
    /// - Returns: A CGRect representing the zoom area
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
    
    /// Sets up the image view within the scroll view, applying constraints to center it
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
    
    /// Configures the scroll view to enable zooming and sets up gesture recognizers
    private func setupScrollView() {
        minimumZoomScale = 1
        maximumZoomScale = 5
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        delegate = self
        scrollsToTop = false
        
        // Adds double-tap gesture for zooming
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
    }
}

// MARK: - UIScrollViewDelegate

extension MapZoomView: UIScrollViewDelegate {
    
    /// Specifies the view to be zoomed in the scroll view
    /// - Parameter scrollView: The scroll view that is performing the zoom
    /// - Returns: The view to zoom (in this case, the `imageView`)
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

