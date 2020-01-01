local DMW = DMW

DMW.Tables.guid2pointer = {}
DMW.Tables.pointer2guid = {}

hooksecurefunc(DMW, "Remove", function(pointer)
    if DMW.Tables.pointer2guid[pointer] ~= nil then
        DMW.Tables.guid2pointer[DMW.Tables.pointer2guid[pointer]] = nil
        DMW.Tables.pointer2guid[pointer] = nil
    end
end)

function guid2pointer(guid)
    return DMW.Tables.guid2pointer[guid]
end

function pointer2guid(pointer)
    return DMW.Tables.pointer2guid[pointer]
end
