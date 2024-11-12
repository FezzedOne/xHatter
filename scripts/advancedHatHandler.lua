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

    if not currentItem then
        slotName = "head"
        currentItem = player.equippedItem(slotName)
    end

    if not currentItem then
        if self.innerHead then return nil, self.innerHead, self.mode end
    else
        return slotName, currentItem, "headItem"
    end
end

local function getChestItem()
    local slotName = "chestCosmetic"
    local currentItem = player.equippedItem(slotName)

    if not currentItem then
        slotName = "chest"
        currentItem = player.equippedItem(slotName)
    end
    return slotName, currentItem
end

local function getLegsItem()
    local slotName = "legsCosmetic"
    local currentItem = player.equippedItem(slotName)

    if not currentItem then
        slotName = "legs"
        currentItem = player.equippedItem(slotName)
    end
    return slotName, currentItem
end

local function getBackItem()
    local slotName = "backCosmetic"
    local currentItem = player.equippedItem(slotName)

    if not currentItem then
        slotName = "back"
        currentItem = player.equippedItem(slotName)
    end
    return slotName, currentItem
end

local function getHeadUnderlayItem()
    local slotName = "headCosmetic"
    local currentItem = player.equippedItem(slotName)

    if currentItem then
        slotName = "head"
        currentItem = player.equippedItem(slotName)
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
    if not type(params.advancedHatter) == "table" then return baseDirectives end

    -- FezzedOne: Added complete type checks to ensure this function never throws an error on arbitrary item data.
    -- As a bonus, the `"directives"` parameter on head items is used if any (or all) animation directive strings are missing.
    if getVersion(isUnderlay, useAnimatedHead) == 2 then
        local dirSpec = params.advancedHatter[currentDirectionName]
        if not type(dirSpec) == "table" then return baseDirectives end

        local emoteSpec = dirSpec[self.emotes[emote]]
        frame = math.min(frame, #emoteSpec)

        directives = type(emoteSpec[frame]) == "string" and emoteSpec[frame] or baseDirectives
    else -- previous version
        local emoteSpec = params.advancedHatter[self.emotes[emote]]
        if not type(emoteSpec) == "table" then return baseDirectives end

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

    local head = player.getProperty("animatedHead") -- Note: Name of the hat to use as the animated head sprite.
    self.headSpriteName = head
    self.mode = _ENV["xsb"] and "xSB"
        or _ENV["player"]["setFacialHairType"] and "SE/oSB"
        or _ENV["_star_player"] and "hasiboundlite"
        or nil
    self.innerHead = head and self.mode and root.assetJson("/animatedhats/" .. head .. ".json") or nil

    if self.innerHead and hairGroups[species] then
        if self.mode == "hasiboundlite" then
            _star_player():set_hair_type(hairGroups[species].hairType)
            _star_player():set_facialHair_group(hairGroups[species].facialHairGroup)
            _star_player():set_facialHair_type(hairGroups[species].facialHairType)
        elseif self.mode == "xSB" or self.mode == "SE/oSB" then
            species = player.imagePath() or species -- FezzedOne: Added image path detection for xSB, oSB and SE.
            if not hairGroups[species] then resolveHairGroups(species, hairGroups, mode) end
            player.setHairType(hairGroups[species].hairType)
            player.setFacialHairGroup(hairGroups[species].facialHairGroup)
            player.setFacialHairType(hairGroups[species].facialHairType)
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

    if self.mode == "xSB" and self.innerHead then -- On xStarbound, any specified animated head config file serves as the head underlay.
        local directives = getFrame(currentDirection, currentEmoteFrame, false, true)
        player.setFacialHairDirectives(directives)

        self.previousEmote = currentEmoteFrame
        self.previousDirection = currentDirection
    end

    if self.currentHat and self.currentHat.parameters.advancedHatter then
        if getVersion(false) == 2 then
            if not self.currentHat.parameters.advancedHatter[currentDirectionName][self.emotes[currentEmote]] then
                currentEmote = "idle"
                currentEmoteFrame = "idle"
            end
        else -- support previous version
            if not self.currentHat.parameters.advancedHatter[self.emotes[currentEmote]] then
                currentEmote = "idle"
                currentEmoteFrame = "idle"
            end
        end

        if currentDirection ~= self.previousDirection or currentEmoteFrame ~= self.previousEmote then
            local directives = getFrame(currentDirection, currentEmoteFrame, false, false)

            if directives then
                if self.primaryHatMode == "hasiboundlite" then
                    _star_player():set_facialHair_directives(directives)
                elseif self.primaryHatMode == "SE/oSB" then
                    player.setFacialHairDirectives(directives)
                else -- FezzedOne: Detected xStarbound or stock Starbound.
                    self.currentHat.parameters.directives = directives
                    if self.slotName then player.setEquippedItem(self.slotName, self.currentHat) end
                end
            end

            self.previousEmote = currentEmoteFrame
            self.previousDirection = currentDirection
        end
    elseif self.currentHat and self.currentHat.parameters.xHatter then
        if currentDirection ~= self.previousDirection then
            self.currentHat.parameters.directives =
                self.currentHat.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            player.setEquippedItem(self.slotName, self.currentHat)

            self.previousEmote = currentEmoteFrame
            self.previousDirection = currentDirection
        end
    end

    if self.currentHatUnderlay and self.currentHatUnderlay.parameters.advancedHatter then
        if getVersion(true) == 2 then
            if
                not self.currentHatUnderlay.parameters.advancedHatter[currentDirectionName][self.emotes[currentEmote]]
            then
                currentEmote = "idle"
                currentEmoteFrame = "idle"
            end
        else -- support previous version
            if not self.currentHatUnderlay.parameters.advancedHatter[self.emotes[currentEmote]] then
                currentEmote = "idle"
                currentEmoteFrame = "idle"
            end
        end

        if currentDirection ~= self.previousDirection or currentEmoteFrame ~= self.previousEmote then
            self.currentHatUnderlay.parameters.directives = getFrame(currentDirection, currentEmoteFrame, true, false)
            player.setEquippedItem(self.underlaySlotName, self.currentHatUnderlay)

            self.previousEmote = currentEmoteFrame
            self.previousDirection = currentDirection
        end
    elseif self.currentHatUnderlay and self.currentHatUnderlay.parameters.xHatter then
        if currentDirection ~= self.previousDirection then
            self.currentHatUnderlay.parameters.directives =
                self.currentHatUnderlay.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            player.setEquippedItem(self.underlaySlotName, self.currentHatUnderlay)

            self.previousEmote = currentEmoteFrame
            self.previousDirection = currentDirection
        end
    end

    if self.currentChestItem and self.currentChestItem.parameters.xHatter then
        if currentDirection ~= self.previousDirection then
            self.currentChestItem.parameters.directives =
                self.currentChestItem.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            player.setEquippedItem(self.chestSlotName, self.currentChestItem)

            self.previousEmote = currentEmoteFrame
            self.previousDirection = currentDirection
        end
    end

    if self.currentChestItemUnderlay and self.currentChestItemUnderlay.parameters.xHatter then
        if currentDirection ~= self.previousDirection then
            self.currentChestItemUnderlay.parameters.directives =
                self.currentChestItemUnderlay.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            player.setEquippedItem(self.underlayChestSlotName, self.currentChestItemUnderlay)

            self.previousEmote = currentEmoteFrame
            self.previousDirection = currentDirection
        end
    end

    if self.currentLegsItem and self.currentLegsItem.parameters.xHatter then
        if currentDirection ~= self.previousDirection then
            self.currentLegsItem.parameters.directives =
                self.currentLegsItem.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            player.setEquippedItem(self.legsSlotName, self.currentLegsItem)

            self.previousEmote = currentEmoteFrame
            self.previousDirection = currentDirection
        end
    end

    if self.currentLegsItemUnderlay and self.currentLegsItemUnderlay.parameters.xHatter then
        if currentDirection ~= self.previousDirection then
            self.currentLegsItemUnderlay.parameters.directives =
                self.currentLegsItemUnderlay.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            player.setEquippedItem(self.underlayLegsSlotName, self.currentLegsItemUnderlay)

            self.previousEmote = currentEmoteFrame
            self.previousDirection = currentDirection
        end
    end

    if self.currentBackItem and self.currentBackItem.parameters.xHatter then
        if currentDirection ~= self.previousDirection then
            self.currentBackItem.parameters.directives =
                self.currentBackItem.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            player.setEquippedItem(self.backSlotName, self.currentBackItem)

            self.previousEmote = currentEmoteFrame
            self.previousDirection = currentDirection
        end
    end

    if self.currentBackItemUnderlay and self.currentBackItemUnderlay.parameters.xHatter then
        if currentDirection ~= self.previousDirection then
            self.currentBackItemUnderlay.parameters.directives =
                self.currentBackItemUnderlay.parameters.xHatter[currentDirection == -1 and "left" or "right"]
            player.setEquippedItem(self.underlayBackSlotName, self.currentBackItemUnderlay)

            self.previousEmote = currentEmoteFrame
            self.previousDirection = currentDirection
        end
    end
end
