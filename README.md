```
git clone https://github.com/madumas/omnia-container
cd omnia-container
Place in the same folder
- caps.json
- keystore.json
- password.txt
Set the following ENV VAR
export ETH_FROM=0xB268c73D50336B8cF7d354277F7485eC2729F85c
export EXT_IP=9.9.9.9


docker build ./ -t omnia
docker-compose up omnia

```
