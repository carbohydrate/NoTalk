local Debug = false
local f = CreateFrame("Frame")

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
        f:UnregisterEvent("ADDON_LOADED");
    end
end

function f:TALKINGHEAD_REQUESTED(event)
    --local displayInfo, cameraID, vo, duration, lineNumber, numLines, name, text, isNewTalkingHead, textureKit = C_TalkingHead.GetCurrentLineInfo();
    local displayInfo, cameraID, vo = C_TalkingHead.GetCurrentLineInfo();

    if Debug then
        print("displayInfo: "..displayInfo, "cameraID: "..cameraID, "vo: "..vo)
    end
    --is displayInfo or vo a better id to use to decied if seen the talking head before?
    --going to start with vo id, incase same displayInfo is used for multiple vo, not sure if this happens or is the case.
    if NoTalkData[vo] then
        if NoTalkVerbose == true then
            print('Blocked a talking head.')
        end

        TalkingHeadFrame_CloseImmediately()
    else
        NoTalkData[vo] = true
    end
end

SLASH_NoTalk1 = "/nt"

SlashCmdList.NoTalk = function(msg)
    if msg == 'verbose' then
        if NoTalkVerbose == false then
            NoTalkVerbose = true
            print('Will print a chat message when a talking head is blocked.')
        elseif NoTalkVerbose == true then
            NoTalkVerbose = false
            print('Verbose is now disabled.')
        end
    end

    if msg == '' then
        print('No Talk... /nt')
        print('Options: verbose')
        if NoTalkVerbose == false then
            print('Verbose mode is off.')
        else
            print('Verbose mode is on.')
        end
    end
end

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("TALKINGHEAD_REQUESTED")
f:SetScript("OnEvent", f.OnEvent)
