local Debug = false
local f = CreateFrame("Frame")

local function CloseTalkingHead()
    TalkingHeadFrame:CloseImmediately()
end

local function CheckVerboseMessage()
    if NoTalkVerbose == true then
        print("NoTalk: Blocked a talking head.")
    end
end

function f:OnEvent(event, ...)
    self[event](self, event, ...)
end

function f:ADDON_LOADED(event, addOnName)
    if addOnName == "NoTalk" then
        if NoTalkVerbose == nil then
            NoTalkVerbose = false
        end
        if NoTalkData == nil then
            NoTalkData = {}
        end
        if NoTalkOnce == nil then
            NoTalkOnce = false
        end
        f:UnregisterEvent("ADDON_LOADED")
    end
end

function f:TALKINGHEAD_REQUESTED(event)
    --local displayInfo, cameraID, vo, duration, lineNumber, numLines, name, text, isNewTalkingHead, textureKit = C_TalkingHead.GetCurrentLineInfo()
    local displayInfo, cameraID, vo = C_TalkingHead.GetCurrentLineInfo()

    if Debug then
        print("displayInfo: "..displayInfo, "cameraID: "..cameraID, "vo: "..vo)
    end

    if NoTalkOnce then
        --is displayInfo or vo a better id to use to decied if seen the talking head before?
        --going to start with vo id, incase same displayInfo is used for multiple vo, not sure if this happens or is the case.
        if NoTalkData[vo] then
            CheckVerboseMessage()
            CloseTalkingHead()
        else
            if vo then
                NoTalkData[vo] = true
            end
        end
    else
        CheckVerboseMessage()
        CloseTalkingHead()
    end
end

SLASH_NoTalk1 = "/nt"

SlashCmdList.NoTalk = function(msg)
    if msg == "verbose" then
        if NoTalkVerbose == false then
            NoTalkVerbose = true
            print("NoTalk: Will print a chat message when a talking head is blocked.")
        elseif NoTalkVerbose == true then
            NoTalkVerbose = false
            print("NoTalk: Verbose is now disabled.")
        end
    end

    if msg == "once" then
        if NoTalkOnce == false then
            NoTalkOnce = true
            print("NoTalk: Will show talking heads that you have not seen before once.")
        else
            NoTalkOnce = false
            print("NoTalk: Will never show talking heads.")
        end
    end

    if msg == "" then
        print("No Talk... /nt")
        print("Options: verbose | once")
        if NoTalkVerbose == false then
            print("Verbose mode is off.")
        else
            print("Verbose mode is on.")
        end
        if NoTalkOnce == false then
            print("Once mode is off.")
        else
            print("Once mode is on.")
        end
    end
end

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("TALKINGHEAD_REQUESTED")
f:SetScript("OnEvent", f.OnEvent)
