'use strict';

const path = require('path');
const express = require('express');
const bodyParser = require('body-parser');

const app = express();

const HomeService = require('./HomeService');
const modules = require('./Configs');

app.use(express.static(path.join(__dirname, 'dist')));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: false
}));

modules.forEach((module) => {
    app.use(express.static(module.itemPath));
});

app.get('/', (req, res) => res.sendFile(path.resolve('./dist/app.html')));

app.post('/modules', (req, res) => {
    res.set('Content-Type', 'application/json; charset=UTF-8');
    res.status(200).json(HomeService.getModules());
});

app.post('/files', (req, res) => {
    res.set('Content-Type', 'application/json; charset=UTF-8');
    res.status(200).json(HomeService.getRootFiles(req.body.fileroot, req.body.modulePath));
});

app.listen(10081, () => console.log('Example app listening on port 10081!'));