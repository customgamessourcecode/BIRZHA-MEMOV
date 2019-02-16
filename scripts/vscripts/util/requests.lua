--[[
Author: uBluewolfu
Special For Birzha Memov.	
© Copyright 2018. All Right Reserved. The BirzhaMemov Development Team. 
Function to send and request data.
-]]



--Принимаем информацию с сервера
function RequestData(url, callback)
    local req = CreateHTTPRequestScriptVM("GET", url)
    req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", GetDedicatedServerKey("v1"))
    req:Send(function(res)
        if res.StatusCode ~= 200 then
            print("[Birzha Request] Не удалось подключится к серверу")
            return
        end

        if callback then
            local obj, pos, err = json.decode(res.Body)
            callback(obj)
        end
    end)
end

function SendData(url, data, callback)
	if not GameRules:IsCheatMode() or IsInToolsMode() then
		AUTH_KEY = GetDedicatedServerKey('1')
		local token = AUTH_KEY
		local req = CreateHTTPRequestScriptVM("POST", url)
		local encoded = json.encode(data)
		local encoded_token = json.encode(token)
		print("[Birzha Request] Data was encoded!")
		req:SetHTTPRequestHeaderValue("Dedicated-Server-Key", GetDedicatedServerKey("v1"))
		req:SetHTTPRequestGetOrPostParameter('data', encoded)
		req:SetHTTPRequestGetOrPostParameter('token', encoded_token)
		req:Send(function(res)
			if res.StatusCode ~= 200 then
				print("[Birzha Request] Не удалось подключится к серверу")
				return
			end

			if callback then
				local obj, pos, err = json.decode(res.Body)
				callback(obj)
			end
		end)
	end
end
