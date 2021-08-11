local apiKeyHeader = ngx.req.get_headers()["Authorization"] or ''
local clientId = ngx.req.get_headers()["API-Client-Id"] or ''
local token = apiKeyHeader:gsub("%Bearer ", ""):match'^%s*(.*%S)' or ''
local redis = require "resty.redis"
local red = redis:new()
red:set_timeouts(1000, 1000, 1000)

-- TODO: Throttling

-- Check api key
if (token == '' or clientId == '')
then
    return ngx.exit(401)
end

local ok, err = red:connect("172.16.238.10", 6379)

if not ok then
    local errMsg = '{"status":"ERR", "msg":"Backend connect error"}'
    ngx.status = 500
    return ngx.say(errMsg)
end

-- red:lpush("req_queue",msg)

local redisTokenKey = "api:access_token:"..clientId
local clientToken = red:get(redisTokenKey)

if clientToken ~= token
then
    return ngx.exit(401)
end

-- ngx.say(redisTokenKey)
