#!/bin/bash

# 如果定义了 RPC_SECRET 则重置RPC密码
if [ -n "${RPC_SECRET}" ]; then
    echo ${RPC_SECRET} > ${ROOT_PATH}/initAria2Password
    sed -i "s/^rpc-secret=.*/rpc-secret=${RPC_SECRET}/" aria2.conf
    echo "RPC密码已重置为: $RPC_SECRET"
fi

# 增强补丁（编译的增强版本才支持）
sed -i "s/^max-connection-per-server=.*/max-connection-per-server=64/" aria2.conf

# 执行主命令
exec "$@"