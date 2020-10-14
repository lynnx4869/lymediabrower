'use strict';

const path = require('path');

const modules = [{
    itemName: 'TDDOWNLOAD',
    itemPath: path.join(__dirname, '../../../../TDDOWNLOAD'),
    playPath: '',
    type: 'module'
}, {
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
    itemName: '这种邪恶的东西',
    itemPath: path.join('H:/这种邪恶的东西，不足为外人道也'),
    playPath: '',
    type: 'module'
}, {
    itemName: '这种邪恶的东西，不足为外人道也',
    itemPath: path.join('/Volumes/月夜胜邪/这种邪恶的东西，不足为外人道也'),
    playPath: '',
    type: 'module'
}, {
    itemName: 'Downloads',
    itemPath: path.join('/Users/corpdev/Downloads'),
    playPath: '',
    type: 'module'
}];

module.exports = modules;