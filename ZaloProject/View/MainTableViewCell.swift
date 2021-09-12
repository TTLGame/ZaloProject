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
    func populateCell(with dataAPI: [Post], userLike:[Int], index:Int) throws{
    
        guard let url = URL(string: dataAPI[index].imageUrl) else {throw DataError.failToUnwrapItems}
        
        //Read image data
        mainUIImageView.loadImage(imageURL: url , placeholder: "LoadingImage"){ result in
            switch result{
            case DataError.invalidURL?:
                print("Invalid URL")
            default:
                print("Fail to load Image")
            }
        }
       
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

// image Cache
let imageCache = NSCache<AnyObject, UIImage>()
extension UIImageView{
    func loadImage(imageURL: URL,placeholder: String, onError: @escaping (Error?)-> Void) {
        self.image = UIImage(named: placeholder)
        if let cachdImage = imageCache.object(forKey: imageURL as AnyObject){
            self.image = cachdImage
            return
        }
       
        let task = URLSession.shared.dataTask(with: imageURL){
            data, response, error in
            if error == nil{
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data!) else {
                        onError(DataError.invalidURL)
                        return
                    }
                    let newImage = image.resized(withPercentage: 0.1)!
                    imageCache.setObject(newImage, forKey: imageURL as AnyObject)
                    self.image = newImage
                }
            }
        }
        task.resume()
    }
}

//resize image to reduce loading time
extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
