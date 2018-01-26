from flask import Flask, url_for
from Config import modules

app = Flask(__name__)

# url_for('', filename='')

for module in modules:
    print(module['itemPath'])


@app.route('/modules', methods=['POST'])
def modules():
    return 'hello'


if __name__ == '__main__':
    app.run(host='0.0.0.0')
