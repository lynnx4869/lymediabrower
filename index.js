'use strict';

const path = require('path');
const express = require('express');
const bodyParser = require('body-parser');

const app = express();

const HomeService = require('./Server/HomeService');

const docs = path.join(__dirname, '../../../../Documents');
app.use(express.static(path.join(__dirname, 'dist')));
app.use(express.static(docs));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: false
}));

app.get('/', (req, res) => res.sendFile(path.resolve('./dist/app.html')));

app.post('/files', (req, res) => {
    if (req.body.fileroot == '') {
        res.set('Content-Type', 'application/json; charset=UTF-8');
        res.status(200).json(HomeService.getRootFiles());
    }
});

app.listen(10081, () => console.log('Example app listening on port 10081!'));