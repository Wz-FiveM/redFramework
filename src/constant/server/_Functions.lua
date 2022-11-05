RedFW.Server.Functions = {}

function RedFW.Server.Functions:file_directoryExists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    else
        return false
    end
end

function RedFW.Server.Functions:file_directoryCreate(path)
    os.execute(("mkdir %s"):format(path))
end

function RedFW.Server.Functions:file_exists(file)
    local f = io.open(file, "rb")
    if f then
        f:close()
    end
    return f ~= nil
end

function RedFW.Server.Functions:file_append(file, text)
    local f = io.open(file, "a")
    f:write(text)
    f:close()
end

function RedFW.Server.Functions:file_read(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

function RedFW.Server.Functions:file_write(file, text)
    local f = io.open(file, "w")
    f:write(text)
    f:close()
end

function RedFW.Server.Functions:log(message)
    print(message)
end