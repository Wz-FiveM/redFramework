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

---get
---@param serverId number
---@return table
---@public
function RedFW.Server.Components.Players.accounts:get()
    return RedFW.Server.Components.Players.accounts.list[self.serverId]
end

---addCash
---@param self table
---@param amount number
---@return void
---@public
function RedFW.Server.Components.Players.accounts:addCash(amount)
    self.cash = self.cash + amount
    RedFW.Shared.Event:triggerClientEvent('receiveMoney', self.serverId, self.cash, self.bank)
end

---removeCash
---@param self table
---@param amount number
---@return void
---@public
function RedFW.Server.Components.Players.accounts:removeCash(amount)
    self.cash = self.cash - amount
    RedFW.Shared.Event:triggerClientEvent('receiveMoney', self.serverId, self.cash, self.bank)
end

---getCash
---@param self table
---@return void
---@public
function RedFW.Server.Components.Players.accounts:getCash()
    return self.cash
end

---getBank
---@param self table
---@return void
---@public
function RedFW.Server.Components.Players.accounts:getBank()
    return self.bank
end

---addBank
---@param self table
---@param amount number
---@return void
---@public
function RedFW.Server.Components.Players.accounts:addBank(amount)
    self.bank = self.bank + amount
    RedFW.Shared.Event:triggerClientEvent('receiveMoney', self.serverId, self.cash, self.bank)
end

---removeBank
---@param self table
---@param amount number
---@return void
---@public
function RedFW.Server.Components.Players.accounts:removeBank(amount)
    self.bank = self.bank - amount
    RedFW.Shared.Event:triggerClientEvent('receiveMoney', self.serverId, self.cash, self.bank)
end

RedFW.Shared.Event:registerEvent('getAccounts', function()
    local _src = source
    local player = RedFW.Server.Components.Players:get(_src)
    RedFW.Shared.Event:triggerClientEvent('receiveAccounts', _src, player.account:get())
end)