#!/usr/bin/env python
# coding: utf-8
#读取配置文件
import configparser
import numpy as np
import pandas as pd
import pymysql

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
            self.ss()
            
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
        #链接数据库
        db=pymysql.connect(self.host,self.user,self.password,self.db)
        cursor=db.cursor()
        #读取高炉信息，存至self.gl
        cursor.execute('select * from %s' % ('gl'))
        self.gl = cursor.fetchall()
        self.gl = np.matrix(self.gl)
        self.b = self.gl[:,2].sum()#self.b为管网常态时煤气设备常数，其中数值0为不投用，数值1为常态时1烧2送或1烧1闷1送，数值2为常态时2烧1送或2烧2送
        #读取abb2mysql表信息，存至self.abb2mysql
        if self.b > 0:
            cursor.execute('select * from %s'%('abb2mysql'))
            self.abb2mysql=cursor.fetchall()
            self.abb2mysql=np.matrix(self.abb2mysql)#self.abb2mysql对应数据库abb2mysql表单数据
            #通过self.gl的高炉投用情况判断abb2mysql中哪些行需要删除
            list=[]#初始化一个空list
            for i in range(self.gl.shape[0]):
                if self.gl[i,2]==0:#如果mode==0则执行
                    print('gl+',self.gl[i, 1])
                    for j in range(self.abb2mysql.shape[0]):
                        if self.abb2mysql[j,1]==self.gl[i, 1]:
                            list.append([j])
            self.abb2mysql_del=np.delete(self.abb2mysql,list,axis=0)
            print(list)
            print(self.abb2mysql_del.shape)
            print(self.abb2mysql_del[:,1])
            self.sum=self.abb2mysql[:,1].sum()#self.sum为管网内所有用煤气设备总数

            if self.sum >= self.b:
                self.sub=1
            else:
                self.sub=0
            if self.sum<=self.b:
                self.add=1
            else:
                self.add=0
        cursor.close()
        db.close()

if __name__=='__main__':
    myss=GasControl()




