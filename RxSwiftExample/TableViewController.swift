//
//  TableViewController.swift
//  RxSwiftExample
//
//  Created by ronatory on 26.09.16.
//  Copyright © 2016 ronatory. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TableViewController: UITableViewController {
	
	@IBOutlet weak var searchBar: UISearchBar!
	
	var shownCities = [String]() // Data source for UITableView
	let allCities = ["New York", "London", "Oslo", "Warsaw", "Frankfurt", "Prag", "Berlin", "Philadelphia", "Sao Paulo", "Milan", "Manila", "Tokio", "Los Angeles", "Paris", "Portland"] // Mocked API data
	let disposeBag = DisposeBag() // Bag of disposables to release them when view is being deallocated (protect agains retain cycle)

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Search Cities"
		
		tableView.dataSource = self
		
		searchBar
			.rx_text // observable property
			.throttle(0.5, scheduler: MainScheduler.instance) // wait 0.5 seconds for changes
			.distinctUntilChanged() // check if the new value is the same as the old one
			.filter { $0.characters.count > 0 } // filter for a non-empty query
			.subscribeNext { [unowned self] (query) in // get notified of every new value
				self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // do the "API Request" to find cities
				self.tableView.reloadData() // reload data in table view
			}
			.addDisposableTo(disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shownCities.count
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cityCell", forIndexPath: indexPath)

        cell.textLabel?.text = shownCities[indexPath.row]

        return cell
    }

}
