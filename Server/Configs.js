'use strict';

const path = require('path');

const modules = [{
    itemName: '魔穗字幕组',
    itemPath: path.join(__dirname, '../../../../TDDOWNLOAD/魔穗字幕组'),
    playPath: '',
    type: 'module'
}, {
    itemName: '影视',
    itemPath: path.join(__dirname, '../../../../影视'),
    playPath: '',
    type: 'module'
}, {
    itemName: 'download',
    itemPath: path.join('F:/download'),
    playPath: '',
    type: 'module'
}, {
    itemName: '这种邪恶的东西',
    itemPath: path.join('G:/这种邪恶的东西，不足为外人道也'),
    playPath: '',
    type: 'module'
}, {
    itemName: '动漫',
    itemPath: path.join('G:/动漫'),
    playPath: '',
    type: 'module'
}, {
    itemName: '影视',
    itemPath: path.join('G:/影视'),
    playPath: '',
    type: 'module'
}, {
    itemName: '这种邪恶的东西，不足为外人道也',
    itemPath: path.join('/Volumes/月夜胜邪/这种邪恶的东西，不足为外人道也'),
    playPath: '',
    type: 'module'
}, {
    itemName: 'Downloads',
    itemPath: path.join('/Users/xianing/Downloads'),
    playPath: '',
    type: 'module'
}];

module.exports = modules;