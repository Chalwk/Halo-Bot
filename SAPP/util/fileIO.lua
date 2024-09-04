local fileIO = {}

function fileIO:readFile(filePath)
    local file, err = io.open(filePath, "r")
    if file then
        local content = file:read("*all")
        file:close()
        return content == "" and {} or content
    else
        return nil, err
    end
end

function fileIO:writeFile(filePath, content)
    local file, err = io.open(filePath, "w")
    if file then
        local jsonContent = self.json:encode_pretty(content)
        file:write(jsonContent)
        file:close()
    else
        return nil, err
    end
end

return fileIO