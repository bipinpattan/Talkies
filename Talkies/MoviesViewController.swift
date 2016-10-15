//
//  MoviesViewController.swift
//  Talkies
//
//  Created by Bipin Pattan on 10/13/16.
//  Copyright © 2016 Bipin Pattan. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var movies: [NSDictionary]?
    var endPoint: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startNetworkActivity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Delegate callbacks
    // MARK: UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies?.count ?? 0;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        print("Row - \(indexPath.row)")
        let movieInfo = self.movies?[indexPath.row]
        cell.titleLabel?.text = movieInfo?.value(forKey: "original_title") as! String?
        cell.overviewLabel?.text = movieInfo?.value(forKey: "overview") as! String?
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movieInfo?.value(forKey: "poster_path") as! String? {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterImageView?.setImageWith(imageUrl as! URL)
        }
        return cell
    }

    func refreshControlAction(refreshControl: UIRefreshControl) {
        startNetworkActivity()
    }
    
    // MARK:- Helper functions
    private func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(self.refreshControl, at: 0)
    }
    
    private func startNetworkActivity() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/" + self.endPoint + "?api_key=" + apiKey)

        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    self.movies = responseDictionary.value(forKeyPath: "results") as? [NSDictionary]
                    NSLog("Movies: \(self.movies?.count)")
                    Thread.sleep(forTimeInterval: 0.25)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        });
        task.resume()
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = self.tableView.indexPath(for: cell)
        let movie = self.movies![(indexPath?.row)!]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
    }

}
