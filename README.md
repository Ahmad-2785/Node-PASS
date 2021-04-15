# Node-PASS
This is a project for Software Engineering course 
---
## 環境設定
### Windows
1.  目前我們採用`pm2`來幫我們監控並開啟程式，請在`npm start`前先下`npm install pm2 -g`  
  官方文件:http://pm2.keymetrics.io/docs/usage/quick-start/

2.  請先下載MongoDB安裝並設定  
MongoDB設定可參考這篇網頁:https://ithelp.ithome.com.tw/articles/10186324 

3.  為了讓專案在下`npm start`時可以自動連上Mongodb，請把 MongoDB 安装路徑的 bin 路徑放到環境變數

<img src="/ReadMeImg/dbenvsetting01.png" width="600">

<img src="/ReadMeImg/dbenvsetting02.png" width="600">

接下來下`npm start`看到這樣的畫面就表示自動連上啦!!!

<img src="/ReadMeImg/dbenvsetting03.png" width="600">


### Mac OS
1. 一樣先安裝```pm2```
2. 安裝MongoDB：
    (1)安裝＆執行：[Day02: MongoDB 的安裝與環境配置]( https://ithelp.ithome.com.tw/articles/10236645https://
)
    (2)安裝mongoimport來匯入預設值：[Day12: 進階的 CRUD 操作(2) - 如何透過 JSON 文件導入資料](https://ithelp.ithome.com.tw/articles/10243879)

---
## 執行
1.  git clone:`https://github.com/LeoLiu1209/Node-PASS.git`
2.  先下`npm install`  
3.  初始化MongoDB: `npm run initdb`  
4.  最後是 `npm start`  
5.  開啟瀏覽器，並輸入:`localhost:3000` 
```json=
備註：
在Mac環境下，需要稍微修改package.json的scripts部分
    
"scripts": {    
    "start": "pm2 start ./bin/PASS",
    "api-test": "nyc --reporter=cobertura mocha test/api/*.js",
    "initdb": "mongo && mongo hwgo --eval db.dropDatabase() && mongoimport -d hwgo -c coursescollections dataSeed/courseSeed.json && mongoimport  -d hwgo -c studentcollections dataSeed/studentSeed.json",
    "stop": "pm2 stop PASS"
}
```

## 預設帳號密碼
	老師：  
	  帳號：105598001  
	  密碼：1209
	學生：
	  帳號：105598002  
	  密碼：1209
	
