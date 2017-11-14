import React from 'react';
import HomeService from '../Services/HomeService';
import DataTrans from '../Helper/DataTrans';

class HomePage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            list: []
        };
    }

    componentDidMount() {
        let self = this;

        HomeService.getRootFiles((result, res) => {
            if (result) {
                self.setState({
                    list: res.fileList
                });
            }
        });
    }

    render() {
        return (
            <section>
                {
                    this.state.list.map((item, index) => {
                        return (
                            <section className="file-item">
                                <div className="list-icon">

                                </div>
                                <div className="list-title">{item.itemName}</div>
                            </section>
                        );
                    })
                }
            </section>
        );
    }
}

export default HomePage;