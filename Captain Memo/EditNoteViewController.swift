
import UIKit
import FirebaseFirestore
import FirebaseAuth

class EditNoteViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: DatabaseControllerDelegate?
    
    public var isNewNote : Bool = false
    public var updatedNote : Note = Note(text: " ")
    
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
            noteTextField.text = updatedNote.text
            self.title = "UPDATE A MEMO"
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if isNewNote {
            let note = Note(text: noteTextField.text!)
            delegate?.saveNote(self, newNote: note)
        } else {
            updatedNote.text = noteTextField.text!
            delegate?.updateNote(self, updatedNote: updatedNote)
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
