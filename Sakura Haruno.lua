local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local lang = {}

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        help = "Hello |PLAYERNAME|. My name is Sakura Haruno, and I assist ninjas of the {Haruno} clan. Do you need anything from me?",
        noLvl = "Sorry, but I think you need to get a bit stronger to join us. Talk to me again when you get level 5!",
        askHaruno = "Oh! You want to {become} a member of Haruno clan? Our clan focus in healing and helping others. This is the path you want to follow?",
        confirm = "So you really like helping other then? Okay! I will ask one more time for good measure. You really want to {join} Haruno clan?",
        done = "Great! Now you are, too, a member of our clan! Continue your training and remember to always help those in need. I will also teach you a jutsu named {Shannaro}, because you need to hit your foes too, right? Protect yourself to protect others!",
        isHaruno = "Hello |PLAYERNAME|, what {brings} you here?",
        hasOtherClan = "You already belong to another clan. I cannot assist you.",

        noLvlQuest1 = "Hey |PLAYERNAME|! I don't know how to say this, but I kinda can't teach you right now. Return to me when you are at least level 50 and I can teach you something nice!",
        quest1 = "Oh! You've got stronger, I can see it. Now I can finally teach you {Ninpou Souzou Saisei}, a jutsu that constantly recover you while you're fighting. Ready to learn it?",
        quest1Done = "Great! With that jutsu, you can continue helping others in the battlefield without worrying too much about yourself. Go and never let a fellow companion of our village dies before your eyes!",

        noLvlQuest2 = "Hello |PLAYERNAME|! I know the right jutsu to teach you, but it looks like you're not ready yet. The chakra control to use this is more than you have right now. Please get level 80 and talk to me again.",
        quest2 = "Aha! Now I feel that you chakra control is on point to learn {Shousen Jutsu}. This jutsu creates an area with healing properties that will constantly heal anyone in it. Are you ready to make your chakra control work in a constant way outside your body?",
        quest2Done = "Yes! I'm so proud of you being a part of the Haruno Clan. Now everyone is safer when you're around. But don't worry, I have more techniques to teach you. Let's talk again sometime.",

        noLvlQuest3 = "I know I've told you that I would teach you some new techniques later, but don't you think it's too soon? Those new techniques are meant to be taught to {graduated ninjas} around level 100. Let's talk again when you get there, okay? I believe in you!",
        quest3 = "Yees! You've became a powerful ninja! A lot of people are talking about you and all the help you've been doing in the battlefield. I think it's time to teach you a technique called {Sakuraichi}. It's a jutsu that uses cherry blossoms to damage anything in front of you. If you can defeat the enemy before it hurt your teammates, everyone wins, right?",
        quest3Done = "Fantastic! More and more you proven yourself to me and all the Haruno clan. I don't think there's anyone that can defeat you or your teammates in battle. Now there's a little that I can teach you, but I really hope you continue growing stronger for the sake of our village.",

        noLvlQuest4 = "Hey |PLAYERNAME|! I see that you eager to learn from me again, but I don't think you're ready yet. This technique requires more power than you have right now. If you try this now, your arms might break, so... Yeah! Try getting level 120. I think that would be sufficient!",
        quest4 = "Look at those muscles! Now it's time to teach you {Okasho}. Again, a jutsu that uses Cherry Blossoms, but this time, you'll use pure strength too. Are you ready to initiate my training?",
        quest4Done = "Yeees! That was awesome! With this technique, no one will ever get near you or your teammates! Of course, you'll need to be at the center of the battle to use it well, but I know that will be no problem for you!",
    },

    ["pt"] = {
        help = "",
        noLvl = "",
        askUchiha = "",
        confirm = "",
        done = "",        
        isUchiha = "",
        hasOtherClan = "",

        noLvlQuest1 = "",
        quest1 = "",
        quest1Done = "",

        noLvlQuest2 = "",
        quest2 = "",
        quest2Done = "",

        noLvlQuest3 = "",
        quest3 = "",
        quest3Done = "",

        noLvlQuest4 = "",
        quest4 = "",
        quest4Done = "",
    }
}

local validWords = {
    ["pt"] = {"ajudar", "haruno", "tornar", "fazer parte", "traz"},
    ["en"] = {"help", "haruno", "become", "join", "brings"}
}

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local harunoVocationId = 11
    local playerVocation = player:getVocation():getId()
    local currentLang = npcHandler.languages[cid] or "pt" -- idioma padrão pt

    npcHandler:addFocus(cid)

    -- Bloquear mensagens fora do idioma definido
    local isValid = false
    for _, word in ipairs(validWords[currentLang]) do
        if msgcontains(msgLower, word) then
            isValid = true
            break
        end
    end
    if not isValid then
        return true
    end

    -- Comandos de ajuda
    if msgcontains(msgLower, "ajudar") or msgcontains(msgLower, "help") then
        npcHandler:say(messages[currentLang].help, cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Fluxo Haruno
    if msgcontains(msgLower, "haruno") then
        if playerVocation ~= 0 and playerVocation ~= uchihaVocationId then
            npcHandler:say(messages[currentLang].hasOtherClan, cid)
            npcHandler:releaseFocus(cid)
            return true
        elseif playerVocation == uchihaVocationId then
            npcHandler:say(string.gsub(messages[currentLang].isUchiha, "|PLAYERNAME|", player:getName()), cid)
            npcHandler.topic[cid] = 0
            return true
        else
            npcHandler:say(messages[currentLang].askUchiha, cid)
            npcHandler.topic[cid] = 1
            return true
        end
    end

    -- Fluxo de confirmação
if npcHandler.topic[cid] == 1 and (msgcontains(msgLower, "tornar") or msgcontains(msgLower, "become")) then
    -- Verifica level mínimo
    if player:getLevel() < 5 then
        npcHandler:say(messages[currentLang].noLvl, cid)
        npcHandler.topic[cid] = 0
        return true
    end

    npcHandler:say(messages[currentLang].confirm, cid)
    npcHandler.topic[cid] = 2
    return true
elseif npcHandler.topic[cid] == 2 and (msgcontains(msgLower, "fazer parte") or msgcontains(msgLower, "join")) then
    player:setVocation(Vocation(uchihaVocationId))
    player:save()
    player:setOutfit({lookType = 400})
    player:addOutfit(400)
    player:addSpell("Shannaro")
    npcHandler:say(messages[currentLang].done, cid)
    npcHandler:releaseFocus(cid)
    npcHandler.topic[cid] = 0
    return true
end

-- Fluxo de Quest 1
if msgcontains(msgLower, "brings") or msgcontains(msgLower, "traz") then
    if player:getLevel() < 50 then
        npcHandler:say(messages[currentLang].noLvlQuest1, cid)
        return true
    else
        npcHandler:say(messages[currentLang].quest1, cid)
        return true
    end
end
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
