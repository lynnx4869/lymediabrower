import HttpUtil from '../Helper/HttpUtil';

class HomeService {

    static getRootFiles(url, callback) {
        let data = {
            fileroot: url
        }
        HttpUtil.post('/files', data, callback);
    }

}

export default HomeService;