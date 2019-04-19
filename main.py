#!/usr/bin/env python
# coding: utf-8
#读取配置文件
import configparser
import numpy as np
import pymysql
import time
from collections import Counter

class GasControl():
    def __init__(self):
        #初始化，读取配置文件，执行测量
        self.configpath='config/config.ini'
        try:
            self.read_config()
        except Exception as e:
            print('read_config error:',e)
        else:
            print('read over!')
        finally:
            self.en=1
            self.period=1
            while self.en:
                self.ss()
                config = configparser.ConfigParser()
                config.read(self.configpath)
                self.en=config['control']['en']
                self.period = float(config['control']['period'])
                self.period = self.period if self.period>0.1 else 0.1
                time.sleep(self.period)
    def read_config(self,section='Mysql'):
        #读取配置文件
        try:
            config = configparser.ConfigParser()
            #config.sections()
            #sections()获取ini文件内所有的section，以列表形式返回['logging', 'mysql']
            config.read(self.configpath)
            self.host = config[section]['host']
            print(self.host)
            self.user = config[section]['user']
            self.password = config[section]['password']
            self.db = config[section]['db']

            #self.table = config[section]['table']
        except Exception as e:
            print('configparser error:',e)
            pass
            
    def write_config(self,section='Mysql',**kw):
        #写入配置文件
        try:
            config = configparser.ConfigParser()
            config.read(self.configpath)
            #注意：不加read将从头开始写，将抹去之前保存参数,使用了read()之后，是从读取完后的光标开始写入，类似追加模式'a'一样。
            config[section] = kw
            with open(self.configpath, 'w') as configfile:
                config.write(configfile)
        except Exception as e:
            print('write_config error:',e)
    
    def remove_config(self,section):
        #删除配置文件中某一section
        if section!='Mysql':
            config = configparser.ConfigParser()
            config.read(self.configpath)
            try:
                config.remove_section(section)
            except Exception as e:
                print(e)
            print('remove',section,'successful')
            with open(self.configpath, 'w') as configfile:
                config.write(configfile)
            #删除完务必保存一遍，否则删除的仅仅是内存中的section
            
    def ss(self):
        #一、链接数据库
        db=pymysql.connect(self.host,self.user,self.password,self.db)
        cursor=db.cursor()
        #二、读取各表信息并拆分
        #读取高炉信息，存至self.gl
        cursor.execute('select * from %s' % ('gl'))
        self.gl = cursor.fetchall()
        self.gl = np.matrix(self.gl)
        self.b = self.gl[:,2].sum()#self.b为管网常态时煤气设备常数，其中数值0为不投用，数值1为常态时1烧2送或1烧1闷1送，数值2为常态时2烧1送或2烧2送
        #读取abb2mysql表信息，存至self.abb2mysql
        if self.b > 1:
            cursor.execute('select * from %s'%('abb2mysql'))
            self.abb2mysql=cursor.fetchall()
            # self.abb2mysql对应数据库abb2mysql表单数据
            self.abb2mysql=np.array(self.abb2mysql)#这里用np.array,否则后面用argsort时返回arg异常，最终matrix会报错
            #通过self.gl的高炉投用情况判断abb2mysql中哪些行需要删除
            list=[]#初始化一个空list
            for i in range(self.gl.shape[0]):
                if self.gl[i,2]==0:#如果mode==0则执行
                    print('gl+',self.gl[i, 1])
                    for j in range(self.abb2mysql.shape[0]):
                        if self.abb2mysql[j,1]==self.gl[i, 1]:
                            list.append([j])
            self.abb2mysql_del=np.delete(self.abb2mysql,list,axis=0)
            self.counter_status=Counter(self.abb2mysql_del[:,3].flatten())#扁平化数据并统计各个参数个数，统计status个数
            self.sum=self.counter_status[1.0]#self.sum为管网内所有用煤气设备总数,status列相加
            self.sum_0=self.abb2mysql_del.shape[0]-self.sum#统计为status0的个数
            #self.sum=self.abb2mysql_del[:,1].sum()
            arg = np.argsort(self.abb2mysql_del[:, 3])  # 按第'3'列status排序,返回的是升序排序索引
            #降序排序用：arg = np.argsort(-self.abb2mysql_del[:, 3])
            self.abb2mysql_del = np.array(self.abb2mysql_del[arg].tolist()) #返回排序矩阵并赋给原值,用np.matrix会报错
            self.abb2mysql_del_sf = self.abb2mysql_del[0:self.sum_0,:]#分割为sf组
            self.abb2mysql_del_sl = self.abb2mysql_del[self.sum_0:, :]#分割为sl组
            if self.sum_0 > 1:#sf设备大于1时执行排序
                arg1 = np.argsort(self.abb2mysql_del_sf[:, -8]) #按照倒数第四列sfsj_bias排序，返回升序索引
                self.abb2mysql_del_sf=np.matrix(self.abb2mysql_del_sf[arg1].tolist())
                self.rfl_sf=self.abb2mysql_del_sf[0,2]#第一个需要送风的设备编号
                print('rfl_sf',self.rfl_sf)
            if self.sum > 1:#sl设备大于1时执行排序
                arg2 = np.argsort(self.abb2mysql_del_sl[:,-9]) #按照倒数第四列sfsj_bias排序，返回升序索引
                self.abb2mysql_del_sl=np.matrix(self.abb2mysql_del_sl[arg2].tolist())
                self.rfl_sl = self.abb2mysql_del_sl[0, 2]#第一个需要烧炉的设备编号
                print('rfl_sl', self.rfl_sl)
            print('sf',self.abb2mysql_del_sf)
            print('sl', self.abb2mysql_del_sl)
            print('b:',self.b)
            print('sum:',self.sum)
            #py2mysql表输出内容
            #sub:是否允许减少用煤设备
            if self.sum >= self.b:
                self.sub=1
            else:
                self.sub=0
            #add:是否允许增加用煤设备
            if self.sum<=self.b:
                self.add=1
            else:
                self.add=0
        #三、烧炉时间规划：
            bias = [0] * self.abb2mysql_del_sl.shape[0]
            bias_modified = [0] * self.abb2mysql_del_sl.shape[0]
            print('hang',self.abb2mysql_del_sl.shape[0])
            for i in range(self.abb2mysql_del_sl.shape[0]-1):
                # 需要增加的烧炉时间（多等待时间） = 实际需要等待时间 - 剩余烧炉时间
                # if i!=self.abb2mysql_del_sl.shape[0]:
                #     print('i+1:',i+1)
                #     print(self.abb2mysql_del_sl[i,-3])
                #     print(self.abb2mysql_del_sl[i+1,-9])

                bias[i+1] = self.abb2mysql_del_sl[i,-3] - self.abb2mysql_del_sl[i+1,-9]
                print('biasI+1',bias[i + 1])
                # bias为正时说明本炉需要多等待的时间，为负时说明可为下一炉调整的时间余量有多少
                # bias[i+1] = bias[i+1] if bias[i+1]>0 else 0
                if bias[i] > 0:  # 第（i）炉需要等待,bias[0]=0，故i不等于0
                    # 首先，第（i）炉需要等待，调整本炉
                    bias_modified[i] = bias[i] * self.abb2mysql_del_sl[i, -2]
                    if bias[i - 1] < 0:  # 第（i-1）炉，有调整余量
                        # 其次，第（i-1）炉有调整余量时，需要烧快一点
                        bias_modified[i - 1] -= self.abb2mysql_del_sl[i - 1, -1] * bias[i]  # 负数
                        # 最后，当(i-1)炉调整到小于可调整值时说明没有调整余量，置为最小可调整值
                        if bias_modified[i - 1] < bias[i - 1] * self.abb2mysql_del_sl[i - 1, -2]:
                            bias_modified[i - 1] = bias[i - 1] * self.abb2mysql_del_sl[i - 1, -2]
            # 排列第一个的炉子由于没有上一个炉子，故烧炉时间调整只与下一炉相关,且可以为负
            bias_modified[0] = self.abb2mysql_del_sl[0, -1] * bias[1]
            # 当(0)炉调整到小于可调整值时说明没有调整余量，置为最小可调整值
            if bias_modified[0] < bias[0] * self.abb2mysql_del_sl[0, -2]:
                bias_modified[0] = bias[0] * self.abb2mysql_del_sl[0, -2]
        #四、把计算结果存至表中：
            #1、烧炉数据
            self.rflsl_num=[0]*10
            self.slsj_current_left=[0]*10
            self.slsj_next_wait = [0] * 10
            self.bias=[0]*10
            self.bias_modified=[0]*10
            #①可利用reshape把列向量转换为行向量，再tolist成list，但多一个中括号:self.rflsl_num[:len(bias_modified)]=self.abb2mysql_del_sl[:,2].reshape(1,-1).tolist()
            #②可利用把matrix转换为nparray，再用flatten把列向量展开，再tolist完成。
            self.rflsl_num[:len(bias_modified)] = np.array(self.abb2mysql_del_sl[:, 2]).flatten().tolist()
            self.slsj_next_wait[:len(bias_modified)]=np.array(self.abb2mysql_del_sl[:,-3]).flatten().tolist()
            self.slsj_current_left[:len(bias_modified)]=np.array(self.abb2mysql_del_sl[:,-9]).flatten().tolist()
            self.bias[:len(bias_modified)]=bias
            self.bias_modified[:len(bias_modified)]=bias_modified
            print('num:',self.rflsl_num)
            print('wait:',self.slsj_next_wait)
            print('bias:',self.bias)
            print('self.biasmodified',self.bias_modified)
            print('biasmodified',bias_modified)

            #2、送风数据
            self.rflsf_num = [0] * 10
            self.sfsj_left = [0] * 10
            self.rflsf_num[:self.abb2mysql_del_sf.shape[0]]= np.array(self.abb2mysql_del_sf[:,2]).flatten().tolist()
            self.sfsj_left[:self.abb2mysql_del_sf.shape[0]]=np.array(self.abb2mysql_del_sf[:,-8]).flatten().tolist()
            for i in range(len(self.rflsl_num)):
                query = "update py2mysql_sl set rfl_sl=%s,slsj_current_left=%s,slsj_next_wait=%s,bias=%s,bias_modified=%s where ID=%s;"\
                        %(self.rflsl_num[i],self.slsj_current_left[i],self.slsj_next_wait[i],self.bias[i],self.bias_modified[i],i+1)
                cursor.execute(query)
                query2 ="update py2mysql_sf set rfl_sf=%s,sfsj_left=%s where ID=%s;"\
                        %(self.rflsf_num[i],self.sfsj_left[i],i+1)
                cursor.execute(query2)
            query3="update py2mysql set `add`=%s,`sub`=%s,`sum`=%s,`b`=%s where ID=1;"\
                        %(self.add,self.sub,self.sum,self.b)
            print(query3)
            cursor.execute(query3)
        db.commit()
        cursor.close()
        db.close()

if __name__=='__main__':
    myss=GasControl()




