import React from 'react';
import PhotoSwipe from 'photoswipe';

class ImagesPage extends React.Component {
    constructor(props) {
        super(props);
    }

    componentDidMount() {
        let images = this.props.images;

        var options = {
            index: this.props.curIndex
        };

        let imagesView = this.refs.imagesView;
        let gallery = new PhotoSwipe(imagesView, null, images, options);
        gallery.init();
    }

    render() {
        return (
            <div ref="imagesView" className="pswp" tabindex="-1" role="dialog" aria-hidden="true">
                <div className="pswp__bg"></div>
                <div className="pswp__scroll-wrap">
                    <div className="pswp__container">
                        <div className="pswp__item"></div>
                        <div className="pswp__item"></div>
                        <div className="pswp__item"></div>
                    </div>
                </div>
            </div>
        );
    }
}

export default ImagesPage;
