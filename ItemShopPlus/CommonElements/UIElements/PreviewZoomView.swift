//
//  NewPreviewZoomView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.04.2024.
//

import UIKit
import Kingfisher

/// Protocol to notify when the zoomable view is dismissed
protocol ShopGrantedPanZoomViewDelegate: AnyObject {
    func didDismiss()
}

/// A custom view that allows users to zoom and pan on a preview image with additional dismiss gesture support
final class PreviewZoomView: UIView {
    
    // MARK: - Properties
    
    /// The scroll view that allows zooming and panning of the image
    private var scrollView: UIScrollView!
    /// The image view that displays the preview image
    private var imageView: UIImageView!
    /// The download task for loading the image from a URL
    private var imageLoadTask: DownloadTask?
    /// The maximum zoom level for the image
    private var zoom: Double = 2
    
    /// Delegate to handle the dismissal action
    weak var panZoomDelegate: ShopGrantedPanZoomViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Convenience initializer for creating the view with a zoomable image
    /// - Parameters:
    ///   - image: The URL string of the image to load
    ///   - presentingViewController: The view controller presenting the zoom view
    ///   - size: The size for the loaded image (default is 1024x1024)
    ///   - zoom: The maximum zoom scale (default is 2x)
    convenience init(image: String, presentingViewController: UIViewController, size: CGSize = CGSize(width: 1024, height: 1024), zoom: Double = 2) {
        self.init(frame: .zero)
        self.zoom = zoom
        
        setupScrollView()
        setupImageView()
        setupDoubleTapGesture()
        setupPanGesture()
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: imageView, size: size)
    }
    
    /// Sets the frame of the scroll view and image view when the layout changes
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
        imageView.frame = self.bounds
    }
    
    // MARK: - Gesture Handling
    
    /// Handles the double-tap gesture to zoom in or out
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else if scrollView.zoomScale < scrollView.maximumZoomScale {
            let zoomRect = zoomRectForScale(scale: scrollView.maximumZoomScale, center: gesture.location(in: gesture.view))
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    /// Handles the pan gesture to dismiss the view when the user swipes down
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        if translation.y > 0 && scrollView.contentOffset.y <= 0 {
            switch gesture.state {
            case .changed:
                self.transform = CGAffineTransform(translationX: 0, y: translation.y)
                let alpha = 1 - abs(translation.y) / frame.height * 2
                imageView.alpha = alpha
            case .ended, .cancelled:
                if translation.y > 100 {
                    panZoomDelegate?.didDismiss()
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.transform = .identity
                        self.imageView.alpha = 1
                    }
                }
            default:
                break
            }
        }
    }
    
    // MARK: - Setup Methods
    
    /// Sets up the double-tap gesture recognizer for zooming
    private func setupDoubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTapGesture)
    }
    
    /// Sets up the pan gesture recognizer for dismissing the view
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        scrollView.addGestureRecognizer(panGesture)
    }
    
    /// Sets up the scroll view that allows zooming and panning
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = zoom
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .scrollableAxes
        addSubview(scrollView)
    }
    
    /// Sets up the image view that displays the preview image
    private func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        scrollView.addSubview(imageView)
    }
    
    // MARK: - Zoom Calculation
    
    /// Calculates the zoom rect for a given zoom scale and center point
    /// - Parameters:
    ///   - scale: The desired zoom scale
    ///   - center: The center point to zoom into
    /// - Returns: The rectangle to zoom to
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect()
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    /// Sets the displayed image in the image view
    /// - Parameter image: The image to display
    internal func setImage(_ image: UIImage) {
        imageView.image = image
        imageView.sizeToFit()
        centerImageView()
    }
    
    // MARK: - Centering and Insets
    
    /// Centers the image view within the scroll view when zoomed out
    private func centerImageView() {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX,
                                   y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
    /// Updates the content insets of the scroll view when the image is zoomed out
    private func updateContentInsets() {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalInset = (scrollViewSize.height - imageViewSize.height) / 2
        
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: 0, bottom: verticalInset, right: 0)
    }
}

// MARK: - UIScrollViewDelegate

extension PreviewZoomView: UIScrollViewDelegate {
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    internal func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageView()
        updateContentInsets()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension PreviewZoomView: UIGestureRecognizerDelegate {
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
