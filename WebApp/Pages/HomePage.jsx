import React from 'react';
import HomeService from '../Services/HomeService';

function getTypeIcon(type) {
    switch (type) {
        case 'directory':
            return (
                <i className="iconfont">&#xe642;</i>
            );
        case 'txt':
            return (
                <i className="iconfont">&#xe616;</i>
            );
        case 'image':
            return (
                <i className="iconfont">&#xe708;</i>
            );
        case 'music':
            return (
                <i className="iconfont">&#xe607;</i>
            );
        case 'video':
            return (
                <i className="iconfont">&#xe628;</i>
            );
        case 'others':
            return (
                <i className="iconfont">&#xe632;</i>
            );
        default:
            return '';
    }
}

class HomePage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            list: [],
            items: [{
                itemName: '主页',
                itemPath: '',
                type: 'directory'
            }]
        };
    }

    componentDidMount() {
        this.loadData();
    }

    loadData() {
        let self = this;
        let item = self.state.items[self.state.items.length - 1];

        HomeService.getRootFiles(item.itemPath, (result, res) => {
            if (result) {
                self.setState({
                    list: res.fileList
                });
            }
        });
    }

    onPushItem(item) {
        if (item.type == 'directory') {
            let self = this;
            let items = self.state.items;
            items.push(item);
            self.setState({
                items: items
            }, () => {
                self.loadData();
            });
        }
    }

    onBack() {
        let self = this;
        let items = self.state.items;

        if (items.length > 1) {
            items.pop();
            self.setState({
                items: items
            }, () => {
                self.loadData();
            });
        }
    }

    render() {
        let self = this;
        let items = self.state.items;
        let item = items[items.length - 1];

        return (
            <section>
                <section className="nav">
                    <div className="back"
                        onClick={self.onBack.bind(this)}>
                        {items.length > 1 ? '返回' : ''}
                    </div>
                    <div className="title">{item.itemName}</div>
                </section>
                <section className="pt3">
                    {
                        this.state.list.map((item, index) => {
                            return (
                                <section className="file-item"
                                    onClick={self.onPushItem.bind(this, item)}>
                                    <div className="list-icon">
                                        {getTypeIcon(item.type)}
                                    </div>
                                    <div className="list-title">
                                        {item.itemName}
                                    </div>
                                </section>
                            );
                        })
                    }
                </section>
            </section>
        );
    }
}

export default HomePage;