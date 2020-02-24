//
//  FormsViewController.swift
//  HandZap
//
//  Created by Chandra Rao on 24/02/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

public protocol FormsListingProtocol {
    func appendFormsData(withData data: FormsData?)
}

class FormsViewController: UIViewController {
    
    var delegate: FormsListingProtocol?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var txtFieldTitle: SkyFloatingLabelTextField!
    @IBOutlet weak var lblRequiredTitle: UILabel!
    
    @IBOutlet weak var txtFieldDescription: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFieldBudget: SkyFloatingLabelTextField!
    @IBOutlet weak var lblRequiredBudget: UILabel!
    
    @IBOutlet weak var txtFieldCurrency: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var txtFieldRate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFieldPaymentMethod: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFieldStartDate: SkyFloatingLabelTextField!
    @IBOutlet weak var lblRequiredStartDate: UILabel!
    
    @IBOutlet weak var txtFieldJobTerm: SkyFloatingLabelTextField!
    
    var ratePicker: UIPickerView!
    var rates: [String] = [
        "No Preference",
        "Fixed Budget",
        "Hourly Rate"
    ]
    
    var paymentMethodPicker: UIPickerView!
    var methods: [String] = [
        "No Preference",
        "E-Payment",
        "Cash"
    ]
    
    var jobTermPicker: UIPickerView!
    var jobTerms: [String] = [
        "No Preference",
        "Recurring Job",
        "Same Day Job",
        "Multi Day Job"
    ]
    
    let datePickerStartDate : UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUpUI() {
        DispatchQueue.main.async {
            self.title = "New Form"
            self.navigationController?.navigationBar.backItem?.title = ""
            
            let send = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(self.sendTapped))
            self.navigationItem.rightBarButtonItems = [send]
            
            self.setUpRatePickerValue()
            self.setUpPaymentPickerValue()
            self.setUpJobTermsPickerValue()
            self.setUpStartDatePicker()
        }
    }
    
    @objc func sendTapped() {
        if validateIfEmptyValue(forTextField: self.txtFieldTitle) {
            setUpErrorType(forTextField: self.txtFieldTitle)
            showAlertWithText(withText: "Please Enter Form Title")
        } else if validateIfEmptyValue(forTextField: self.txtFieldBudget) {
            setUpErrorType(forTextField: self.txtFieldBudget)
            showAlertWithText(withText: "Please Enter Budget")
        } else if validateIfEmptyValue(forTextField: self.txtFieldStartDate) {
            setUpErrorType(forTextField: self.txtFieldStartDate)
            showAlertWithText(withText: "Please Enter Start Date")
        } else {
            if let vcDelegate = self.delegate {
                vcDelegate.appendFormsData(withData: FormsData(title: txtFieldTitle.text, desc: txtFieldDescription.text, budget: txtFieldBudget.text, currency: txtFieldCurrency.text, rate: txtFieldRate.text, paymentMethod: txtFieldPaymentMethod.text, startDate: txtFieldStartDate.text, jobTerm: txtFieldJobTerm.text))
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func validateIfEmptyValue(forTextField textfield: UITextField) -> Bool {
        if let text = textfield.text, text.count == 0 {
            return true
        }
        return false
    }
    
    func showAlertWithText(withText text: String) {
        let alertController = UIAlertController(title:"HandZap", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
        })
        alertController.addAction(okAction)
        self.navigationController?.present(alertController, animated: true, completion: {
            
        })
    }
    
    func setUpRatePickerValue() {
        self.ratePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
        self.ratePicker.delegate = self
        self.txtFieldRate.inputView = self.ratePicker
    }
    
    func setUpPaymentPickerValue() {
        self.paymentMethodPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
        self.paymentMethodPicker.delegate = self
        self.txtFieldPaymentMethod.inputView = self.paymentMethodPicker
    }
    
    func setUpJobTermsPickerValue() {
        self.jobTermPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
        self.jobTermPicker.delegate = self
        self.txtFieldJobTerm.inputView = self.jobTermPicker
    }
    
    func setUpStartDatePicker() {
        datePickerStartDate.datePickerMode = UIDatePicker.Mode.date
        datePickerStartDate.maximumDate = Date()
        datePickerStartDate.addTarget(self, action: #selector(setToDate), for: .valueChanged)
        
        self.txtFieldStartDate.inputView = datePickerStartDate
    }
    
    @objc func setToDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd" // Output Formated
        self.txtFieldStartDate.text = dateFormatter.string(from: datePickerStartDate.date)
    }
    
    func setUpErrorType(forTextField textField: SkyFloatingLabelTextField) {
        if textField == self.txtFieldTitle {
            self.lblRequiredTitle.textColor = UIColor.red
        } else if textField == self.txtFieldBudget {
            self.lblRequiredBudget.textColor = UIColor.red
        } else if textField == self.txtFieldStartDate {
            self.lblRequiredStartDate.textColor = UIColor.red
        }
        textField.lineColor = UIColor.red
    }
}

extension FormsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.ratePicker {
            return rates.count
        } else if pickerView == self.paymentMethodPicker {
            return methods.count
        } else if pickerView == self.jobTermPicker {
            return jobTerms.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.ratePicker {
            return rates[row]
        } else if pickerView == self.paymentMethodPicker {
            return methods[row]
        } else if pickerView == self.jobTermPicker {
            return jobTerms[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.ratePicker {
            self.txtFieldRate.text = rates[row]
        } else if pickerView == self.paymentMethodPicker {
            self.txtFieldPaymentMethod.text = methods[row]
        } else if pickerView == self.jobTermPicker {
            self.txtFieldJobTerm.text = jobTerms[row]
        }
    }
}

extension FormsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtFieldTitle {
            txtFieldTitle.lineColor = self.txtFieldDescription.lineColor
            self.lblRequiredTitle.textColor = UIColor(red: 130.0/255.0, green: 130.0/255.0, blue: 130.0/255.0, alpha: 1.0)
        } else if textField == self.txtFieldBudget {
            txtFieldBudget.lineColor = self.txtFieldDescription.lineColor
            self.lblRequiredBudget.textColor = UIColor(red: 130.0/255.0, green: 130.0/255.0, blue: 130.0/255.0, alpha: 1.0)
        } else if textField == self.txtFieldStartDate {
            txtFieldStartDate.lineColor = self.txtFieldDescription.lineColor
            self.lblRequiredStartDate.textColor = UIColor(red: 130.0/255.0, green: 130.0/255.0, blue: 130.0/255.0, alpha: 1.0)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtFieldTitle {
            if string == "" {
                self.lblRequiredTitle.text = "\(75 - (textField.text?.count ?? 0)) charecters left"
                return true
            }
            if let text = textField.text {
                if text.count >= 75 {
                    self.lblRequiredTitle.text = "0 charecters left"
                    return false
                } else if text.count > 0 {
                    self.lblRequiredTitle.text = "\(75 - text.count) charecters left"
                } else {
                    self.lblRequiredTitle.text = "Required"
                }
            }
        }
        return true
    }
}

extension FormsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell {
            cell.configureUI()
            return cell
        }
        return UICollectionViewCell()
    }
}
