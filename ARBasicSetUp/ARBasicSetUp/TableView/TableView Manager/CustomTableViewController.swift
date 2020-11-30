import UIKit

class CustomTableViewController: UIViewController {
    
    var customTableView: UITableView = UITableView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var tableViewHandler: TableViewHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        createTableView()
        createActivityIndicator()
    }
    
    func initialSetup(){
        print("Load data for TableView before Creation.")
    }
    
    func reloadTableViewData(){
        tableViewHandler?.configureTableview(customTableView)
    }
    
    func createTableView(){
        customTableView.separatorColor = UIColor.clear
        customTableView.rowHeight = UITableView.automaticDimension
        customTableView.estimatedRowHeight = 300
        customTableView.translatesAutoresizingMaskIntoConstraints = false
        tableViewLayoutSetup()
        tableViewHandler = TableViewHandler(self, tableView: customTableView)
    }
    
    func tableViewLayoutSetup(){
        view.addSubview(customTableView)
        NSLayoutConstraint.activate([
            customTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTableView.topAnchor.constraint(equalTo: view.topAnchor),
            customTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func createActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.center = self.view.center
        activityIndicator.isHidden = true
        self.view.addSubview(activityIndicator)
    }
    
    func startAnimating(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopAnimating(){
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

extension CustomTableViewController: TableViewHandlerProtocol{
    func handler(_ handler: TableViewHandler, registerTableViewCells tableView: UITableView) {
        
    }
    
    func prepareDataSourceForHandler(_ handler: TableViewHandler) -> [TableViewCellData] {
        let dataSource: [TableViewCellData] = [TableViewCellData]()
        return dataSource
    }
    
    func handler(_ handler: TableViewHandler, didActionHappenedAt sender: Any?, cell: UITableViewCell) {
    }
}


