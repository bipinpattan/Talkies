//
//  DetailViewController.swift
//  Talkies
//
//  Created by Bipin Pattan on 10/15/16.
//  Copyright © 2016 Bipin Pattan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupUI() {
        print(movie)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.infoView.frame.origin.y + self.infoView.frame.size.height)
        self.titleLabel.text = self.movie.value(forKey: "title") as! String?
        self.overviewLabel.text = self.movie.value(forKey: "overview") as! String?
        self.overviewLabel.sizeToFit()
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie.value(forKey: "poster_path") as! String? {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            self.posterImageView?.setImageWith(imageUrl as! URL)
        }
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
