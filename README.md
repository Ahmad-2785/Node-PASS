# Node-PASS
This is a project for Software Engineering course 

## 環境設定
1.  目前我們採用`pm2`來幫我們監控並開啟程式，請在`npm start`前先下`npm install pm2 -g`  
  官方文件:http://pm2.keymetrics.io/docs/usage/quick-start/

2.  請先下載MongoDB安裝並設定  
MongoDB設定可參考這篇網頁:https://ithelp.ithome.com.tw/articles/10186324 

3.  為了讓專案在下`npm start`時可以自動連上Mongodb，請把 MongoDB 安装路徑的 bin 路徑放到環境變數

<img src="/ReadMeImg/dbenvsetting01.png" width="600">

<img src="/ReadMeImg/dbenvsetting02.png" width="600">

接下來下`npm start`看到這樣的畫面就表示自動連上啦!!!

<img src="/ReadMeImg/dbenvsetting03.png" width="600">

## 執行
1.  git clone:`https://github.com/LeoLiu1209/Node-PASS.git`
2.  先下`npm install`  
3.  初始化MongoDB: `npm run initdb`  
4.  最後是 `npm start`  
5.  開啟瀏覽器，並輸入:`localhost:3000`  

## 預設帳號密碼
	老師：  
	  帳號：105598001  
	  密碼：1209
	學生：
	  帳號：105598002  
	  密碼：1209
	
