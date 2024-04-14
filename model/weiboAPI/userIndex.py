import sys
import os
sys.path.append('/home/develop/workspace/RumorDetectionApp/model/MDFEND')



import numpy as np
import pandas as pd
import torch
from torch.utils.data import TensorDataset, DataLoader
from models.mdfend import MultiDomainFENDModel
from utils.dataloader import word2input

import utils ##The local utils
import sys
import argparse

import warnings
warnings.filterwarnings("ignore")



###TODO need to modify here to only load the model once
def get_text_index(text):


    category_dict = {
        "科技": 0,  
        "军事": 1,  
        "教育考试": 2,  
        "灾难事故": 3,  
        "政治": 4,  
        "医药健康": 5,  
        "财经商业": 6,  
        "文体娱乐": 7,  
        "社会生活": 8
    }


    config = {
            'use_cuda': False,
            'batchsize': 64,
            'max_len': 170,
            'early_stop': 3,
            'num_workers': 4,
            'vocab_file': './pretrained_model/chinese_roberta_wwm_base_ext_pytorch/vocab.txt',
            'emb_type': 'bert',
            'bert': './pretrained_model/chinese_roberta_wwm_base_ext_pytorch',
            'root_path': './data/weibo21/',
            'weight_decay': 5e-5,
            'model':
                {
                'mlp': {'dims': [384], 'dropout': 0.2}
                },
            'emb_dim':768,
            'lr': 0.0005,
            'epoch': 50,
            'model_name': 'mdfend',
            'seed': 2021,
            'save_param_dir': './param_model'
            }
    
    device = torch.device('cuda' if config['use_cuda'] else 'cpu')
    model = MultiDomainFENDModel(768,[384],'./pretrained_model/chinese_roberta_wwm_base_ext_pytorch',0.2,'bert')
    model.load_state_dict(torch.load('./param_model/mdfend/parameter_mdfend.pkl'))
    model.to(device)


    df = pd.DataFrame([{"content":"haha",'label':0,'category':"科技"},{"content":text,'label':1,'category':"科技"}])

    content = df['content'].to_numpy()
    label = torch.tensor(df['label'].astype(int).to_numpy())
    category = torch.tensor(df['category'].apply(lambda c: category_dict[c]).to_numpy())
    content_token_ids, content_masks = word2input(content, config['vocab_file'], config['max_len'])


    data = {
        'content': content_token_ids.to(device) ,
        'content_masks': content_masks.to(device),
        'label': label.to(device),
        'category': category.to(device),
        'use_cuda': config['use_cuda']
        }

    res = model(**data)

    #print(f"模型预测该文本为谣言的概率为: {res[1].detach().cpu().numpy()}")
    return float(res[1].detach().cpu().numpy())









def model_LLM_test(text):
    #TODO add the model here
    #psudo function which returns the predicted rumor prob for the texts
    return 0.5

def model_LLM(text):
    return get_text_index(text)

def get_initial_val(uid,num):
    score = 0
    ##Average the LLM score from num of texts
    p = client.people(uid)
    cnt = 0
    for status in p.statuses.page(1):
        score += model_LLM(status.text)

        cnt+=1
    if cnt ==0:
        return 0.5
    else:

        return score/cnt
    



def str2value(valueStr):
    valueStr = str(valueStr)
    idxOfYi = valueStr.find('亿')
    idxOfWan = valueStr.find('万')
    if idxOfYi != -1 and idxOfWan != -1:
        return int(float(valueStr[:idxOfYi])*1e8 + float(valueStr[idxOfYi+1:idxOfWan])*1e4)
    elif idxOfYi != -1 and idxOfWan == -1:
        return int(float(valueStr[:idxOfYi])*1e8)
    elif idxOfYi == -1 and idxOfWan != -1:
        return int(float(valueStr[idxOfYi+1:idxOfWan])*1e4)
    elif idxOfYi == -1 and idxOfWan == -1:
        return float(valueStr)
    

from weibo_api.client import WeiboClient
import requests
import re
import json
import networkx as nx
import matplotlib.pyplot as plt
import numpy as np
#plt.rcParams['font.sans-serif'] = ['YouYuan']
plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False 
client = WeiboClient()



# 请求文本
def getHtmlText(url, code='UTF-8'):
    trytime = 10
    while trytime > 0:
        try:
            header = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.26 Safari/537.36 Core/1.63.6726.400 QQBrowser/10.2.2265.400',
            }
            r = requests.get(url, headers=header, timeout=5)
            r.raise_for_status()
            r.encoding = code
            return r.text
        except:
            print("get获取失败,重连中")
            trytime -= 1


# 获取用户信息
def getUserInfo(uid):
    url = 'https://m.weibo.cn/api/container/getIndex?type=uid&value={}'.format(uid)
    Infomation = json.loads(getHtmlText(url))
    UserInfo = {}
    UserInfo['id'] = Infomation['data']['userInfo']['id']
    UserInfo['name'] = Infomation['data']['userInfo']['screen_name']
    UserInfo['gender'] = '女' if Infomation['data']['userInfo']['gender'] == 'f' else '男'
    UserInfo['followers_count'] = Infomation['data']['userInfo']['followers_count']
    UserInfo['follow_count'] = Infomation['data']['userInfo']['follow_count']
    #UserInfo['desc'] = Infomation['data']['userInfo']['description']
    # with open('./UserInfo.json', 'w', encoding='utf-8') as f:
    #     f.write(json.dumps(UserInfo, ensure_ascii=False))
    return UserInfo

# 获取用户关注列表
def getInterestList(uid, num):
    url = 'https://m.weibo.cn/api/container/getIndex?containerid=231051_-_followers_-_{}&page=1'.format(uid)
    data = json.loads(getHtmlText(url))
    intertestList = []
    cardlist = data['data']['cards']
    for cards in cardlist:
        if 'title' in cards and (cards['title'] == '她的全部关注' or cards['title'] =='他的全部关注'):
            i = 0
            for card in cards['card_group']:
                if i < num:
                    person = {}
                    person['id'] = card['user']['id']
                    intertestList.append(person)
                    i += 1
    # with open('./interestList.json', 'w', encoding='utf-8') as f:
    #     f.write(json.dumps(intertestList, ensure_ascii=False))
    return intertestList


# 深搜获取多层用户信息及用户关注列表
def deepSearchList(list, uid, floor, num):
    if floor == 0:
        # print(list.keys())
        if uid in list.keys():
            print('{}有重复'.format(uid))
            return list
        else:
            # print(list.keys())
            # print(uid in list.keys())
            list[str(uid)] = dict()
            list[uid]['userInfo'] = getUserInfo(uid)
            print('{}\t{}\t{}\t{}'.format(uid, list[uid]['userInfo']['name'], list[uid]['userInfo']['gender'],
                                          list[uid]['userInfo']['followers_count']))
            return list
    elif uid in list.keys() and 'interestList' in list[uid].keys():
        # print('interestList' in list[uid].keys())
        #print('{}有重复'.format(uid))
        return list
    else:
        list[str(uid)] = dict()
        list[uid]['userInfo'] = getUserInfo(uid)
        list[uid]['interestList'] = getInterestList(uid, num)
        print('{}\t{}\t{}\t{}'.format(uid, list[uid]['userInfo']['name'],
                                      list[uid]['userInfo']['gender'],
                                      list[uid]['userInfo']['followers_count']))
        i = 0
        for interestList in list[uid]['interestList']:
            if i < num:
                list = deepSearchList(list, str(interestList['id']), floor - 1, num)
                # with open('./list.json', 'w', encoding='utf-8') as f:
                #     f.write(json.dumps(list, ensure_ascii=False))
                i += 1
        return list
    


def get_user_index(uid):

    tmp = os.getcwd()
    print(tmp)

    os.chdir('/home/develop/workspace/RumorDetectionApp/model/MDFEND')

    print(os.getcwd())





    data = dict()
    data = deepSearchList(data, uid, 2, 2)
    #with open(f'./{uid}.json', 'w', encoding='utf-8') as f:
        #f.write(json.dumps(data, ensure_ascii=False))
    G = nx.DiGraph()
    node_size_list = dict()
    node_color_list = dict()

    initial_vals = dict()
    for person in data:
        G.add_node(data[person]['userInfo']['name'])
        node_size_list[data[person]['userInfo']['name']] = 0
        node_color_list[data[person]['userInfo']['name']] = 'lightblue' if data[person]['userInfo']['gender'] == '男' else 'pink'
        
        score_test = get_initial_val(data[person]['userInfo']['id'],2)
        print(score_test)
        initial_vals[data[person]['userInfo']['name']] = score_test

    for person in data:
        if 'interestList' in data[person].keys():
            for interest in data[person]['interestList']:
                #print('{} -> {}'.format(person, interest['id']))
                if str2value(data[str(interest['id'])]['userInfo']['followers_count'])==0:
                    a= 1
                    print('notice')
                    
                G.add_edge(data[person]['userInfo']['name'],
                           data[str(interest['id'])]['userInfo']['name'],weight = str2value(data[str(interest['id'])]['userInfo']['followers_count']))
                node_size_list[data[str(interest['id'])]['userInfo']['name']] += 1
        G.add_edge(data[person]['userInfo']['name'],
            data[person]['userInfo']['name'],weight = str2value(data[str(interest['id'])]['userInfo']['followers_count']))    


    pagerank = nx.pagerank(G)
    pagerank_vector = np.array([pagerank[node] for node in G.nodes()])
    initial_vals_vector = np.array([initial_vals[node] for node in G.nodes()])
    user_rumor_index = np.dot(pagerank_vector,initial_vals_vector)-pagerank_vector[0]*initial_vals_vector[0]



    os.chdir(tmp)
    return user_rumor_index

if __name__ == '__main__':
    uid = '5623741644'
    score = get_user_index(uid)
    print(score)



