//
//  ShiftDetailViewController.swift
//  ShiftManager
//
//  Created by Sye Boddeus.
//  Copyright © 2020 Deputy. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

final class ShiftDetailViewController: UIViewController {

    lazy var stack: UIStackView = {
        return UIStackView()
    }()

    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.addTarget(self, action: #selector(endShift(_:)), for: .touchDown)
        button.isHidden = true
        return button
    }()

    lazy var map: MKMapView = {
        let map = MKMapView()
        map.isHidden = true
        map.delegate = self
        return map
    }()

    lazy var titleLabel: UILabel = {
        return UILabel()
    }()

    lazy var subtitleLabel: UILabel = {
        return UILabel()
    }()

    lazy var image: UIImageView = {
        return UIImageView()
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildViews()
        buildLayout()
    }

    // MARK: - View Building and Layout

    func buildViews() {
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.addArrangedSubview(image)
        stack.addArrangedSubview(map)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        stack.addArrangedSubview(actionButton)

        view.addSubview(stack)
    }

    func buildLayout() {
        map.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(LayoutConstants.inset)
        }
    }

    // MARK: View Model Configuration
    private var viewModel: ShiftDetailViewModel?
    func configure(withViewModel vm: ShiftDetailViewModel?) {
        viewModel = vm

        titleLabel.text = vm?.title
        subtitleLabel.text = vm?.detail
        image.sd_setImage(with: vm?.image)

        if let buttonText = vm?.button {
            actionButton.isHidden = false
            actionButton.setTitle(buttonText, for: .normal)
        } else {
            actionButton.isHidden = true
        }

        if let vm = vm {
            dropPin(vm: vm)
            map.isHidden = false
        } else {
            map.isHidden = true
        }
    }

    private func dropPin(vm: ShiftDetailViewModel?) {
        map.removeAnnotations(map.annotations)
        if let end = vm?.endLocation {
            map.addAnnotation(MapPin(title: "End",
                                     locationName: "Shift",
                                     coordinate: end))
        }

        if let start = vm?.startLocation {
            map.addAnnotation(MapPin(title: "Start",
                                     locationName: "Shift",
                                     coordinate: start))
        }
        map.showAnnotations(map.annotations, animated: true)
    }

    // MARK: - Button Actions
    @objc
    func endShift(_ sender: Any) {
        viewModel?.end()
    }
}

// MARK: - Delegates

extension ShiftDetailViewController: MKMapViewDelegate {
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

      let identifier = "Pin"
      let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)

      annotationView.canShowCallout = true
      if annotation is MKUserLocation {
         return nil
      } else if annotation is MapPin {
        annotationView.image =  UIImage(systemName: "mappin")?.withTintColor(.systemRed)
         return annotationView
      } else {
         return nil
      }
   }
}

// MARK: - Display Helpers

class MapPin: NSObject, MKAnnotation {
   let title: String?
   let locationName: String
   let coordinate: CLLocationCoordinate2D
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
      self.title = title
      self.locationName = locationName
      self.coordinate = coordinate
   }
}
