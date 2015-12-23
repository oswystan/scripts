#!/bin/ksh
######################################################################################
##                                                                                  ##
##                               shell程序函数库                                    ##
##                                                                                  ##
######################################################################################

g_LogFile="./loginfo.log"             #日志文件的文件名
g_Version="V1.0D001"

###################################################################
## 函数名称: LogStart(), LogInfo(), LogWarn(), LogError(), LogEnd()
## 函数功能: 用于打印相应的日志信息
## 输入参数: 日志描述字符串
## 返 回 值: NA;
###################################################################
LogStart()
{
    strNow=`date +'%Y-%m-%d %H:%M:%S'`
    echo "" >> $g_LogFile
    echo "[${strNow}]##########################################################" >> $g_LogFile
    echo "[${strNow}]Program  : $0" >> $g_LogFile
    echo "[${strNow}]Version  : $g_Version" >> $g_LogFile
    echo "[${strNow}]Arguments: $*" >> $g_LogFile
    echo "[${strNow}]##########################################################" >> $g_LogFile

    echo ""
    echo "[${strNow}]##########################################################"
    echo "[${strNow}]Program  : $0"
    echo "[${strNow}]Version  : $g_Version"
    echo "[${strNow}]Arguments: $*"
    echo "[${strNow}]##########################################################"
}

LogInfo()
{
    strNow=`date +'%Y-%m-%d %H:%M:%S'`
    echo "[${strNow}] INFO: $*" >> $g_LogFile
    echo "[${strNow}] INFO: $*"
}

LogWarn()
{
    strNow=`date +'%Y-%m-%d %H:%M:%S'`
    echo "[${strNow}] WARN: $*" >> $g_LogFile
    echo "[${strNow}] WARN: $*"
}

LogError()
{
    strNow=`date +'%Y-%m-%d %H:%M:%S'`
    echo "[${strNow}]ERROR: $*" >> $g_LogFile
    echo "[${strNow}]ERROR: $*"
}

LogEnd()
{
    strNow=`date +'%Y-%m-%d %H:%M:%S'`
    echo "[${strNow}]##########################################################"  >> $g_LogFile
    echo "[${strNow}]Please refer to log file: ${g_LogFile}" >> $g_LogFile
    echo "[${strNow}]##########################################################"  >> $g_LogFile
    echo "" >> $g_LogFile

    echo "[${strNow}]##########################################################"
    echo "[${strNow}]Please refer to log file: ${g_LogFile}"
    echo "[${strNow}]##########################################################"
    echo ""
}

###################################################################
## 函数名称: IsDigit()
## 函数功能: 判断输入字符串是否是数字串
## 输入参数: 需要判断的字符串
## 返 回 值: 0 是; 1 不是;
###################################################################
IsDigit()
{
    if [ $# -ne 1 ]; then
        return 1
    fi

    if [ "-$1" = "-" ]; then
        return 1
    fi

    strTmp=`echo $1|tr -d [0-9]`
    iTmp=`echo $strTmp | awk '{print length($0)}'`
    if [ $iTmp -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

###################################################################
## 函数名称: GetFileSize()
## 函数功能: 获取指定文件的大小(单位: B)
## 输入参数: 文件名
## 返 回 值: 0 成功; 1 失败;
###################################################################
GetFileSize()
{
    iFileSize=0
    if [ $# -ne 1 ]; then
        return 1
    fi

    if [ ! -f $1 ];then
        return 1
    fi

    #取ls -l命令的第5个字段的值
    strTmp=`ls -l $1`
    iFileSize=`echo $strTmp | awk -F' ' '{ print $5}'`
    return 0
}

###################################################################
## 函数名称: IsLeapYear()
## 函数功能: 判断指定年份是否位闰年
## 输入参数: 年份
## 返 回 值: 0 是; 1 不是;
###################################################################
IsLeapYear()
{
    if [ $# -ne 1 ]; then
        return 1
    fi

    if (( $1 % 4 == 0 && $1 % 100 != 0 )); then
        return 0
    fi
    if (( $1 % 400 == 0 )); then
        return 0
    fi

    return 1
}

###################################################################
## 函数名称: IsValidDate()
## 函数功能: 判断一个日志是否合法
## 输入参数: 日期
## 返 回 值: 0 是; 1 不是;
###################################################################
IsValidDate()
{
    if [ $# -ne 1 ]; then
        return 1
    fi

    #输入串必须是8个字符
    iTmp=`echo $1 | awk '{print length($1)}'`
    if [ $iTmp -ne 8 ]; then
        return 1
    fi

    #判断是否是数字串
    IsDigit $1
    if [ $? -ne 0 ]; then
        return 1
    fi

    #获取年月日
    iYear=`echo $1 | cut -c1-4`
    iMon=`echo $1 | cut -c5-6`
    iMon=`expr $iMon - 1`
    iDay=`echo $1 | cut -c7-8`

    set -A iMaxDay 31 28 31 30 31 30 31 31 30 31 30 31
    IsLeapYear $iYear
    if [ $? -eq 0 ]; then
        iMaxDay[1]=29
    fi

    if [ $iMon -ge 12 -o $iMon -lt 0 ]; then
        return 1
    fi

    iDays=${iMaxDay[$iMon]}
    if [ $iDay -le 0 -o $iDay -gt $iDays ]; then
        return 1
    fi

    return 0
}

###################################################################
## 函数名称: GetNextDate()
## 函数功能: 实现给定日期的+1操作
## 输入参数: 日期
## 返 回 值: 0 成功; 1 失败;
###################################################################
GetNextDate()
{
    strNextDay=""
    if [ $# -ne 1 ]; then
        return 1
    fi

    IsValidDate $1
    if [ $? -ne 0 ]; then
        return 1
    fi

    #获取年月日
    iYear=`echo $1 | cut -c1-4`
    iMon=`echo $1 | cut -c5-6`
    iMon=`expr $iMon - 1`
    iDay=`echo $1 | cut -c7-8`

    #设置一个数组用来记录12个月的最大天数
    set -A iMaxDay 31 28 31 30 31 30 31 31 30 31 30 31
    IsLeapYear $iYear
    if [ $? -eq 0 ]; then
        iMaxDay[1]=29
    fi

    iDay=`expr $iDay + 1`
    if [ $iDay -gt ${iMaxDay[iMon]} ]; then
        iDay=`expr $iDay - ${iMaxDay[iMon]}`
        iMon=`expr $iMon + 1`
    fi

    if [ $iMon -gt 11 ]; then
        iMon=`expr $iMon - 12`
        iYear=`expr $iYear + 1`
    fi
    iMon=`expr $iMon + 1`

    strNextDate=`echo "$iYear $iMon $iDay" | awk '{ printf("%04d%02d%02d", $1, $2, $3) }'`

    return 0
}

###################################################################
## 函数名称: SafeExec()
## 函数功能: 执行一个命令, 执行失败, 就退出程序;
## 输入参数: 执行的命令及参数
## 返 回 值: NA;
###################################################################
SafeExec()
{
    #要求至少一个参数
    if [ $# -eq 0 ]; then
        exit 1
    fi

    #执行命令, 并判断返回值, 出错, 退出程序
    $*
    if [ $? -ne 0 ]; then
        exit 1
    fi
}
