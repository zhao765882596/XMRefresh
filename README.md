# XMRefresh

[![CI Status](http://img.shields.io/travis/ming/XMRefresh.svg?style=flat)](https://travis-ci.org/ming/XMRefresh)
[![Version](https://img.shields.io/cocoapods/v/XMRefresh.svg?style=flat)](http://cocoapods.org/pods/XMRefresh)
[![License](https://img.shields.io/cocoapods/l/XMRefresh.svg?style=flat)](http://cocoapods.org/pods/XMRefresh)
[![Platform](https://img.shields.io/cocoapods/p/XMRefresh.svg?style=flat)](http://cocoapods.org/pods/XMRefresh)

Swift version of [MJRefresh](https://github.com/CoderMJLee/MJRefresh) An easy way to use pull-to-refresh

---

## Example
```Swift
self.tableView.xm_header = XMRefreshNormalHeader.init(refreshing: { [weak self] in
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: {
self?.tableView.reloadData()
self?.tableView.xm_header?.endRefreshing()
})
})
self.tableView.xm_footer = XMRefreshBackNormalFooter.init(refreshing: {
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: { [weak self] in
self?.tableView.reloadData()
self?.tableView.xm_footer?.endRefreshing()
})
})
```

## Requirements

## Installation

XMRefresh is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XMRefresh'
```

## Author

ming, z4015@qq.com

## License

XMRefresh is available under the MIT license. See the LICENSE file for more info.
