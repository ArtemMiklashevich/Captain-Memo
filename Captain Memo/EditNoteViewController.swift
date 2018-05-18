
import UIKit
import FirebaseFirestore
import FirebaseAuth

class EditNoteViewController: UIViewController, UITextViewDelegate {
    
    weak var delegate: DatabaseControllerDelegate?
    
    public var isNewNote : Bool = false
    public var updatedNote : Note? = nil
    
    @IBOutlet var doneButton: UIBarButtonItem!
  
    @IBOutlet weak var noteTextView: UITextView!
    
    func textViewDidChange(_ textView: UITextView) {
        updateSubmitButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false
        noteTextView.delegate = self
        if isNewNote {
            noteTextView.text = ""
            self.title = "ADD A MEMO"
        } else {
            if let un = updatedNote {
                noteTextView.text = un.text
            } else {
                noteTextView.text = ""
            }
            self.title = "UPDATE A MEMO"
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if isNewNote {
            let note = Note(id: nil, text: noteTextView.text!, date: nil)
            delegate?.saveNote(self, newNote: note)
        } else {
            if var un = updatedNote {
                un.text = noteTextView.text!
                delegate?.updateNote(self, updatedNote: un)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldIsEmpty() -> Bool {
        guard let text = noteTextView.text else { return true }
        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func updateSubmitButton() {
        doneButton.isEnabled = !textFieldIsEmpty()
    }
}
