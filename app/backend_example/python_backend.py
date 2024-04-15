from flask import Flask, jsonify

##Note that it remains needed to add some relevant paths and change working directories
from model.MDFEND import textIndex
from weiboAPI import userIndex
app = Flask(__name__)

@app.route('/', methods = ['GET'])
def index():

    uid = '5623741644'##For example
    userInfo = userIndex.getUserInfo(uid)
    user_rumor_index = userIndex.get_user_index(uid)
    
    text = '喝双氧水可以抗癌'## For example
    text_rumor_index = textIndex.get_text_index(text)

    return jsonify({'name' : userInfo['name'],
                    'id': userInfo['id'],
                    'gender':userInfo['gender'],
                    'follow_count':userInfo['follow_count'],
                    'followers_count':userInfo['followers_count'],
                    'user_rumor_index':user_rumor_index,
                    'test':text,
                    'text_rumor_index':text_rumor_index})

@app.route('/user', methods = ['GET'])
def index():

    uid = '5623741644'##For example
    userInfo = userIndex.getUserInfo(uid)
    user_rumor_index = userIndex.get_user_index(uid)
    
    text = '喝双氧水可以抗癌'## For example
    text_rumor_index = textIndex.get_text_index(text)

    return jsonify({'name' : userInfo['name'],
                    'id': userInfo['id'],
                    'gender':userInfo['gender'],
                    'follow_count':userInfo['follow_count'],
                    'followers_count':userInfo['followers_count'],
                    'user_rumor_index':user_rumor_index,})
    
@app.route('/post', methods = ['GET'])
def index():

    uid = '5623741644'##For example
    userInfo = userIndex.getUserInfo(uid)
    user_rumor_index = userIndex.get_user_index(uid)

    text = '喝双氧水可以抗癌'## For example
    text_rumor_index = textIndex.get_text_index(text)

    return jsonify({'id': userInfo['id'],
                    'test':text,
                    'text_rumor_index':text_rumor_index})

if __name__ == "__main__":
    app.run(host='119.29.91.23', port=80)
    # app.run(debug=True)
