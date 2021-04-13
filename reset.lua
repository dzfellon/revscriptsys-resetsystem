local resetSys = TalkAction("!reset")

local config = {
    backToLevel = 8,
    redskull = false, -- need to be without redskull to reset?
    battle = true, -- need to be without battle to reset?
    pz = false, -- need to be in protect zone to reset?
    stages = {
        {resets = 4, level = 350, premium = 330},
        {resets = 9, level = 355, premium = 340},
        {resets = 14, level = 360, premium = 355},
        {resets = 19, level = 365, premium = 360},
        {resets = 24, level = 380, premium = 370},
        {resets = 29, level = 390, premium = 380},
        {resets = 34, level = 410, premium = 400},
        {resets = 39, level = 430, premium = 420},
        {resets = 44, level = 450, premium = 440},
        {resets = 49, level = 480, premium = 470},
        {resets = 54, level = 510, premium = 500},
        {resets = 59, level = 550, premium = 540},
        {resets = 64, level = 590, premium = 580},
        {resets = 69, level = 630, premium = 620},
        {resets = 74, level = 680, premium = 670},
        {resets = 79, level = 730, premium = 720},
        {resets = 84, level = 780, premium = 770},
        {resets = 89, level = 860, premium = 840},
        {resets = 94, level = 930, premium = 910},
        {resets = 2^1024, level = 1010, premium = 990}
    }
}

function resetSys.onSay(player, words, param)
    local function getExperienceForLevel(lv)
        lv = lv - 1
        return ((50 * lv * lv * lv) - (150 * lv * lv) + (400 * lv)) / 3
    end
    local function getPlayerResets()
        local resets = player:getStorageValue(500)
        return resets < 0 and 0 or resets
    end
   
    local function doPlayerAddResets(count)
        player:setStorageValue(500, getPlayerResets() + count)
    end
   
    if config.redskull and player:getSkull() == 4 then
        player:sendCancelMessage("You need to be without red skull to reset.")
        return false
    elseif config.pz and not getTilePzInfo(player:getPosition()) then
        player:sendCancelMessage("You need to be in protection zone to reset.")
        return false
    elseif config.battle and player:getCondition(CONDITION_INFIGHT) then
        player:sendCancelMessage("You need to be without battle to reset.")
        return false
    end
   
    local resetLevel = 0
    for x, y in ipairs(config.stages) do
        if getPlayerResets() <= y.resets then
            resetLevel = player:isPremium() and y.premium or y.level
            break
        end
    end
   
    if getPlayerLevel(player) < resetLevel then
        player:sendCancelMessage("You need level " .. resetLevel .. " or more to reset.")
        return false
    end
   
    doPlayerAddResets(1)
    local healthMax, manaMax, health, mana = player:getMaxHealth(), player:getMaxMana(), player:getHealth(), player:getMana()
    player:removeExperience(getExperienceForLevel(player:getLevel()) - getExperienceForLevel(config.backToLevel))
    player:setMaxHealth(healthMax)
    player:setMaxMana(manaMax)
    player:addHealth(health)
    player:addMana(mana)
    player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Now you have " .. getPlayerResets() .. " " .. (getPlayerResets() == 1 and "reset" or "resets") .. ".")
    return false
end

resetSys:register() 
