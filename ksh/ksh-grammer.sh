#!/bin/ksh

##设置对信号的处理
trap 'echo "program is end by Ctrl+C";exit' 2


echo "====================================================================================================="
iVar=2
############################# if 语法 #######################################
if [ $iVar -gt 1 ]; then
    echo "If statement test OK"
fi

############################# while 语法 ####################################
iVar=3
while [ $iVar -lt 4 ]
do
    echo "While statement test OK"
    iVar=`expr $iVar + 1`
done

############################# for 语法 ######################################
varList="1 2"
for iOne in $varList
do
    echo "for statement test : iOne = $iOne"
done

############################# until 语法 #####################################
iVar=1
until [ $iVar -gt 1 ]
do
    echo "until statement test OK"
    ((iVar = $iVar + 1))
done

############################# case 语法 #####################################
str="6"
case $str in
    "2")
        echo "case statement test: \$str = 2"
        ;;
    "6")
        echo "case statement test: \$str = 6"
        ;;
    *)
        echo "case statement test: not valid value"
        ;;
esac

############################# 函数 语法 #####################################
iVar=0
MyFunc()
{
    if [ $1 -lt 1 ]; then
        echo "MyFunc test : first variable > 1"
        return 1
    else
        echo "MyFunc test : first variable <=1"
        return 0
    fi
}
MyFunc $iVar
if [ $? -ne 0 ]; then
    echo "MyFunc return value != 0"
fi
############################# 特殊参数 语法 #####################################
echo "-----------------------------------------"
echo "\$0 = $0"  #当前程序名
echo "\$# = $#"  #参数个数
echo "\$* = $*"  #所有参数, 当作一个参数
echo "\$@ = $@"  #所有参数, 当作多个参数
echo "\$? = $?"  #上个命令或函数的返回值
echo "-----------------------------------------"

############################# 数学运算语法 #################################
iVar=1
((iVar++))
echo "\$iVar++ = $iVar"

iVar=`expr $iVar + 1`
echo "expr result = $iVar"
############################# 读取文件行到变量 语法 #################################
strFile="readme.txt"
oldifs=$IFS
IFS='|'        #系统的分隔符变量
iLine=0
while read str
do
    ((iLine++))
    echo "line $iLine : $str"
    for oneStr in $str
    do
        if [ "-${oneStr}" = "-" ];then
            continue
        fi

        echo $oneStr
    done
done < $strFile
IFS=$oldifs

############################# 分离字段操作 语法 #################################
str="1|2|3|4|5"
fc=`echo $str | tr '|' '\n' | wc -l`        #查看有多少个字段
echo "fc="$fc
fd3=`echo $str|cut -d'|' -f3`               #取第三个字段的内容
echo "fd3="$fd3
fd3=`echo $str | awk -F' ' '{print $3}'`    #使用awk取第三个字段
echo $fd3

#查看指定字符串的字符串长度
str="123"
cnt=`echo $str|awk '{print length($0)}'`
cnt=${#str}
echo $cnt

#awk使用方法
filename="aa.txt"
awk 'BEGIN{ print "begin...." }; { printf("line %d:%s\n", NR, $2) }; END{ print "total lines:"NR }' $filename

#awk可以打开2个文件

echo "====================================================================================================="
