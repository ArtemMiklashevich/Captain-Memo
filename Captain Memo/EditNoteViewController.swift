
import UIKit
import FirebaseFirestore
import FirebaseAuth

class EditNoteViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: DatabaseControllerDelegate?
    
    public var isNewNote : Bool = false
    public var updatedNote : Note? = nil
    
    @IBOutlet var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var noteTextField: UITextField! {
        didSet {
            noteTextField.addTarget(self, action: #selector(textFieldTextDidChange(_:)), for: .editingChanged)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false
        noteTextField.delegate = self
        if isNewNote {
            noteTextField.text = ""
            self.title = "ADD A MEMO"
        } else {
            if let un = updatedNote {
                noteTextField.text = un.text
            } else {
                noteTextField.text = ""
            }
            self.title = "UPDATE A MEMO"
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if isNewNote {
            let note = Note(id: nil, text: noteTextField.text!, date: nil)
            delegate?.saveNote(self, newNote: note)
        } else {
            if var un = updatedNote {
                un.text = noteTextField.text!
                delegate?.updateNote(self, updatedNote: un)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldIsEmpty() -> Bool {
        guard let text = noteTextField.text else { return true }
        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func updateSubmitButton() {
        doneButton.isEnabled = !textFieldIsEmpty()
    }
    
    @objc func textFieldTextDidChange(_ sender: Any) {
        updateSubmitButton()
    }
}
