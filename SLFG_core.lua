-- **************************************************
-- Addon: Silence LFG
-- Description: enable/disable LFG in a sleek way
-- Author: MarxWasRight-Fairbanks
-- **************************************************

local AddOn, SLFGcore = ...;

local frame_locked = false;

-- allow use of arrows inside windows
-- (so your char won't move in game)
for i = 1, NUM_CHAT_WINDOWS do
    _G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false)
end

--[[

TODO:
1. make frame
    - very small
    - will go under minimap (default)
    - will be moveable
    - NOT resizeable
    - A small rectangle with "LFG" and the X symbol
        - X symbol will appear when you are NOT in LFG
        -    [LFG (x)]
    - Maybe a checkbox instead of a symbol? Interactable
      control which is also visual feedback for addon status

--]]

-- **********************************************
-- ** START MAIN FRAME DEFINITION SECTION *******
-- **********************************************

--local UIMain = CreateFrame("Frame", "SLFG_MainFrame", UIParent, "SLFGFrameTemplate");
--[[
local UIMain = CreateFrame("Frame", "SLFG_MainFrame", UIParent, "BaseBasicFrameTemplate");
UIMain:SetSize(100, 40); -- width, height
UIMain:SetPoint("CENTER", UIParent, "CENTER"); -- point, relativeFrame, relativePoint, xOffset, yOffset

UIMain.title = UIMain:CreateFontString(nil, "OVERLAY");
UIMain.title:SetFontObject("GameFontHighlight");
UIMain.title:SetPoint("CENTER", UIMain.Bg, "CENTER", -15, 9);
UIMain.title:SetText("LFG--    ");

UIMain.cb1 = CreateFrame("CheckButton", "slfgCB1", UIMain, "ChatConfigCheckButtonTemplate");
UIMain.cb1:SetPoint("LEFT", UIMain.TitleBg, "CENTER", 0, 9);
UIMain.cb1.tooltip = "show/hide LFG channel";
local slfgCBState = false;
UIMain.cb1:SetScript("OnClick", 
                        function(self)
                            -- todo
                            slfgCBState = not slfgCBState;
                            if (slfgCBState) then
                                --local t, name = JoinChannelByName("LookingForGroup");
                                --JoinChannelByName("LookingForGroup");
                                local channel_type, channel_name = JoinChannelByName("LookingForGroup");
                                ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "LookingForGroup");
                                print("JOINED LFG");
                            else
                                LeaveChannelByName("LookingForGroup");
                                --print("LEFT LFG");
                            end
                        end)

--]]



local slfgBTNState = false;
UItogBtn = CreateFrame("Button", nil, UIMain, "GameMenuButtonTemplate");
UItogBtn:SetPoint("CENTER", UIMain, "TOP", 0, -80);
UItogBtn:SetSize(45, 30);
UItogBtn:SetText("LFG");
UItogBtn:SetNormalFontObject("GameFontNormalLarge");
UItogBtn:SetHighlightFontObject("GameFontHighlightLarge");
UItogBtn:SetScript("OnClick",
                                function(self, button)
                                    slfgBTNState = not slfgBTNState;
                                    if (slfgBTNState) then
                                        --local t, name = JoinChannelByName("LookingForGroup");
                                        --JoinChannelByName("LookingForGroup");
                                        local channel_type, channel_name = JoinChannelByName("LookingForGroup");
                                        ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "LookingForGroup");
                                        print("|cffff0000JOINED LFG|r");
                                    else
                                        LeaveChannelByName("LookingForGroup");
                                        --print("LEFT LFG");
                                    end
                                end);                  

-- **********************************************
-- ** SLASH CMD DEF SECTION *********************
-- **********************************************

-- quick access to frame stack for debugging
SLASH_FRAMESTK1 = "/fs";
SlashCmdList.FRAMESTK = function()
    LoadAddOn("Blizzard_DebugTools");
    FrameStackTooltip_Toggle();
end

SLASH_SLFG1 = "/slfg";

SlashCmdList["SLFG"] = function(msg)
    msg = string.upper(msg);
    if (msg == "HELP") then
        print("-Silence LFG Channel Addon-");
        print("'/slfg hide' to hide SLFG");
        print("'/slfg show' to show SLFG");
        print("'/slfg join' to join LFG");
        print("'/slfg leave' to leave LFG");
    elseif (msg == "SHOW") then
        UItogBtn:Show();
        print("SHOW");
    elseif (msg == "HIDE") then
        UItogBtn:Hide();
        print("HIDE");
    elseif (msg == "JOIN") then
        local channel_type, channel_name = JoinChannelByName("LookingForGroup");
        ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "LookingForGroup");
        print("JOIN");
    elseif (msg == "LEAVE") then
        LeaveChannelByName("LookingForGroup");
        print("LEAVE");
    elseif (msg == "UNLOCK") then
        -- TODO: toggle lock for position of SLFG's main frame
        UItogBtn:SetMovable(true);
        UItogBtn:RegisterForDrag("LeftButton");
        UItogBtn:SetScript("OnDragStart", UItogBtn.StartMoving);
        UItogBtn:SetScript("OnDragStop", UItogBtn.StopMovingOrSizing);
        print("LOCK");
    elseif (msg == "LOCK") then
        UItogBtn:StopMovingOrSizing();
        UItogBtn:RegisterForDrag();
        UItogBtn:SetMovable(false);
    end
end