//
//  SecondViewController.swift
//  jenniferbuur_pset3
//
//  Created by Jennifer Buur on 27-02-17.
//  Copyright © 2017 Jennifer Buur. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var movie: String?
    var year: String?
    var plot: String?
    var genre: String?
    var poster: UIImage?
    
    @IBOutlet var posterView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var genreLabel: UITextView!
    @IBOutlet var plotView: UITextView!
    
    @IBOutlet var upperView: UIView!
    @IBOutlet var lowerView: UIView!
    
    override func viewWillLayoutSubviews() {
        if self.view.bounds.width > self.view.bounds.height {
            self.lowerView.frame.size.width = 0.5 * self.view.bounds.width
            self.lowerView.frame.origin.x = 0.5 * self.view.bounds.width
            self.lowerView.frame.origin.y = 64
            self.lowerView.frame.size.height = self.view.bounds.height - 64
            self.upperView.frame.origin.x = 0
            self.upperView.frame.origin.y = 64
            self.upperView.frame.size.width = 0.5 * self.view.bounds.width
            self.upperView.frame.size.height = self.view.bounds.height - 64
        }
        else {
            self.lowerView.frame.size.height = 0.5 * self.view.bounds.height
            self.lowerView.frame.origin.x = 0
            self.lowerView.frame.origin.y = 0.5 * self.view.bounds.height
            self.lowerView.frame.size.width = self.view.bounds.width
            self.upperView.frame.origin.x = 0
            self.upperView.frame.origin.y = 64
            self.upperView.frame.size.height = 0.5 * self.view.bounds.height - 64
            self.upperView.frame.size.width = self.view.bounds.width
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterView.image = poster
        titleLabel.text = movie
        yearLabel.text = year
        genreLabel.text = genre
        plotView.text = plot

        // Do any additional setup after loading the view.
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
