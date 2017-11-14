'use strict';

const fs = require('fs');
const path = require('path');

const txts = ['txt', 'doc', 'docx', 'ppt', 'xlsx', 'xlsx', 'pdf'];
const images = ['png', 'jpg', 'bmp', 'gif'];
const musics = ['mp3'];
const videos = ['mp4', 'rmvb', 'mkv', 'avi', 'mov'];

//获取文件名后缀名
const extension = (item) => {
    var ext = null;
    var name = item.valueOf();
    name = name.toLowerCase();
    var i = name.lastIndexOf(".");
    if (i > 0) {
        var ext = name.substring(i + 1);
    }
    return ext;
}

//判断Array中是否包含某个值
const contain = (arr, obj) => {
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] == obj)
            return true;
    }
    return false;
};

const getFileType = (itemName) => {
    let ext = extension(itemName);
    if (contain(txts, ext)) {
        return 'txt';
    } else if (contain(images, ext)) {
        return 'image';
    } else if (contain(musics, ext)) {
        return 'music';
    } else if (contain(videos, ext)) {
        return 'video';
    } else {
        return 'others';
    }
};

const HomeService = {

    getRootFiles(dirPath) {
        return {
            fileList: this.getFiles(dirPath)
        };
    },

    getFiles(dirPath) {
        let dirList = fs.readdirSync(dirPath);
        //subFiles: this.getFiles(itemPath)
        var fileList = dirList.map((item, index) => {
            let itemPath = path.join(dirPath, item);
            if (fs.statSync(itemPath).isDirectory()) {
                return {
                    itemName: item,
                    itemPath: itemPath,
                    type: 'directory'
                }
            } else {
                return {
                    itemName: item,
                    itemPath: itemPath,
                    type: getFileType(item)
                }
            }
        });
        return fileList;
    }

};

module.exports = HomeService;