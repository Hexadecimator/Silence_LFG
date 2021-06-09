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
1. make frame:
    - very small
    - will go under minimap (default)
    - will be moveable
    - NOT resizeable
    - A small rectangle with "LFG" and the X symbol
        - X symbol will appear when you are NOT in LFG
        -    [LFG (x)]
    - Maybe a checkbox instead of a symbol? Interactable
      control which is also visual feedback for addon status

2. Save data
    - window x,y position and restore upon reload
        - x,y info will be saved when user locks window
    - state of LFG (was it disabled/enabled when you logged off)

WISHLIST:
1. AddOn options page with font/button sizing/button texturing options

--]]

-- **********************************************
-- ** START MAIN FRAME DEFINITION SECTION *******
-- **********************************************

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
                                        print("W-H-L-R");
                                        print(UItogBtn:GetWidth());
                                        print(UItogBtn:GetHeight());
                                        print(UItogBtn:GetLeft());
                                        print(UItogBtn:GetRight());
                                        -- UItogBtn:SetWidth(w);
                                        -- UItogBtn:SetHeight(h);
                                        -- UItogBtn:SetLeft(l);
                                        -- UItogBtn:SetRight(r);
                                        print("|cffff0000JOINED LFG|r");
                                    else
                                        LeaveChannelByName("LookingForGroup");
                                        --print("LEFT LFG");
                                        print("|cffff0000LEFT LFG|r");
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
        print("--Silence LFG Channel Addon--");
        print("'/slfg hide' to hide SLFG");
        print("'/slfg UL' to unlock the frame");
        print("'/slfg L' to lock the frame");
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
    elseif (msg == "UL") then
        -- TODO: toggle lock for position of SLFG's main frame
        UItogBtn:SetMovable(true);
        UItogBtn:RegisterForDrag("LeftButton");
        UItogBtn:SetScript("OnDragStart", UItogBtn.StartMoving);
        UItogBtn:SetScript("OnDragStop", UItogBtn.StopMovingOrSizing);
        UItogBtn:SetUserPlaced(true);
        print("SLFG FRAME UNLOCKED");
    elseif (msg == "L") then
        UItogBtn:StopMovingOrSizing();
        UItogBtn:RegisterForDrag();
        UItogBtn:SetMovable(false);
        print("SLFG FRAME LOCKED");
    elseif (msg == "Q") then
        print("W-H-L-R");
        print(UItogBtn:GetWidth());
        print(UItogBtn:GetHeight());
        print(UItogBtn:GetLeft());
        print(UItogBtn:GetRight());
    end
end