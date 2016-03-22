-- Extension description
function descriptor()
  return {
    title = "Save Time";
    version = "1.0";
    author = "Parker Miller";
    shortdesc = "Save elapsed time.";
    description = "Logs the current video time in the video directory.";
  }
end

function activate()
  local input = vlc.object.input()
  if input then
    local elapsed = vlc.var.get(input, "time")
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = math.floor(elapsed % 60)

    if (seconds < 10) then
      seconds = "0" .. seconds
    end

    if (minutes < 10) then
      minutes = "0" .. minutes
    end

    local uri = vlc.strings.decode_uri(vlc.input.item():uri()) -- Format: file:///dir1/dir2/file.ext
    local localFileName = string.sub(uri, (uri:match'^.*()/') + 1) -- Finds the last occurrence of '/' and retrieves everything past that point
    local filePath = string.gsub(uri, "file:///", "")          -- Format: dir1/dir2/file.ext
    local directory = string.gsub(filePath, "/[^/]*$", "")     -- Format: dir1/dir2         Remove last / and everything after it to leave the directory.

    io.output(directory .. "/" .. localFileName .. ".txt")
    io.write(elapsed .. "\n" .. minutes .. ":" .. seconds)
    io.close()
  end
  vlc.deactivate()
end
