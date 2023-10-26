
import UIKit

class FurnitureDetailViewController: UIViewController {
    
    var furniture: Furniture?
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var choosePhotoButton: UIButton!
    @IBOutlet var furnitureTitleLabel: UILabel!
    @IBOutlet var furnitureDescriptionLabel: UILabel!
    
    init?(coder: NSCoder, furniture: Furniture?) {
        self.furniture = furniture
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    func updateView() {
        guard let furniture = furniture else {return}
        if let imageData = furniture.imageData,
            let image = UIImage(data: imageData) {
            photoImageView.image = image
        } else {
            photoImageView.image = nil
        }
        
        furnitureTitleLabel.text = furniture.name
        furnitureDescriptionLabel.text = furniture.description
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        let data = selectedImage.jpegData(compressionQuality: 9)
        furniture?.imageData = data
        
        
        
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil) // what is completion and what is it for? Who are you and who do you work for!?
        updateView()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    
    
    @IBAction func choosePhotoButtonTapped(_ sender: UIButton) { // sender cant be any as the reciever is a UIview?
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self // gotta conform to the delegates, why it isn't initialized as such? IDK...
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil) // wire everything up in the storyboard and then I gotta do this? what gives? lol  // by default buttons will dismiss the alert, so the handler can be nil in the case of cancel action
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "camera", style: .default) {action in // so I guess the type is indexed in some sort? gotta include this in the closure.
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) { // the book is claiming the app would crash without this if statement? do I even need this if statement?
            let photoLibraryAction = UIAlertAction(title: "photoLibrary", style: .default) {_ in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true)
                
            }
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = sender // sender will be UIButton and I'm guessing it's a subclass or property of UIview because that's what PopoverPresentationController controller is
        present(alertController, animated: true)
        
    }
    

    @IBAction func actionButtonTapped(_ sender: UIButton) {
        guard let image = photoImageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image, furniture?.description],  applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true, completion: nil)
        
        
    }
    
}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
}
