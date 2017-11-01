//
//  EditProfileVC.swift
//  W3Chat
//
//  Created by ios2 on 10/12/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate {
    @IBOutlet var UserImage: UIImageView!
    @IBOutlet var ImageBtn: UIButton!
    
    let picker    = UIImagePickerController()
    var chosenImage: UIImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Profile"
        picker.delegate = self

        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "sidemenu"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 10  , height: 10)
        btn1.addTarget(self, action: #selector((SSASideMenu.presentLeftMenuViewController)), for: .touchUpInside)
        
        let item1 = UIBarButtonItem(customView: btn1 )
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)
        

        self.UserImage.layer.cornerRadius = UserImage.frame.height / 2.0
        self.ImageBtn.layer.cornerRadius = ImageBtn.frame.height / 2.0
        self.UserImage.clipsToBounds = true
        self.UserImage.layer.borderWidth = 3
        self.UserImage.layer.borderColor = AppColor.cgColor
        self.UserImage.image = nil
        
    }

  
    
    
    @IBAction func ImageBtn(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
        
    }
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // use the image
        UserImage.contentMode = .scaleAspectFill
        UserImage.image = chosenImage
        
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
