import ReactDOM from 'react-dom';

//引用CSS
import '../HTML/css/css.css';
// import '../../../UI/HTML/css/css.css';

let appNode = document.getElementById('app');

// 路由控制
import Routes from './Routes';

ReactDOM.render(Routes, appNode);