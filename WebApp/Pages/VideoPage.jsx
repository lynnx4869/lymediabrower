import React from 'react';
import videojs from 'video.js';

class VideoPage extends React.Component {
    constructor(props) {
        super(props);
    }

    onClose() {
        this.props.closeVideo();
    }

    render() {
        let videoItem = this.props.videoItem;

        return (
            <div>
                <section className="video-nav">
                    <div className="back" onClick={this.onClose.bind(this)}>关闭</div>
                </section>
                <video className="video-view video-js" controls preload="auto" width="300" height="264" data-setup="{}">
                    <source src={videoItem.playPath} type="video/mp4"></source>
                    <source src={videoItem.playPath} type="video/webm"></source>
                    <source src={videoItem.playPath} type="video/ogg"></source>
                    <source src={videoItem.playPath} type="video/x-matroska"></source>
                </video>
            </div>
        );
    }
}

export default VideoPage;