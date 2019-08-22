'use strict';

const fs = require('fs');
const path = require('path');

const modules = require('./Configs');

const txts = ['txt', 'doc', 'docx', 'ppt', 'pptx', 'xlsx', 'xlsx', 'pdf', 'h', 'm', 'swift', 'java', 'js', 'jsx', 'html', 'css', 'json', 'epub'];
const images = ['png', 'jpg', 'bmp', 'gif'];
const musics = ['mp3', 'wav', 'flac', 'ape'];
const videos = ['mp4', 'rmvb', 'mkv', 'avi', 'mov', 'wmv'];

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

    getRootFiles(dirPath, modulePath) {
        return {
            fileList: this.getFiles(dirPath, modulePath)
        };
    },

    getFiles(dirPath, modulePath) {
        let dirList = fs.readdirSync(dirPath);

        let directorys = [];
        let txts = [];
        let images = [];
        let musics = [];
        let videos = [];
        let others = [];

        for (let item of dirList) {
            let itemPath = path.join(dirPath, item);
            if (fs.existsSync(itemPath)) {
                if (fs.statSync(itemPath).isDirectory()) {
                    directorys.push({
                        itemName: item,
                        itemPath: itemPath,
                        playPath: '',
                        type: 'directory'
                    });
                } else {
                    let type = getFileType(item);
                    let file = {
                        itemName: item,
                        itemPath: itemPath,
                        playPath: itemPath.replace(modulePath, '').replace('\\', '/'),
                        type: type
                    };
                    switch (type) {
                        case 'txt':
                            txts.push(file);
                            break;
                        case 'image':
                            images.push(file);
                            break;
                        case 'music':
                            musics.push(file);
                            break;
                        case 'video':
                            videos.push(file);
                            break;
                        case 'others':
                            others.push(file);
                            break;
                    }
                }
            }
        }

        return directorys.concat(txts).concat(images).concat(musics).concat(videos).concat(others);
    },

    getModules() {
        let newModules = [];
        for (module of modules) {
            let ret = fs.existsSync(module.itemPath);
            if (ret) {
                newModules.push(module);
            }
        }

        return {
            modules: newModules
        }
    }

};

module.exports = HomeService;