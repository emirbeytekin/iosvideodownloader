
import UIKit

@objc protocol UTextFieldDelegate {
    
    func uBeginEditing()
    func uEndEditing()
    func uShouldReturn(textField: UITextField)
}

enum KeyboardType: Int {
    case Default
    case Email
    case Number
    case Password
}

@IBDesignable class UTextField: UIView, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var seperator: UIView!

    @IBOutlet weak var view: UIView!
    
    @IBOutlet var delegate: AnyObject?
    

    @IBInspectable var placeholder: String = "Placeholder" {
        
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    @IBInspectable var activeColor: UIColor = UIColor.uActiveTextColor() {

        didSet {
            seperator.backgroundColor = activeColor
            textField.tintColor = activeColor
        }

    }
    
    @IBInspectable var inactiveColor: UIColor = UIColor.uGrayColor() {
        
        didSet {
            seperator.backgroundColor = inactiveColor
            textField.tintColor = inactiveColor
        }
    }
    
    
    @IBInspectable var keyboardType: Int = 0 {
        
        didSet {

            switch keyboardType {
            case 0:
                
                textField.keyboardType = .default
                textField.autocapitalizationType = .words
                
                break;
            case 1:
                
                textField.keyboardType = .emailAddress
                textField.autocapitalizationType = .none

                break;
            case 2:
                
                textField.keyboardType = .numbersAndPunctuation
                textField.autocapitalizationType = .none

                break;
            case 3:
                
                textField.keyboardType = .default
                textField.autocapitalizationType = .none
                textField.isSecureTextEntry = true
                
                break;
            
            case 4:
                textField.keyboardType = .numberPad
                textField.autocapitalizationType = .none
            default:
                
                textField.keyboardType = .default
                textField.autocapitalizationType = .words

                break;
            }
        
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clear
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.tintColor = activeColor
        seperator.backgroundColor = activeColor
        
        delegate?.uBeginEditing()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
     
        textField.tintColor = inactiveColor
        seperator.backgroundColor = inactiveColor

        delegate?.uEndEditing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        delegate?.uShouldReturn(textField: textField)
        
        return true
    }
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    func countText(_ textField: UITextField) -> Int {
        
        return (textField.text?.characters.count)!
        
    }
    
    func makeEffect() {
        
        self.activeColor = UIColor.uRedColor()
        self.textField.backgroundColor = UIColor.uBlankInput()
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.textField.backgroundColor = UIColor.white
        }, completion: nil)
        
        
    }
    
    func resetEffect() {
        self.activeColor = inactiveColor
        textField.tintColor = inactiveColor
        seperator.backgroundColor = inactiveColor
    }
    
}
