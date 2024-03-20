# This is a project based on MDFEND: Multi-domain Fake News Detection

The original paper is [**MDFEND: Multi-domain Fake News Detection**](https://dl.acm.org/doi/abs/10.1145/3459637.3482139) accepted by CIKM2021.



## Dataset

The data is obtained from Weibo, a major Chinese Social Media, using by hundreds of millions people in China.

You can find the splited dataset(Train, Val, Test) in the `MDFEND-Weibo21/data/weibo21` folder


## Requirements

You can run `pip install -r requirements.txt` to deploy the environment quickly.

A right cuda version is desired.


## Run

You can run this model through:
```python
python main.py --model_name mdfend --batchsize 32 --lr 0.0007
```

To only test the performance:

```python
python interface.py
```

Then you can input some text and it will return a referenced probability indicating the chances of being a rumor.



### Reference
```
Nan Q, Cao J, Zhu Y, et al. MDFEND: Multi-domain Fake News Detection[C]//Proceedings of the 30th ACM International Conference on Information & Knowledge Management. 2021: 3343-3347.
```