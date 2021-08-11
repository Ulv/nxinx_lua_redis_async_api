# Async HTTP API built with Nginx (openresty lua module) + Redis 

## The idea

1. Make request to API endpoint 
2. Request body goes to redis queue (for asynchronous processing)

## Usage

1. Clone
2. Run in project directory
 
```shell
> docker-compose up
```

3. Generate API access token for client. Run redis-cli from redis container

```
> redis-cli
127.0.0.1:6379> set api:access_token:12345 MTI4NTBANjEwMmZjMzhiOTM5YjQyODVhNDAwZmE3
OK
```

4. Make API requests
4.1. Success
```shell
 curl -v --request POST 'http://luatest.loc:8080/api/v1/add' \
--header 'API-Client-Id: 12345' \
--header 'Authorization: Bearer MTI4NTBANjEwMmZjMzhiOTM5YjQyODVhNDAwZmE3' \
--header 'Content-Type: application/json' \
--data-raw '{"user_id":123,"app_id":222,"item_id":4,"quantity":5}'
*   Trying ::1...
* TCP_NODELAY set
* Connected to luatest.loc (::1) port 8080 (#0)
> POST /api/v1/add HTTP/1.1
.....
>
* upload completely sent off: 53 out of 53 bytes
< HTTP/1.1 200 OK
< Server: nginx/1.21.1
< Date: Wed, 11 Aug 2021 13:54:47 GMT
< Content-Type: application/json
< Transfer-Encoding: chunked
< Connection: keep-alive
< Content-Type: application/json
<
{"status":"OK"}
```

4.2. Invalid client id, invalid api access token:

```shell
curl -v --request POST 'http://luatest.loc:8080/api/v1/add' \
--header 'API-Client-Id: 1234567' \
--header 'Authorization: Bearer MTI4NTBANjEwMmZjMzhiOTM5YjQyODVhNDAwZmE3' \
--header 'Content-Type: application/json' \
--data-raw '{"user_id":123,"app_id":222,"item_id":4,"quantity":5}'
* TCP_NODELAY set
* Connected to luatest.loc (::1) port 8080 (#0)
> POST /api/v1/add HTTP/1.1
...
>
* upload completely sent off: 53 out of 53 bytes
< HTTP/1.1 401 Unauthorized
< Server: nginx/1.21.1
< Date: Wed, 11 Aug 2021 13:56:35 GMT
< Content-Type: text/html
< Content-Length: 179
< Connection: keep-alive
<
<html>
<head><title>401 Authorization Required</title></head>
<body>
<center><h1>401 Authorization Required</h1></center>
<hr><center>nginx/1.21.1</center>
</body>
</html>
* Connection #0 to host luatest.loc left intact
* Closing connection 0
```