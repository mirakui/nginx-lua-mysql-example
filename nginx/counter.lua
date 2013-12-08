-- based on sample code at https://github.com/agentzh/lua-resty-mysql

local mysql = require "resty.mysql"
local db, err = mysql:new()
if not db then
  ngx.log(ngx.ERR, "failed to instantiate mysql: ", err)
  return
end
local ok, err, errno, sqlstate = db:connect{
  host = "127.0.0.1",
  port = 3306,
  database = "lua",
  user = "lua",
  password = "lua",
  max_packet_size = 1024 * 1024 }

if not ok then
  ngx.log(ngx.ERR, "failed to connect: ", err, ": ", errno, " ", sqlstate)
  return
end

res, err, errno, sqlstate =
db:query("UPDATE counters SET value = value + 1 WHERE id = 1")
if not res then
  ngx.log(ngx.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ".")
  return
end

res, err, errno, sqlstate =
db:query("SELECT value FROM counters WHERE id = 1")
if not res then
  ngx.log(ngx.ERR, "bad result: ", err, ": ", errno, ": ", sqlstate, ".")
  return
end

ngx.say("counter: " .. res[1]["value"])

local ok, err = db:set_keepalive(10000, 100)
if not ok then
  ngx.log(ngx.ERR, "failed to set keepalive: ", err)
  return
end
