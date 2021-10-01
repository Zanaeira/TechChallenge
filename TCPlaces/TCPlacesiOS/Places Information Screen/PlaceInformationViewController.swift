//
//  PlaceInformationViewController.swift
//  TCPlacesiOS
//
//  Created by Suhayl Ahmed on 13/09/2021.
//

import UIKit
import TCPlaces

public final class PlaceInformationViewController: UIViewController {
    
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let placeInformationFieldsViewController: PlaceInformationFieldsViewController
    private let updateDataButton = UIButton()
    private let updateLabel = UILabel(text: "", font: .preferredFont(forTextStyle: .headline))
    
    private let viewModel: PlaceViewModel
    
    init(viewModel: PlaceViewModel) {
        self.viewModel = viewModel
        self.placeInformationFieldsViewController = PlaceInformationFieldsViewController(viewModel: viewModel)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        placeInformationFieldsViewController.updateCompleted = handleUpdateCompletion
        configureKeyboardDismissal()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemGray6
        
        configurePlaceInformationFieldsViewController()
        configureUpdateDataButton()
        configureUpdateLabel()
    }
    
    private func configurePlaceInformationFieldsViewController() {
        add(placeInformationFieldsViewController)
        
        let safeArea = view.safeAreaLayoutGuide
        placeInformationFieldsViewController.view.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: .init(top: 32, left: 32, bottom: 0, right: 32))
    }
    
    private func configureKeyboardDismissal() {
        let tapRecognizer = UITapGestureRecognizer()
        guard let view = view else { return }
        tapRecognizer.addTarget(view, action: #selector(view.endEditing))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    private func configureUpdateDataButton() {
        updateDataButton.setTitle("Update", for: .normal)
        updateDataButton.setTitleColor(.label, for: .normal)
        updateDataButton.contentEdgeInsets = .init(top: 16, left: 40, bottom: 16, right: 40)
        updateDataButton.layer.cornerRadius = 8
        updateDataButton.backgroundColor = .systemBackground
        updateDataButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        updateDataButton.addTarget(self, action: #selector(updateData), for: .touchUpInside)
        
        view.addSubview(updateDataButton)
        updateDataButton.centerXInSuperview()
        updateDataButton.anchor(top: placeInformationFieldsViewController.view.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    @objc private func updateData() {
        placeInformationFieldsViewController.updateData()
    }
    
    private func configureUpdateLabel() {
        view.addSubview(updateLabel)
        updateLabel.numberOfLines = 0
        updateLabel.sizeToFit()
        updateLabel.centerXInSuperview()
        updateLabel.anchor(top: updateDataButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    private func handleUpdateCompletion(result: RemotePlaceUploader.Result) {
        DispatchQueue.main.async {
            switch result {
            case .success:
                self.updateLabel.textColor = .systemGreen
                self.updateLabel.text = "Update succeeded"
            case .failure:
                self.updateLabel.textColor = .systemRed
                self.updateLabel.text = "Something went wrong. Please try again later."
            }
        }
    }
    
}
