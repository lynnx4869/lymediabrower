import HttpUtil from '../Helper/HttpUtil';

class HomeService {

    static getRootFiles(callback) {
        let data = {
            fileroot: ''
        }
        HttpUtil.post('/files', data, callback);
    }

}

export default HomeService;