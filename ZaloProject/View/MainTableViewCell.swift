//
//  MainTableViewCell.swift
//  ZaloProject
//
//  Created by geotech on 11/09/2021.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var mainUIImageView: UIImageView!
    @IBOutlet weak var userNameUILabel: UILabel!
    @IBOutlet weak var totalLikesUILabel: UILabel!
    @IBOutlet weak var likeBtnOutlet: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Reuse data
    override func prepareForReuse() {
        super.prepareForReuse()
        userNameUILabel.text = "UserName"
        mainUIImageView.image = UIImage(named: "LoadingImage")
        likeBtnOutlet.setTitle("Like", for: .normal)
        totalLikesUILabel.text = "0 likes"
    }
    //polulateCell
    func populateCell(with dataAPI: [Post], userLike:[Int], index:Int){
        mainUIImageView.image = UIImage(named: "LoadingImage")
        
        guard let url = URL(string: dataAPI[index].imageUrl) else {return}
        mainUIImageView.loadImage(imageURL: url, placeholder: "LoadingImage")
       
        if (userLike[index] == 0){
            likeBtnOutlet.setTitle("Like", for: .normal)
        } else {
            likeBtnOutlet.setTitle("Unlike", for: .normal)
        }
        totalLikesUILabel.text = String(describing: dataAPI[index].totalLikes) + " likes"
        userNameUILabel.text = dataAPI[index].userName
    }
}

// Set identifier
extension UITableViewCell{
    static var identifier: String{
        return String(describing: self)
    }
}
let imageCache = NSCache<AnyObject, UIImage>()
extension UIImageView{
    func loadImage(imageURL: URL,placeholder: String){
        self.image = UIImage(named: placeholder)
        if let cachdImage = imageCache.object(forKey: imageURL as AnyObject){
            self.image = cachdImage
            return
        }
        let task = URLSession.shared.dataTask(with: imageURL){
            data, response, error in
            if error == nil{
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data!) else {return}
                    imageCache.setObject(image, forKey: imageURL as AnyObject)
                    self.image = image
                }
            }
        }
        task.resume()
    }
}
