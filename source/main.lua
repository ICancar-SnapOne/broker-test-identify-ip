function OnDriverLateInit()
    print("OnDriverLateInit")
    local ipAddress = C4:GetMyNetworkAddress()
    C4:UpdateProperty("IP Address", Properties["IP Address"])
    if ipAddress then
        local onlineStatus
        if ipAddress == Properties["IP Address"] then
            onlineStatus = "ONLINE"
        else
            onlineStatus = "OFFLINE"
        end
        C4:UpdateProperty("Network Connection Status", onlineStatus)
    else
        C4:UpdateProperty("Network Connection Status", "")
    end
end
 
 
function OnNetworkBindingChanged(idBinding, isBound)
    local ipAddress = C4:GetMyNetworkAddress()
    local onlineStatus
    if ipAddress == Properties["IP Address"] then
        onlineStatus = "ONLINE"
    else
        onlineStatus = "OFFLINE"
    end
    C4:UpdateProperty("Network Connection Status", onlineStatus)
end