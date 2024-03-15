//
//  EventsVisualizerHomeController.swift
//  Launchpad
//
//  Created by Rishav Gupta on 25/03/22.
//  Copyright © 2022 PT GoJek Indonesia. All rights reserved.
//


import Clickstream
import UIKit

protocol EventsTrackerWindowDelegate: AnyObject {
    func shouldReactForPoint(_ point: CGPoint) -> Bool
}

final class EventsTrackerWindow: UIWindow {
    
    weak var delegate: EventsTrackerWindowDelegate?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var pointInside: Bool = false
        if delegate?.shouldReactForPoint(point) == true {
            pointInside = super.point(inside: point, with: event)
        }
        return pointInside
    }
}

final class EventsVisualizerHomeController: UIViewController {

    private let analyticsFabView: UIView = UIView()
    private let eventsView: UIView = UIView()
    private let eventsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapHandling()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showButton()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

private extension EventsVisualizerHomeController {
    func setupUI() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0)

        view.addSubview(analyticsFabView)
        analyticsFabView.addSubview(eventsView)
        analyticsFabView.addSubview(eventsLabel)
        NSLayoutConstraint.activate([
            analyticsFabView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            analyticsFabView.heightAnchor.constraint(equalToConstant: 72),
            analyticsFabView.widthAnchor.constraint(equalToConstant: 72),
            analyticsFabView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            eventsView.trailingAnchor.constraint(equalTo: analyticsFabView.trailingAnchor),
            eventsView.heightAnchor.constraint(equalTo: analyticsFabView.heightAnchor),
            eventsView.widthAnchor.constraint(equalTo: analyticsFabView.widthAnchor),
            eventsView.bottomAnchor.constraint(equalTo: analyticsFabView.bottomAnchor),
            eventsLabel.trailingAnchor.constraint(equalTo: eventsView.trailingAnchor),
            eventsLabel.heightAnchor.constraint(equalTo: eventsView.heightAnchor),
            eventsLabel.widthAnchor.constraint(equalTo: eventsView.widthAnchor),
            eventsLabel.bottomAnchor.constraint(equalTo: eventsView.bottomAnchor)
        ])
        
        analyticsFabView.translatesAutoresizingMaskIntoConstraints = false
        eventsView.translatesAutoresizingMaskIntoConstraints = false
        eventsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        eventsLabel.text = "Event Visualizer"
        eventsLabel.numberOfLines = 2
        eventsLabel.textAlignment = .center
        eventsLabel.font = UIFont.systemFont(ofSize: 12)
        
        analyticsFabView.isOpaque = false
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        
        eventsView.backgroundColor = .gray
        eventsView.isOpaque = true
        eventsView.layer.cornerRadius = 14
        eventsView.layer.shadowColor = UIColor.gray.cgColor
        eventsView.layer.shadowOpacity = 0.5
        eventsView.layer.shadowRadius = 1
        eventsView.layer.shadowOffset = CGSize(width: 5, height: -2)
        eventsView.clipsToBounds = true
        eventsView.layer.masksToBounds = false
        eventsView.layer.shadowPath = UIBezierPath(roundedRect: eventsView.bounds, cornerRadius: eventsView.layer.cornerRadius).cgPath
    }
    
    func setupTapHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleButtonTap))
        tapGesture.numberOfTouchesRequired = 1
        analyticsFabView.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(closeWindow))
        longPressGesture.numberOfTouchesRequired = 1
        analyticsFabView.addGestureRecognizer(longPressGesture)
        
        analyticsFabView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handler)))
    }
    
    @objc func handler(gesture: UIPanGestureRecognizer){
        let location = gesture.location(in: self.view)
        let draggedView = gesture.view
        draggedView?.center = location
        
        if gesture.state == .ended {
            if self.analyticsFabView.frame.midX >= self.view.layer.frame.width / 2 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.analyticsFabView.center.x = self.view.layer.frame.width - 40
                }, completion: nil)
            }else{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                    self.analyticsFabView.center.x = 40
                }, completion: nil)
            }
        }
    }
    
    func changeButtonColor(state: Bool) {
        if state {
            eventsView.backgroundColor = .systemGreen
        } else {
            eventsView.backgroundColor = .gray
        }
    }
    
    @objc
    func handleButtonTap() {
        animateButton { [weak self] in
            self?.openAnalyticsScreen()
        }
    }
    
    func animateButton(_ completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            self?.analyticsFabView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (_) in
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.analyticsFabView.transform = CGAffineTransform.identity
            }) { (_) in
                completion?()
            }
        }
    }
    
    func showButton() {
        analyticsFabView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.1,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: { [weak self] in
                self?.analyticsFabView.transform = CGAffineTransform.identity
            },
            completion: nil
        )
    }
    
    @objc
    func closeWindow() {
        let alert = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .actionSheet)
        let startCapturing = UIAlertAction(title: "Start capturing", style: .default) { (_) in
            EventsHelper.shared.startCapturing()
            self.changeButtonColor(state: true)
        }
        let stopCapturing = UIAlertAction(title: "Stop capturing", style: .destructive) { [unowned self] (_) in
            EventsHelper.shared.stopCapturing()
            self.changeButtonColor(state: false)
        }
        let closeAction = UIAlertAction(title: "Close the widget", style: .destructive) { (_) in
            EventsHelper.shared.stopCapturing()
            AnalyticsManager.eventsWindow = nil
        }
        let clearAction = UIAlertAction(title: "Clear events data", style: .default) { (_) in
            EventsHelper.shared.clearData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(startCapturing)
        alert.addAction(stopCapturing)
        alert.addAction(clearAction)
        alert.addAction(closeAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func openAnalyticsScreen() {
        let viewController = EventVisualizerLandingViewController()
        viewController.hidesBottomBarWhenPushed = true
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.modalPresentationStyle = .overCurrentContext
        navVC.navigationBar.barTintColor = UIColor.white
        navVC.navigationBar.tintColor = UIColor.black
        self.present(navVC, animated: true, completion: nil)
    }
}

extension EventsVisualizerHomeController: EventsTrackerWindowDelegate {
    func shouldReactForPoint(_ point: CGPoint) -> Bool {
        guard presentedViewController == nil else { return true }
        return analyticsFabView.frame.contains(point)
    }
}
