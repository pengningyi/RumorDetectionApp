from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/', methods = ['GET'])
def index():
    return jsonify({'greetings' : 'Hi! this is python'})


if __name__ == "__main__":
    app.run(host='119.29.91.23', port=80)
    # app.run(debug=True)