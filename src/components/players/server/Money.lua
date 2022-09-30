RedFW.Server.Components.Players.accounts = {}
RedFW.Server.Components.Players.accounts.__index = RedFW.Server.Components.Players.accounts
RedFW.Server.Components.Players.accounts.list = {}
setmetatable(RedFW.Server.Components.Players.accounts, {
    __call = function (_, serverId, cash, bank)
        local self = setmetatable({}, RedFW.Server.Components.Players.accounts)
        self.cash = cash
        self.bank = bank
        self.serverId = serverId
        RedFW.Server.Components.Players.accounts.list[serverId] = self
        return self
    end,
})

function RedFW.Server.Components.Players.accounts:get(serverId)
    return RedFW.Server.Components.Players.accounts.list[serverId]
end

function RedFW.Server.Components.Players.accounts:addCash(amount)
    self.cash = self.cash + amount
    RedFW.Shared.Event:triggerClientEvent('receiveMoney', self.serverId, self.cash, self.bank)
end

function RedFW.Server.Components.Players.accounts:removeCash(amount)
    self.cash = self.cash - amount
    RedFW.Shared.Event:triggerClientEvent('receiveMoney', self.serverId, self.cash, self.bank)
end

function RedFW.Server.Components.Players.accounts:addBank(amount)
    self.bank = self.bank + amount
    RedFW.Shared.Event:triggerClientEvent('receiveMoney', self.serverId, self.cash, self.bank)
end

function RedFW.Server.Components.Players.accounts:removeBank(amount)
    self.bank = self.bank - amount
    RedFW.Shared.Event:triggerClientEvent('receiveMoney', self.serverId, self.cash, self.bank)
end

RedFW.Shared.Event:registerEvent('getAccounts', function()
    local _src = source
    local account = RedFW.Server.Components.Players.accounts:get(_src)
    RedFW.Shared.Event:triggerClientEvent('receiveAccounts', _src, account)
end)