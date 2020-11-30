//
//  ViewController.swift
//  ARBasicSetUp
//
//  Created by Ajithram on 30/11/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapButton(_ sender: UIButton) {
        let viewWithTableView = ViewController2()
        viewWithTableView.modalPresentationStyle = .fullScreen
        self.present(viewWithTableView, animated: true, completion: nil)
//        makeApiService()
//        presentCustomBrowser()
    }
    
    func makeApiService() {
        let openWeatherUrl = "https://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b6907d289e10d714a6e88b30761fae22"
        RemoteDataApiManager.dataApiServiceCall(baseUrl: "", endPoint: openWeatherUrl, method: .GET) { (data) in
            print(String(decoding: data, as: UTF8.self))
        } failure: { (err) in
            print(err)
        }
    }
    
    func presentCustomBrowser() {
        let customWebBrowser = CustomBrowser()
        customWebBrowser.url = "https://www.google.com/"
        let navigationController = UINavigationController(rootViewController: customWebBrowser)
        self.present(navigationController, animated: true, completion: nil)
    }
    
}

class ViewController2: CustomTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func handler(_ handler: TableViewHandler, registerTableViewCells tableView: UITableView) {
        tableView.register(UINib(nibName: "SingleLabelCell", bundle: nil), forCellReuseIdentifier: "SingleLabelCell")
    }
    
    override func prepareDataSourceForHandler(_ handler: TableViewHandler) -> [TableViewCellData] {
        var dataSource = [TableViewCellData]()
        dataSource.append(TableViewCellData("SingleLabelCell", data: LabelConstraints(leadingAndTrailingSpace: 12, topSpace: 12, bottomSpace: 12, labelData: "Sample", cellBackgroundColor: .clear) as Any))
        dataSource.append(TableViewCellData("SingleLabelCell", data: ""))
        dataSource.append(TableViewCellData("SingleLabelCell", data: ""))
        dataSource.append(TableViewCellData("SingleLabelCell", data: ""))

        return dataSource
    }
    
    
    override func handler(_ handler: TableViewHandler, didActionHappenedAt sender: Any?, cell: UITableViewCell) {
        print(cell.reuseIdentifier)
    }
    
}
