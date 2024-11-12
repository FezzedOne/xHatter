function init()
    self.previousEmote = "idle"
    self.previousPosition = world.entityPosition(player.id())
    self.previousDirection = "none"

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
end

function update(dt)
    -- Retrieve current parameters --
    local currentEmoteFrame = getEmote()
    local currentEmote = currentEmoteFrame:match("[^%d%W]+")
    local currentDirection = mcontroller.facingDirection()
    local currentDirectionName = currentDirection > 0 and "default" or "reverse"

    self.slotName, self.currentHat = getHeadItem()
    self.chestSlotName, self.currentChestItem = getChestItem()
    self.legsSlotName, self.currentLegsItem = getLegsItem()
    self.backSlotName, self.currentBackItem = getBackItem()
    self.underlaySlotName, self.currentHatUnderlay = getHeadUnderlayItem()
    self.underlayChestSlotName, self.currentChestItemUnderlay = getChestUnderlayItem()
    self.underlayLegsSlotName, self.currentLegsItemUnderlay = getLegsUnderlayItem()
    self.underlayBackSlotName, self.currentBackItemUnderlay = getBackUnderlayItem()

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
            self.currentHat.parameters.directives = getFrame(currentDirection, currentEmoteFrame, false)
            player.setEquippedItem(self.slotName, self.currentHat)

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
            self.currentHatUnderlay.parameters.directives = getFrame(currentDirection, currentEmoteFrame, true)
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

function getVersion(isUnderlay)
    local versionNumber = self[isUnderlay and "currentHatUnderlay" or "currentHat"].parameters.advancedHatter.version
    return versionNumber and versionNumber or 1
end

function getHeadItem()
    local slotName = "headCosmetic"
    local currentItem = player.equippedItem(slotName)

    if not currentItem then
        slotName = "head"
        currentItem = player.equippedItem(slotName)
    end
    return slotName, currentItem
end

function getChestItem()
    local slotName = "chestCosmetic"
    local currentItem = player.equippedItem(slotName)

    if not currentItem then
        slotName = "chest"
        currentItem = player.equippedItem(slotName)
    end
    return slotName, currentItem
end

function getLegsItem()
    local slotName = "legsCosmetic"
    local currentItem = player.equippedItem(slotName)

    if not currentItem then
        slotName = "legs"
        currentItem = player.equippedItem(slotName)
    end
    return slotName, currentItem
end

function getBackItem()
    local slotName = "backCosmetic"
    local currentItem = player.equippedItem(slotName)

    if not currentItem then
        slotName = "back"
        currentItem = player.equippedItem(slotName)
    end
    return slotName, currentItem
end

function getHeadUnderlayItem()
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

function getChestUnderlayItem()
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

function getLegsUnderlayItem()
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

function getBackUnderlayItem()
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

function getEmote()
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

function getFrame(direction, emoteFrame, isUnderlay)
    local directives = ""
    local currentDirectionName = direction > 0 and "default" or "reverse"

    -- Check for aliases
    if self.aliases[emoteFrame] then emoteFrame = self.aliases[emoteFrame] end

    local emote = emoteFrame:match("[^%d%W]+")
    local frame = tonumber(emoteFrame:match("%d+"))

    -- Bugfix
    if not frame then frame = 1 end

    -- Out of border check
    local hatToCheck = isUnderlay and "currentHatUnderlay" or "currentHat"
    if getVersion(isUnderlay) == 2 then
        frame = math.min(frame, #self[hatToCheck].parameters.advancedHatter[currentDirectionName][self.emotes[emote]])

        if
            type(self[hatToCheck].parameters.advancedHatter[currentDirectionName][self.emotes[emote]][frame]) == "table"
        then
            directives = self[hatToCheck].parameters.advancedHatter[currentDirectionName][self.emotes[emote]][frame]
        else
            directives = self[hatToCheck].parameters.advancedHatter[currentDirectionName][self.emotes[emote]][frame]
        end
    else -- previous version
        frame = math.min(frame, #self[hatToCheck].parameters.advancedHatter[self.emotes[emote]])

        if type(self[hatToCheck].parameters.advancedHatter[self.emotes[emote]][frame]) == "table" then
            if direction > 0 then
                directives = self[hatToCheck].parameters.advancedHatter[self.emotes[emote]][frame].default
            else
                directives = self[hatToCheck].parameters.advancedHatter[self.emotes[emote]][frame].reverse
            end
        else
            directives = self[hatToCheck].parameters.advancedHatter[self.emotes[emote]][frame]
        end
    end

    return directives
end
