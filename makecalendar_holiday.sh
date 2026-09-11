#!/bin/zsh

## 引数
## ファイル名。
## 日付。
##
## 20250101,元日
## 20250113,成人の日
## 20250223,天皇誕生日
## の形式でファイルを記述すること。

if [ $# != 1 ]; then
  echo "usage : ファイル名"
  exit
fi

if [ ${1} = "-h" ]; then
    echo "usage : ファイル名"
    exit
fi

## リテラル。

echo "BEGIN:VCALENDAR"
echo "PRODID:-//Mozilla.org/NONSGML Mozilla Calendar V1.1//EN"
echo "VERSION:2.0"
echo "BEGIN:VTIMEZONE"
echo "TZID:Asia/Tokyo"
echo "BEGIN:STANDARD"
echo "TZOFFSETFROM:+0900"
echo "TZOFFSETTO:+0900"
echo "TZNAME:JST"
echo "DTSTART:19700101T000000"
echo "END:STANDARD"
echo "END:VTIMEZONE"

## ここからループ
INDEX=0;
TIME=""
BEGINTIME=""
ENDTIME=""
while read line
do
    ## 時間は01:00-02:00に指定。
    SUMMARY=`echo ${line} | awk -F "," '{print $2}'`
    EVENTDAY=`echo ${line} | awk -F "," '{print $1}'`
    BEGINTIME="0100"
    ENDTIME="0200"

    echo "BEGIN:VEVENT"

  ## dateで作ります。
  ## date '+%Y%m%dT%H%M%S'
  ## 20200813T091901Z
    CREATED=`date '+%Y%m%dT%H%M%SZ'`
    echo "CREATED:"${CREATED}
    echo "LAST-MODIFIED:"${CREATED}
    echo "DTSTAMP:"${CREATED}

  ## uuidgen | tr A-Z a-z
    echo "UID:"`uuidgen | tr A-Z a-z`

  ## SUMMARY:元日
    echo "SUMMARY:"${SUMMARY}

  ## 時間は1時間。
    echo "DTSTART;TZID=Asia/Tokyo:"${EVENTDAY}"T"${BEGINTIME}"00"
    echo "DTEND;TZID=Asia/Tokyo:"${EVENTDAY}"T"${ENDTIME}"00"
    INDEX=$((${INDEX} +1))
    
  ## ループ終了
    echo "DESCRIPTION:"${SUMMARY}
    echo "TRANSP:OPAQUE"
    echo "SEQUENCE:1"
    echo "X-MOZ-GENERATION:1"
    echo "END:VEVENT"

done < $1
  
## 表示終了。
echo "END:VCALENDAR"
