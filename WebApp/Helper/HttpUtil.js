import request from 'superagent';

const ROOT_URL = '';

class HttpUtil {

    static getHeader(head) {
        let headers = {};
        headers['Content-Type'] = 'application/json; charset=UTF-8';
        return headers;
    }

    static get(url, callback) {
        request.get(url)
            .timeout(30000)
            .set(HttpUtil.getHeader())
            .end((error, result) => {
                if (error) {
                    callback(false, null);
                } else {
                    callback(true, result.body);
                }
            });
    }

    static post(url, data, callback) {
        request.post(url)
            .timeout(300000)
            .set(HttpUtil.getHeader())
            .send(data)
            .end((error, result) => {
                if (error) {
                    callback(false, null);
                } else {
                    callback(true, result.body);
                }
            });
    }

}

export default HttpUtil;