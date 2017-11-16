import ReactDOM from 'react-dom';

//引用CSS
import '../HTML/css/css.css';
import '../node_modules/video.js/dist/video-js.min.css';
import '../node_modules/photoswipe/dist/photoswipe.css';

let appNode = document.getElementById('app');

// 路由控制
import Routes from './Routes';

ReactDOM.render(Routes, appNode);