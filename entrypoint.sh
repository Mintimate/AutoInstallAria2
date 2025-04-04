#!/bin/bash

# 如果定义了 RPC_SECRET 则重置RPC密码
if [ -n "${RPC_SECRET}" ]; then
    echo ${RPC_SECRET} > ${ROOT_PATH}/initAria2Password
    sed -i "s/^rpc-secret=.*/rpc-secret=${RPC_SECRET}/" aria2.conf
    echo "RPC密码已重置为: $RPC_SECRET"
fi

# 执行主命令
exec "$@"