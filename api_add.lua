local redis = require "resty.redis"
local red = redis:new()

red:set_timeouts(1000, 1000, 1000)

local ok, err = red:connect("172.16.238.10", 6379)

if not ok then
    local errMsg = '{"status":"ERR", "msg":"Backend connect error"}'
    ngx.status = 500
    return ngx.say(errMsg)
end

local msg = ngx.req.get_body_data()

red:lpush("req_queue",msg)

return ngx.say('{"status":"OK"}')
