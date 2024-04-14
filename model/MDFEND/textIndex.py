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

if __name__ == '__main__':
    text = input("请输入:")
    print(get_text_index(text))
    