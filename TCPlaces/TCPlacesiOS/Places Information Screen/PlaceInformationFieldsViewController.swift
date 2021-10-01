//
//  PlaceInformationFieldsViewController.swift
//  TCPlacesiOS
//
//  Created by Suhayl Ahmed on 13/09/2021.
//

import UIKit
import TCPlaces

class PlaceInformationFieldsViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    private let placeLabel = UILabel(text: "Place", font: .preferredFont(forTextStyle: .body), textAlignment: .right)
    private let populationLabel = UILabel(text: "Population", font: .preferredFont(forTextStyle: .body), textAlignment: .right)
    private let currencyLabel = UILabel(text: "Currency", font: .preferredFont(forTextStyle: .body), textAlignment: .right)
    private let dateLabel = UILabel(text: "Date", font: .preferredFont(forTextStyle: .body), textAlignment: .right)
    
    private lazy var labelsStackView = UIStackView(arrangedSubviews: [placeLabel, populationLabel, currencyLabel, dateLabel])
    
    private let placeTextField = UITextField(placeholder: "Place")
    private let populationTextField = UITextField(placeholder: "Population", keyboardType: .numberPad)
    private let currencyTextField = UITextField(placeholder: "Currency")
    private let datePicker = UIDatePicker()
    
    private lazy var fieldsStackView = UIStackView(arrangedSubviews: [placeTextField, populationTextField, currencyTextField, datePicker])
    
    private lazy var mainStackView = UIStackView(arrangedSubviews: [labelsStackView, fieldsStackView])
    
    private let viewModel: PlaceViewModel
    
    private let client = URLSessionHTTPClient()
    private var uploader: RemotePlaceUploader?
    
    var updateCompleted: ((RemotePlaceUploader.Result) -> Void)?
    
    init(viewModel: PlaceViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureInitialFieldValues()
    }
    
    func updateData() {
        let fieldData = getFieldData()
        let request = AirslipPlacesAPIURLRequestBuilder.createDemographicsURLRequest(place: fieldData.place, population: fieldData.population, currency: fieldData.currency, date: fieldData.date)
        uploader = RemotePlaceUploader(urlRequest: request, client: client)
        
        uploader?.upload { [weak self] result in
            guard let self = self else { return }
            
            self.updateCompleted?(result)
        }
    }
    
    private func getFieldData() -> (place: String, population: Int, currency: String, date: Date) {
        let place = placeTextField.text ?? ""
        let currency = currencyTextField.text ?? ""
        let date = datePicker.date
        
        guard let populationText = populationTextField.text else {
            return (place, 0, currency, date)
        }
        
        let population: Int = populationText.isEmpty ? 0 : Int(populationText)!
        
        return (place, population, currency, date)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemGray6
        
        configureLabelsAndInputFieldStackViews()
        configureLabelsAndFields()
    }
    
    private func configureInitialFieldValues() {
        placeTextField.text = viewModel.placeName
        populationTextField.text = "\(viewModel.population)"
        currencyTextField.text = viewModel.currency
        datePicker.date = viewModel.date
    }
    
    private func configureLabelsAndInputFieldStackViews() {
        configureStackView(labelsStackView, axis: .vertical, spacing: 10)
        configureStackView(fieldsStackView, axis: .vertical, spacing: 10)
        configureStackView(mainStackView, axis: .horizontal, spacing: 10)
        
        mainStackView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        
        view.addSubview(mainStackView)
        mainStackView.fillSuperview()
    }
    
    private func configureStackView(_ stackView: UIStackView, axis: NSLayoutConstraint.Axis, spacing: CGFloat, backgroundColor: UIColor = .systemBackground) {
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.backgroundColor = backgroundColor
    }
    
    private func configureLabelsAndFields() {
        labelsStackView.arrangedSubviews.forEach { $0.constrainHeight(constant: datePicker.frame.height) }
        fieldsStackView.arrangedSubviews.forEach { $0.constrainHeight(constant: datePicker.frame.height) }
        [placeTextField, populationTextField, currencyTextField].forEach { $0.delegate = self }
    }
    
}

extension PlaceInformationFieldsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
