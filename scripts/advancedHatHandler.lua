local function resolveHairGroups(species, hairGroups, mode)
    if mode == "xSB" or mode == "SE/oSB" then
        if not root.assetExists then root.assetExists = root.assetOrigin end
        local speciesConfigPath = "/species/" .. species .. ".species"
        if root.assetExists(speciesConfigPath) then
            local speciesConfig = root.assetJson(speciesConfigPath)
            local facialHairGroup = speciesConfig.genders[1].facialHairGroup
            local hairType = speciesConfig.genders[1].hair[1] or "0"
            local facialHairType = facialHairGroup ~= "" and (speciesConfig.genders[1].facialHair[1] or hairType)
                or hairType
            facialHairGroup = facialHairGroup ~= "" and facialHairGroup or "hair"
            hairGroups[species] = {
                hairType = hairType,
                facialHairType = facialHairGroup,
                facialHairGroup = facialHairGroup,
            }
        end
    else
        -- FezzedOne: If xSB or SE/oSB is not detected, a harmless error may be logged if the species file is not in the
        -- expected location, but resolution will still work properly.
        if not root.assetExists then root.assetExists = root.assetOrigin end
        local speciesConfigPath = "/species/" .. species .. ".species"
        if pcall(root.assetJson, speciesConfigPath) then
            local speciesConfig = root.assetJson(speciesConfigPath)
            local facialHairGroup = speciesConfig.genders[1].facialHairGroup
            local hairType = speciesConfig.genders[1].hair[1] or "0"
            local facialHairType = facialHairGroup ~= "" and (speciesConfig.genders[1].facialHair[1] or hairType)
                or hairType
            facialHairGroup = facialHairGroup ~= "" and facialHairGroup or "hair"
            hairGroups[species] = {
                hairType = hairType,
                facialHairType = facialHairGroup,
                facialHairGroup = facialHairGroup,
            }
        end
    end
end

local function getVersion(isUnderlay, useAnimatedHead)
    -- FezzedOne: Added type checks.
    local hatToCheck = useAnimatedHead and "innerHead" or (isUnderlay and "currentHatUnderlay" or "currentHat")
    if not self[hatToCheck] then return nil end
    local params = self[hatToCheck].parameters
    if params and type(params.advancedHatter) == "table" then
        return params.advancedHatter.version or 1
    else
        return nil
    end
end

local function getHeadItem()
    local slotName = "headCosmetic"
    local currentItem = player.equippedItem(slotName)
    if currentItem then currentItem.parameters = currentItem.parameters or {} end

    if not currentItem then
        slotName = "head"
        currentItem = player.equippedItem(slotName)
        if currentItem then currentItem.parameters = currentItem.parameters or {} end
    end

    if not currentItem then
        if self.innerHead then return nil, self.innerHead, self.mode end
        if self.innerHead then self.innerHead.parameters = self.innerHead.parameters or {} end
    else
        return slotName, currentItem, "headItem"
    end
end

local function getChestItem()
    local slotName = "chestCosmetic"
    local currentItem = player.equippedItem(slotName)
    if currentItem then currentItem.parameters = currentItem.parameters or {} end

    if not currentItem then
        slotName = "chest"
        currentItem = player.equippedItem(slotName)
        if currentItem then currentItem.parameters = currentItem.parameters or {} end
    end
    return slotName, currentItem
end

local function getLegsItem()
    local slotName = "legsCosmetic"
    local currentItem = player.equippedItem(slotName)
    if currentItem then currentItem.parameters = currentItem.parameters or {} end

    if not currentItem then
        slotName = "legs"
        currentItem = player.equippedItem(slotName)
        if currentItem then currentItem.parameters = currentItem.parameters or {} end
    end
    return slotName, currentItem
end

local function getBackItem()
    local slotName = "backCosmetic"
    local currentItem = player.equippedItem(slotName)
    if currentItem then currentItem.parameters = currentItem.parameters or {} end

    if not currentItem then
        slotName = "back"
        currentItem = player.equippedItem(slotName)
        if currentItem then currentItem.parameters = currentItem.parameters or {} end
    end
    return slotName, currentItem
end

local function getHeadUnderlayItem()
    local slotName = "headCosmetic"
    local currentItem = player.equippedItem(slotName)

    if currentItem then
        slotName = "head"
        currentItem = player.equippedItem(slotName)
        if currentItem then currentItem.parameters = currentItem.parameters or {} end
        return slotName, currentItem
    else
        return nil, nil
    end
end

local function getChestUnderlayItem()
    local slotName = "chestCosmetic"
    local currentItem = player.equippedItem(slotName)

    if currentItem then
        slotName = "chest"
        currentItem = player.equippedItem(slotName)
        if currentItem then currentItem.parameters = currentItem.parameters or {} end
        return slotName, currentItem
    else
        return nil, nil
    end
end

local function getLegsUnderlayItem()
    local slotName = "legsCosmetic"
    local currentItem = player.equippedItem(slotName)

    if currentItem then
        slotName = "legs"
        currentItem = player.equippedItem(slotName)
        if currentItem then currentItem.parameters = currentItem.parameters or {} end
        return slotName, currentItem
    else
        return nil, nil
    end
end

local function getBackUnderlayItem()
    local slotName = "backCosmetic"
    local currentItem = player.equippedItem(slotName)

    if currentItem then
        slotName = "back"
        currentItem = player.equippedItem(slotName)
        if currentItem then currentItem.parameters = currentItem.parameters or {} end
        return slotName, currentItem
    else
        return nil, nil
    end
end

local function getEmote()
    local portrait = world.entityPortrait(player.id(), "head")
    local emote = "idle"
    for _, v in pairs(portrait) do
        if string.find(v.image, "/emote.png") then
            emote =
                string.match(v.image, "%/humanoid%/%w+%/emote.png:%w+%.+%d+"):gsub("%/humanoid%/%w+%/emote.png:", "")
            break
        end
    end

    return emote
end

local function getFrame(direction, emoteFrame, isUnderlay, useAnimatedHead)
    local directives = ""
    local currentDirectionName = direction > 0 and "default" or "reverse"

    -- Check for aliases
    if self.aliases[emoteFrame] then emoteFrame = self.aliases[emoteFrame] end

    local emote = emoteFrame:match("[^%d%W]+")
    local frame = tonumber(emoteFrame:match("%d+")) or 1

    local hatToCheck = useAnimatedHead and "innerHead" or (isUnderlay and "currentHatUnderlay" or "currentHat")
    if not self[hatToCheck] then return "" end

    -- Out of border check
    local params = self[hatToCheck].parameters or {}
    local baseDirectives = type(params.directives) == "string" and params.directives or ""
    if type(params.advancedHatter) ~= "table" then return baseDirectives end

    -- FezzedOne: Added complete type checks to ensure this function never throws an error on arbitrary item data.
    -- As a bonus, the `"directives"` parameter on head items is used if any (or all) animation directive strings are missing.
    if getVersion(isUnderlay, useAnimatedHead) == 2 then
        local dirSpec = params.advancedHatter[currentDirectionName]
        if type(dirSpec) ~= "table" then return baseDirectives end

        local emoteSpec = dirSpec[self.emotes[emote]]
        frame = math.min(frame, #emoteSpec)

        directives = type(emoteSpec[frame]) == "string" and emoteSpec[frame] or baseDirectives
    else -- previous version
        local emoteSpec = params.advancedHatter[self.emotes[emote]]
        if type(emoteSpec) ~= "table" then return baseDirectives end

        frame = math.min(frame, #emoteSpec)

        local frameDirectives = emoteSpec[frame]
        if type(frameDirectives) == "table" then
            if direction > 0 then
                directives = type(frameDirectives.default) == "string" and frameDirectives.default or baseDirectives
            else
                directives = type(frameDirectives.reverse) == "string" and frameDirectives.reverse or baseDirectives
            end
        else
            directives = type(frameDirectives) == "string" and frameDirectives or baseDirectives
        end
    end

    return directives
end

function init()
    self.previousEmote = "idle"
    self.previousPosition = world.entityPosition(player.id())
    self.previousDirection = "none"

    local hairGroups = {
        human = {
            hairType = "male54",
            facialHairType = "male54",
            facialHairGroup = "hair",
        },
        floran = {
            hairType = "11",
            facialHairType = "11",
            facialHairGroup = "hair",
        },
        hylotl = {
            hairType = "20",
            facialHairType = "20",
            facialHairGroup = "hair",
        },
        avian = {
            hairType = "20",
            facialHairType = "1",
            facialHairGroup = "fluff",
        },
        glitch = {
            hairType = "0",
            facialHairType = "0",
            facialHairGroup = "hair",
        },
        apex = {
            hairType = "1",
            facialHairType = "1",
            facialHairGroup = "beardmale",
        },
        novakid = {
            hairType = "male0",
            facialHairType = "0",
            facialHairGroup = "brand",
        },
        fenerox = { -- Added fenerox support.
            hairType = "male1",
            facialHairType = "male1",
            facielHairGroup = "hair",
        },
        default = {
            hairType = "0",
            facialHairType = "0",
            facielHairGroup = "hair",
        },
    }

    self.slotName = "headCosmetic"

    self.emotes = {
        idle = "idle",
        blink = "blink",
        wink = "wink",
        happy = "happy",
        sleep = "blink",
        sad = "sad",
        blabber = "blabber",
        shout = "shout",
        neutral = "neutral",
        annoyed = "annoyed",
        laugh = "laugh",
        oh = "surprised",
        oooh = "shocked",
        eat = "shout",
    }

    self.aliases = root.assetJson("/humanoid/emote.frames").aliases
    local species = player.species()
    if not hairGroups[species] then resolveHairGroups(species, hairGroups, mode) end

    self.mode = _ENV["xsb"] and "xSB" 
            or _ENV["player"]["setFacialHairType"] and "SE/oSB"
            or _ENV["neon"] and "Neon"
            or nil

    local head = player.getProperty("animatedHead") -- Note: Name of the hat to use as the animated head sprite.
    if type(head) ~= "string" then
        self.headSpriteName = nil
        self.innerHead = nil
        if self.mode == "xSB" or self.mode == "SE/oSB" then
            local oldHair = player.getProperty("xHatter::oldHairParams")
            if type(oldHair) == "table" then
                if type(oldHair.hairType) == "string" then player.setHairType(oldHair.hairType) end
                if type(oldHair.facialHairGroup) == "string" then player.setFacialHairGroup(oldHair.facialHairGroup) end
                if type(oldHair.facialHairType) == "string" then player.setFacialHairType(oldHair.facialHairType) end
            end
            player.setProperty("xHatter::oldHairParams", nil)
        end
        return
    end
    self.headSpriteName = head

    if self.mode == "xSB" or self.mode == "SE/oSB" then
        if not root.assetExists then root.assetExists = root.assetOrigin end
        local headConfigPath = "/animatedhats/" .. head .. ".json"
        if root.assetExists(headConfigPath) then
            self.innerHead = head and self.mode and root.assetJson("/animatedhats/" .. head .. ".json") or nil
            if self.innerHead then self.innerHead.parameters = self.innerHead.parameters or {} end
        else
            self.innerHead = nil
        end
    else
        local headConfigPath = "/animatedhats/" .. head .. ".json"
        if pcall(root.assetJson, headConfigPath) then
            -- Logs a harmless error if the expected animated head config doesn't exist.
            self.innerHead = head and self.mode and root.assetJson("/animatedhats/" .. head .. ".json") or nil
            if self.innerHead then self.innerHead.parameters = self.innerHead.parameters or {} end
        else
            self.innerHead = nil
        end
    end

    if self.innerHead and hairGroups[species] then
        if self.mode == "xSB" or self.mode == "SE/oSB" then
            species = player.imagePath() or species -- FezzedOne: Added image path detection for xSB, oSB and SE.
            if not hairGroups[species] then resolveHairGroups(species, hairGroups, mode) end
            -- FezzedOne: If xSB, oSB or SE is detected, xHatter now saves your character's old hair parameters
            -- and sets them back when clearing the configured head base sprite.
            if not player.getProperty("xHatter::oldHairParams") then
                player.setProperty("xHatter::oldHairParams", {
                    hairType = player.hairType(),
                    facialHairGroup = player.facialHairGroup(),
                    facialHairType = player.facialHairType(),
                })
            end
            player.setHairType(hairGroups[species].hairType)
            player.setFacialHairGroup(hairGroups[species].facialHairGroup)
            player.setFacialHairType(hairGroups[species].facialHairType)
        elseif self.mode == "Neon" then -- FezzedOne: Added Neon support, such as it is.
            neon.player.setHairType(hairGroups[species].hairType)
            neon.player.setFacialHairGroup(hairGroups[species].facialHairGroup)
            neon.player.setFacialHairType(hairGroups[species].facialHairType)
        end
    end
end

function update(dt)
    -- Retrieve current parameters --
    local currentEmoteFrame = getEmote()
    local currentEmote = currentEmoteFrame:match("[^%d%W]+")
    local currentDirection = mcontroller.facingDirection()
    local currentDirectionName = currentDirection > 0 and "default" or "reverse"

    self.slotName, self.currentHat, self.primaryHatMode = getHeadItem()
    self.chestSlotName, self.currentChestItem = getChestItem()
    self.legsSlotName, self.currentLegsItem = getLegsItem()
    self.backSlotName, self.currentBackItem = getBackItem()
    self.underlaySlotName, self.currentHatUnderlay = getHeadUnderlayItem()
    self.underlayChestSlotName, self.currentChestItemUnderlay = getChestUnderlayItem()
    self.underlayLegsSlotName, self.currentLegsItemUnderlay = getLegsUnderlayItem()
    self.underlayBackSlotName, self.currentBackItemUnderlay = getBackUnderlayItem()

    local canUnderlay = self.mode == "xSB"

    if
        self.mode == "xSB"
        and self.innerHead
        and (currentDirection ~= self.previousDirection or currentEmoteFrame ~= self.previousEmote)
    then -- On xStarbound, any specified animated head config file serves as the head underlay.
        if type(self.innerHead.parameters.advancedHatter) == "table" then
            local directives = getFrame(currentDirection, currentEmoteFrame, false, true)
            player.setFacialHairDirectives(directives)
        elseif type(self.innerHead.parameters.xHatter) == "table" then
            if currentDirection ~= self.previousDirection then
                local dirString = self.innerHead.parameters.xHatter[currentDirection == -1 and "left" or "right"]
                self.innerHead.parameters.directives = type(dirString) == "string" and dirString
                    or self.innerHead.parameters.directives
                player.setFacialHairDirectives(dirString)
            end
        end
    end

    local safeEmoteCheck1 = function(params, currentEmote)
        if type(params[self.emotes[currentEmote]]) == "table" then
            return true
        else
            return false
        end
    end

    local safeEmoteCheck2 = function(params, currentDir, currentEmote)
        if type(params[currentDir]) == "table" then
            if type(params[currentDir][self.emotes[currentEmote]]) == "table" then
                return true
            else
                return false
            end
        else
            return false
        end
    end

    if self.currentHat and type(self.currentHat.parameters.advancedHatter) == "table" then
        if getVersion(false) == 2 then
            if not safeEmoteCheck2(self.currentHat.parameters.advancedHatter, currentDirection, currentEmote) then
                currentEmote = "idle"
                currentEmoteFrame = "idle"
            end
        else -- support previous version
            if not safeEmoteCheck1(self.currentHat.parameters.advancedHatter, currentEmote) then
                currentEmote = "idle"
                currentEmoteFrame = "idle"
            end
        end

        if currentDirection ~= self.previousDirection or currentEmoteFrame ~= self.previousEmote then
            local directives = getFrame(currentDirection, currentEmoteFrame, false, false)

            if directives then
                if self.primaryHatMode == "SE/oSB" then
                    player.setFacialHairDirectives(directives)
                elseif self.mode == "Neon" then -- FezzedOne: Added Neon support, such as it is.
                    neon.player.setFacialHairDirectives(directives)
                else -- FezzedOne: Detected xStarbound or stock Starbound.
                    self.currentHat.parameters.directives = directives
                    if self.slotName then player.setEquippedItem(self.slotName, self.currentHat) end
                end
            end
        end
    elseif self.currentHat and type(self.currentHat.parameters.xHatter) == "table" then
        if currentDirection ~= self.previousDirection then
            local dirString = self.currentHat.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            self.currentHat.parameters.directives = type(dirString) == "string" and dirString
                or self.currentHat.parameters.directives
            player.setEquippedItem(self.slotName, self.currentHat)
        end
    end

    if
        canUnderlay
        and self.currentHatUnderlay
        and self.currentHatUnderlay.parameters.underlaid
        and type(self.currentHatUnderlay.parameters.advancedHatter) == "table"
    then
        if getVersion(false) == 2 then
            if
                not safeEmoteCheck2(self.currentHatUnderlay.parameters.advancedHatter, currentDirection, currentEmote)
            then
                currentEmote = "idle"
                currentEmoteFrame = "idle"
            end
        else -- support previous version
            if not safeEmoteCheck1(self.currentHatUnderlay.parameters.advancedHatter, currentEmote) then
                currentEmote = "idle"
                currentEmoteFrame = "idle"
            end
        end

        if currentDirection ~= self.previousDirection or currentEmoteFrame ~= self.previousEmote then
            self.currentHatUnderlay.parameters.directives = getFrame(currentDirection, currentEmoteFrame, true, false)
            player.setEquippedItem(self.underlaySlotName, self.currentHatUnderlay)
        end
    elseif self.currentHatUnderlay and type(self.currentHatUnderlay.parameters.xHatter) == "table" then
        if currentDirection ~= self.previousDirection then
            local dirString = self.currentHatUnderlay.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            self.currentHatUnderlay.parameters.directives = type(dirString) == "string" and dirString
                or self.currentHatUnderlay.parameters.directives
            player.setEquippedItem(self.underlaySlotName, self.currentHatUnderlay)
        end
    end

    if self.currentChestItem and type(self.currentChestItem.parameters.xHatter) == "table" then
        if currentDirection ~= self.previousDirection then
            local dirString = self.currentChestItem.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            self.currentChestItem.parameters.directives = type(dirString) == "string" and dirString
                or self.currentChestItem.parameters.directives
            player.setEquippedItem(self.chestSlotName, self.currentChestItem)
        end
    end

    if
        canUnderlay
        and self.currentChestItemUnderlay
        and self.currentChestItemUnderlay.parameters.underlaid
        and type(self.currentChestItemUnderlay.parameters.xHatter) == "table"
    then
        if currentDirection ~= self.previousDirection then
            local dirString =
                self.currentChestItemUnderlay.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            self.currentChestItemUnderlay.parameters.directives = type(dirString) == "string" and dirString
                or self.currentChestItemUnderlay.parameters.directives
            player.setEquippedItem(self.underlayChestSlotName, self.currentChestItemUnderlay)
        end
    end

    if self.currentLegsItem and type(self.currentLegsItem.parameters.xHatter) == "table" then
        if currentDirection ~= self.previousDirection then
            local dirString = self.currentLegsItem.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            self.currentLegsItem.parameters.directives = type(dirString) == "string" and dirString
                or self.currentLegsItem.parameters.directives
            player.setEquippedItem(self.legsSlotName, self.currentLegsItem)
        end
    end

    if
        canUnderlay
        and self.currentLegsItemUnderlay
        and self.currentLegsItemUnderlay.parameters.underlaid
        and type(self.currentLegsItemUnderlay.parameters.xHatter) == "table"
    then
        if currentDirection ~= self.previousDirection then
            self.currentLegsItemUnderlay.parameters.directives =
                self.currentLegsItemUnderlay.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            player.setEquippedItem(self.underlayLegsSlotName, self.currentLegsItemUnderlay)
        end
    end

    if self.currentBackItem and type(self.currentBackItem.parameters.xHatter) == "table" then
        if currentDirection ~= self.previousDirection then
            local dirString = self.currentBackItem.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            self.currentBackItem.parameters.directives = type(dirString) == "string" and dirString
                or self.currentBackItem.parameters.directives
            player.setEquippedItem(self.backSlotName, self.currentBackItem)
        end
    end

    if
        canUnderlay
        and self.currentBackItemUnderlay
        and self.currentBackItemUnderlay.parameters.underlaid
        and type(self.currentBackItemUnderlay.parameters.xHatter) == "table"
    then
        if currentDirection ~= self.previousDirection then
            local dirString =
                self.currentBackItemUnderlay.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            self.currentBackItemUnderlay.parameters.directives = type(dirString) == "string" and dirString
                or self.currentBackItemUnderlay.parameters.directives
            player.setEquippedItem(self.underlayBackSlotName, self.currentBackItemUnderlay)
        end
    end

    self.previousEmote = currentEmoteFrame
    self.previousDirection = currentDirection
end
