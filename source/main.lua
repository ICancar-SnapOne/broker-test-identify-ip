CONNECTION_STATUS_PROPERTY_NAME = "Connection status"
IP_ADDRESS_PROPERTY_NAME = "IP Address"

IP_BINDING_ID = 6001
PORT = 55443

reconnectTimer = nil
pingTimer = nil
onlineStatus = nil

function OnDriverLateInit()
    print("OnDriverLateInit")
    UpdateIPAddressProperty()
    C4:NetConnect(IP_BINDING_ID, PORT, "TCP")
    onlineStatus = C4:GetNetworkBindingsByDevice(53).networkbindings[1].status
    print("Online status: ", onlineStatus)
    C4:UpdateProperty(CONNECTION_STATUS_PROPERTY_NAME, onlineStatus)
end

function OnConnectionStatusChanged(idBinding, nPort, strStatus)
    print("OnConnectionStatusChanged ", idBinding, nPort, strStatus)
    onlineStatus = C4:GetNetworkBindingsByDevice(53).networkbindings[1].status
    C4:UpdateProperty(CONNECTION_STATUS_PROPERTY_NAME, onlineStatus)
    UpdateIPAddressProperty()
    if (idBinding == IP_BINDING_ID) then
      if (strStatus == "ONLINE") then
        StopReconnectTimer()
        StartPingTimer()
      else
        StartReconnectTimer()
        StopPingTimer()
      end
      C4:UpdateProperty(CONNECTION_STATUS_PROPERTY_NAME, strStatus)
    end
end

function StartReconnectTimer()
    print("Network connection lost. Starting reconnect timer...")
    if (reconnectTimer == nil) then
    reconnectTimer = C4:SetTimer(10000, function()
                                            print("Reconnect timer expired. Trying to connect in 10s.")
                                            C4:NetDisconnect(IP_BINDING_ID, PORT)
                                            C4:NetConnect(IP_BINDING_ID, PORT, "TCP")
                                        end, true)
    end
end

function StopReconnectTimer()
    if(reconnectTimer) then
        reconnectTimer:Cancel()
        reconnectTimer = nil
    end
end

function UpdateIPAddressProperty()
    local ipAddress = C4:GetMyNetworkAddress()
    C4:UpdateProperty(IP_ADDRESS_PROPERTY_NAME, ipAddress)
end

function StartPingTimer()
    print("Network connection is up. Starting pinging timer...")
    if (pingTimer == nil) then
        pingTimer = C4:SetTimer(60000, function()
                                        print("Ping every 60s...")
                                     end, true)
    end
end

function StopPingTimer()
    print("Stop ping timer...")
    if(pingTimer) then
        pingTimer:Cancel()
        pingTimer = nil
    end
end