class DataTrans {
    static getTypeIcon(type) {
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
}

export default DataTrans;