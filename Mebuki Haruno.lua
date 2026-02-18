local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local lang = {}

-- Unique storage to track Haruno clan progression
-- Storage = 0: Learned Shannaro (upon becoming Haruno)
-- Storage = 1: Received quest with Shizune (Mission 1)
-- Storage = 2: Completed Shizune's mission
-- Storage = 3: Learned Shousen Jutsu
-- Storage = 4: Received quest with Tsunade/Medinin (Mission 2)
-- Storage = 5: Completed Tsunade/Medinin mission
-- Storage = 6: Learned Ninpou Souzou Saisei
-- Storage = 7: Received quest with Doton Jounnin (Mission 3)
-- Storage = 8: Completed Doton Jounnin mission
-- Storage = 9: Learned Sakuraichi
-- Storage = 10: Received final quest from Tsunade (Mission 4)
-- Storage = 11: Completed final frontline mission
-- Storage = 12: Learned Okasho

-- Rank ranges: E=0-49, D=50-99, C=100-249, B=250-499, A=500-699, S=700+
-- Graduation values: Academy Student=0, Gennin=1, Chunnin=2, Jounnin=3 (NOT YET IMPLEMENTED)

local HARUNO_JUTSU_STORAGE = 70003
local RANK_STORAGE = 5153
local GRADUATION_STORAGE = 5400

-- Function to get rank level from rank points
local function getRankLevel(rankPoints)
    if rankPoints >= 700 then return 5 end  -- Rank S
    if rankPoints >= 500 then return 4 end  -- Rank A
    if rankPoints >= 250 then return 3 end  -- Rank B
    if rankPoints >= 100 then return 2 end  -- Rank C
    if rankPoints >= 50 then return 1 end   -- Rank D
    return 0  -- Rank E
end

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        help = "Hello, |PLAYERNAME|. I am Mebuki Haruno. I guide those of the {Haruno} clan. Tell me, what do you need?",
        noLvl = "You're still too inexperienced to join us. Return when you are at least {level 5}.",
        askHaruno = "You wish to {become} Haruno? This path demands discipline, control, and compassion. Are you certain?",
        confirm = "If you choose this path, you must carry it to the end. Do you truly want to {join} the Haruno clan?",
        done = "Very well. From this moment on, you carry the Haruno name. I will teach you {Shannaro}. Use your strength to protect those who cannot protect themselves.",
        isHaruno = "Welcome back, |PLAYERNAME|. What {brings} you here?",
        hasOtherClan = "You already belong to another clan. I cannot interfere.",

        noLvlQuest1 = "Your foundation is not ready, |PLAYERNAME|. Reach at least {level 40} and achieve at least {Rank C}, then return to me.",
        quest1 = "I see that your chakra control has improved. It's time for your first true medical trial. Go to {Shizune}. She will test your composure under pressure and, maybe if everything goes as planned, she can make you {learn Shousen Jutsu}?",
        quest1Requirements = "Shizune is at the village hospital. Help her stabilize the wounded and make the right call when needed. Return only when your task is complete.",
        quest1Incomplete = "You haven't helped Shizune's patients yet. Return to the hospital and finish what you started.",
        quest1Done = "Even after all those pressures and losses, you saved our fellow comrades. You did well, |PLAYERNAME|. Now I'll teach you the real {Shousen Jutsu}. Use it to protect everyone around you.",

        noLvlQuest2 = "Do not rush. Reach at least {level 80} and achieve at least {Rank B} before I can request help from you.",
        quest2 = "I need you to speak with {Tsunade}. She asked for a strong ninja that could assist her in a critical mission. Talk to her and see what you need to do. While you're there, see if you can {learn Ninpou Souzou Saisei} from her.",
        quest2Requirements = "Find Tsunade and follow her orders. She will give you more instructions.",
        quest2Incomplete = "I didn't receive word from Tsunade that you finished her request. Have you talked to her yet? Remember, this is a critical mission. Don't keep her waiting.",
        quest2Done = "You endured the chaos and held your position. Excellent. I see that she taught you {Ninpou Souzou Saisei}, but your control is not quite right. Try to use it in this way... Great, now you can use it properly.",

        noLvlQuest3 = "I need your help |PLAYERNAME|, but you are not ready yet. This operation requires a graduated ninja, at least {level 120}, and at least {Rank A}. Return once you are truly prepared.",
        quest3 = "Civilians are trapped near a hostile cave route. Seek the {Doton Jounnin}. He controls the barrier and will place you inside the operation zone. He has abnormal strength and has an incredibly powerful technique. When you're there, {learn Sakuraichi} from him. You'll need it.",
        quest3Requirements = "Protect the civilians during the waves and strike decisively. Hesitation will cost lives. Don't let anyone die on your watch.",
        quest3Incomplete = "The cave defense mission remains incomplete. Civilians are dying, |PLAYERNAME|. Return to the Doton Jounnin and finish the operation as quickly as possible.",
        quest3Done = "You acted without hesitation and protected the civilians. Very good, |PLAYERNAME|. My spy team said that your use of Sakuraichi was a little wrong. See, you need to focus your strength in this part of your arm. In this way, you can extract all your power and use {Sakuraichi} effectively.",

        noLvlQuest4 = "Our friends in the battlefield are hurt and we need someone to protect them. At this moment, you are not this person. Return to me when you're {level 150} and {Rank S}.",
        quest4 = "Now we can finally put you to a real test. In the northern mountain, our forces are badly hurt, and I need you to go help them. I sure hope that while at it, you {learn Okasho}. It's basically the next level of Sakuraichi, so the core use is the same.",
        quest4Requirements = "|PLAYERNAME|, I need you to hold the line and endure the siege while our medical unit heals the wounded. I trust you can do that, right? You can surprise the enemies jumping off a cliff in the northernmost mountain.",
        quest4Incomplete = "Our forces are dying, |PLAYERNAME|. Go to the battlefield and protect our forces.",
        quest4Done = "You've done well, |PLAYERNAME|. You have protected your teammates, and in the last second, you unleashed a powerful Okasho. It was quite crude, but it was effective. Let me teach you how to use it properly.",

        alreadyLearnedShousen = "You have already learned Shousen Jutsu from me.",
        alreadyLearnedNinpou = "You have already learned Ninpou Souzou Saisei from me.",
        alreadyLearnedSakuraichi = "You have already learned Sakuraichi from me.",
        alreadyLearnedOkasho = "You have already learned Okasho from me.",
        allTechniques = "At the moment, I don't have any new requests for you. I'll let you know if something comes up.",
    },

    ["pt"] = {
        help = "Olá, |PLAYERNAME|. Eu sou Mebuki Haruno. Guio os ninjas do clã {Haruno}. Me diga, do que você precisa?",
        noLvl = "Você ainda está sem experiência para entrar no clã. Volte quando estiver pelo menos no {level 5}.",
        askHaruno = "Você quer se {tornar} Haruno? Este caminho exige disciplina, controle e compaixão. Tem certeza?",
        confirm = "Se escolher este caminho, terá que segui-lo até o fim. Você realmente quer {fazer parte} do clã Haruno?",
        done = "Muito bem. A partir de agora você carrega o nome Haruno. Vou lhe conceder {Shannaro}. Use sua força para proteger quem não pode se proteger.",
        isHaruno = "Bem-vindo de volta, |PLAYERNAME|. O que te {traz} aqui?",
        hasOtherClan = "Você já pertence a outro clã. Não posso interferir.",

        noLvlQuest1 = "Sua base ainda não está pronta. Alcance pelo menos o {level 40} e atinja no mínimo o {Rank C}, depois retorne.",
        quest1 = "Seu controle de chakra melhorou. Chegou a hora do seu primeiro teste médico real. Procure a {Shizune}. Ela vai testar sua postura sob pressão. Você está pronto para {aprender Shousen Jutsu}?",
        quest1Requirements = "A Shizune está no hospital da vila. Estabilize os feridos e tome a decisão certa sob pressão. Só retorne quando concluir.",
        quest1Incomplete = "Você ainda não concluiu o teste da Shizune. Volte ao hospital e termine o que começou.",
        quest1Done = "Você enfrentou sua primeira grande perda e ainda permaneceu firme. Ótimo. Agora vou lhe ensinar {Shousen Jutsu}.",

        noLvlQuest2 = "Não se apresse. Alcance pelo menos o {level 80} e atinja no mínimo o {Rank B} antes de enfrentar esse treinamento.",
        quest2 = "Agora você vai aprender resistência sob pressão extrema. Procure a {Tsunade}. Por meio dela e da equipe de campo, você vai entender como permanecer de pé quando o corpo quer cair. Você está pronto para {aprender Ninpou Souzou Saisei}?",
        quest2Requirements = "Encontre a Tsunade e siga suas ordens. Ela vai te direcionar para a simulação correta.",
        quest2Incomplete = "Seu teste de resistência ainda não terminou. Fale com a Tsunade e conclua sua missão.",
        quest2Done = "Você suportou o caos e manteve sua posição. Excelente. Agora vou lhe ensinar {Ninpou Souzou Saisei}.",

        noLvlQuest3 = "Esta operação exige um ninja graduado, pelo menos {level 120} e no mínimo {Rank A}. Volte quando estiver realmente preparado.",
        quest3 = "Há civis presos perto de uma rota de caverna hostil. Procure o {Doton Jounnin}. Ele controla a barreira e vai colocá-lo na zona da operação. Você está pronto para {aprender Sakuraichi}?",
        quest3Requirements = "Proteja os civis durante as waves e ataque com decisão. Hesitar custa vidas.",
        quest3Incomplete = "A missão de defesa da caverna ainda não foi concluída. Volte ao Doton Jounnin e finalize a operação.",
        quest3Done = "Você agiu sem hesitar e protegeu os civis. Muito bem. Vou lhe ensinar {Sakuraichi}.",

        noLvlQuest4 = "A última linha de defesa não é para despreparados. Alcance pelo menos {level 150} e atinja {Rank S}, depois retorne.",
        quest4 = "Você está perto de dominar nosso caminho. Fale com a {Tsunade} mais uma vez e sobreviva ao teste final de linha de frente. Está pronto para {aprender Okasho}?",
        quest4Requirements = "Segure a linha, resista ao cerco e libere sua força apenas no momento decisivo.",
        quest4Incomplete = "O teste final não foi concluído. Volte à Tsunade e prove que consegue ser a última muralha.",
        quest4Done = "Você permaneceu quando os outros caíram. Esse é o verdadeiro significado da força. Agora vou lhe ensinar {Okasho}.",

        alreadyLearnedShousen = "Você já aprendeu Shousen Jutsu comigo.",
        alreadyLearnedNinpou = "Você já aprendeu Ninpou Souzou Saisei comigo.",
        alreadyLearnedSakuraichi = "Você já aprendeu Sakuraichi comigo.",
        alreadyLearnedOkasho = "Você já aprendeu Okasho comigo.",
        allTechniques = "No momento, não tenho novas técnicas para você.",
    }
}

local validWords = {
    ["pt"] = {"ajudar", "haruno", "tornar", "fazer parte", "sim", "traz", "aprender shousen jutsu", "aprender ninpou souzou saisei", "aprender sakuraichi", "aprender okasho"},
    ["en"] = {"help", "haruno", "become", "join", "yes", "brings", "learn shousen jutsu", "learn ninpou souzou saisei", "learn sakuraichi", "learn okasho"}
}

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local harunoVocationId = 11
    local playerVocation = player:getVocation():getId()
    local currentLang = npcHandler.languages[cid] or "pt"

    npcHandler:addFocus(cid)

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

    if msgcontains(msgLower, "ajudar") or msgcontains(msgLower, "help") then
        npcHandler:say(messages[currentLang].help, cid)
        npcHandler.topic[cid] = 0
        return true
    end

    if msgcontains(msgLower, "haruno") then
        if playerVocation ~= 0 and playerVocation ~= harunoVocationId then
            npcHandler:say(messages[currentLang].hasOtherClan, cid)
            npcHandler:releaseFocus(cid)
            return true
        elseif playerVocation == harunoVocationId then
            npcHandler:say(string.gsub(messages[currentLang].isHaruno, "|PLAYERNAME|", player:getName()), cid)
            npcHandler.topic[cid] = 0
            return true
        else
            npcHandler:say(messages[currentLang].askHaruno, cid)
            npcHandler.topic[cid] = 1
            return true
        end
    end

    if npcHandler.topic[cid] == 1 and (msgcontains(msgLower, "tornar") or msgcontains(msgLower, "become") or msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) then
        if player:getLevel() < 5 then
            npcHandler:say(messages[currentLang].noLvl, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        npcHandler:say(messages[currentLang].confirm, cid)
        npcHandler.topic[cid] = 2
        return true
    elseif npcHandler.topic[cid] == 2 and (msgcontains(msgLower, "fazer parte") or msgcontains(msgLower, "join") or msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) then
        player:setVocation(Vocation(harunoVocationId))
        player:save()
        player:setOutfit({lookType = 400})
        player:addOutfit(400)
        player:learnSpell("Shannaro")
        player:setStorageValue(HARUNO_JUTSU_STORAGE, 0)
        player:getPosition():sendMagicEffect(478)
        npcHandler:say(messages[currentLang].done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    if msgcontains(msgLower, "brings") or msgcontains(msgLower, "traz") then
        if playerVocation ~= harunoVocationId then
            npcHandler:say(messages[currentLang].help, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        local harunoJutsu = player:getStorageValue(HARUNO_JUTSU_STORAGE)
        if harunoJutsu == -1 then
            harunoJutsu = 0
        end

        if harunoJutsu == 0 then
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerRank == -1 then playerRank = 0 end

            if player:getLevel() < 40 or getRankLevel(playerRank) < 2 then
                npcHandler:say(messages[currentLang].noLvlQuest1, cid)
            else
                npcHandler:say(messages[currentLang].quest1, cid)
                npcHandler.topic[cid] = 10
            end
        elseif harunoJutsu == 1 then
            npcHandler:say(messages[currentLang].quest1Incomplete, cid)
        elseif harunoJutsu == 2 then
            npcHandler:say(messages[currentLang].quest1Done, cid)
            player:learnSpell("Shousen Jutsu")
            player:getPosition():sendMagicEffect(478)
            player:setStorageValue(HARUNO_JUTSU_STORAGE, 3)
            player:save()
            npcHandler:releaseFocus(cid)

        elseif harunoJutsu == 3 then
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerRank == -1 then playerRank = 0 end

            if player:getLevel() < 80 or getRankLevel(playerRank) < 3 then
                npcHandler:say(messages[currentLang].noLvlQuest2, cid)
            else
                npcHandler:say(messages[currentLang].quest2, cid)
                npcHandler.topic[cid] = 20
            end
        elseif harunoJutsu == 4 then
            npcHandler:say(messages[currentLang].quest2Incomplete, cid)
        elseif harunoJutsu == 5 then
            npcHandler:say(messages[currentLang].quest2Done, cid)
            player:learnSpell("Ninpou Souzou Saisei")
            player:getPosition():sendMagicEffect(478)
            player:setStorageValue(HARUNO_JUTSU_STORAGE, 6)
            player:save()
            npcHandler:releaseFocus(cid)

        elseif harunoJutsu == 6 then
            local playerGraduation = player:getStorageValue(GRADUATION_STORAGE)
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerGraduation == -1 then playerGraduation = 0 end
            if playerRank == -1 then playerRank = 0 end

            -- TODO: Uncomment graduation check when GRADUATION_STORAGE is fully implemented
            -- if player:getLevel() < 120 or playerGraduation < 1 or getRankLevel(playerRank) < 4 then
            if player:getLevel() < 120 or getRankLevel(playerRank) < 4 then
                npcHandler:say(messages[currentLang].noLvlQuest3, cid)
            else
                npcHandler:say(messages[currentLang].quest3, cid)
                npcHandler.topic[cid] = 30
            end
        elseif harunoJutsu == 7 then
            npcHandler:say(messages[currentLang].quest3Incomplete, cid)
        elseif harunoJutsu == 8 then
            npcHandler:say(messages[currentLang].quest3Done, cid)
            player:learnSpell("Sakuraichi")
            player:getPosition():sendMagicEffect(478)
            player:setStorageValue(HARUNO_JUTSU_STORAGE, 9)
            player:save()
            npcHandler:releaseFocus(cid)

        elseif harunoJutsu == 9 then
            local playerGraduation = player:getStorageValue(GRADUATION_STORAGE)
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerGraduation == -1 then playerGraduation = 0 end
            if playerRank == -1 then playerRank = 0 end

            -- TODO: Uncomment graduation check when GRADUATION_STORAGE is fully implemented
            -- if player:getLevel() < 150 or playerGraduation < 2 or getRankLevel(playerRank) < 5 then
            if player:getLevel() < 150 or getRankLevel(playerRank) < 5 then
                npcHandler:say(messages[currentLang].noLvlQuest4, cid)
            else
                npcHandler:say(messages[currentLang].quest4, cid)
                npcHandler.topic[cid] = 40
            end
        elseif harunoJutsu == 10 then
            npcHandler:say(messages[currentLang].quest4Incomplete, cid)
        elseif harunoJutsu == 11 then
            npcHandler:say(messages[currentLang].quest4Done, cid)
            player:learnSpell("Okasho")
            player:getPosition():sendMagicEffect(478)
            player:setStorageValue(HARUNO_JUTSU_STORAGE, 12)
            player:save()
            npcHandler:releaseFocus(cid)
        else
            npcHandler:say(messages[currentLang].allTechniques, cid)
        end
        return true
    end

    if msgcontains(msgLower, "learn shousen jutsu") or msgcontains(msgLower, "aprender shousen jutsu") or ((msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 10) then
        local harunoJutsu = player:getStorageValue(HARUNO_JUTSU_STORAGE)
        if harunoJutsu == -1 then
            harunoJutsu = 0
        end

        if harunoJutsu >= 3 then
            npcHandler:say(messages[currentLang].alreadyLearnedShousen, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        if npcHandler.topic[cid] == 10 and harunoJutsu == 0 then
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerRank == -1 then playerRank = 0 end

            if player:getLevel() < 40 or getRankLevel(playerRank) < 2 then
                npcHandler:say(messages[currentLang].noLvlQuest1, cid)
                npcHandler.topic[cid] = 0
                return true
            end

            player:setStorageValue(HARUNO_JUTSU_STORAGE, 1)
            player:save()
            npcHandler:say(messages[currentLang].quest1Requirements, cid)
            npcHandler:releaseFocus(cid)
            npcHandler.topic[cid] = 0
            return true
        end

        npcHandler.topic[cid] = 0
        return true
    end

    if msgcontains(msgLower, "learn ninpou souzou saisei") or msgcontains(msgLower, "aprender ninpou souzou saisei") or ((msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 20) then
        local harunoJutsu = player:getStorageValue(HARUNO_JUTSU_STORAGE)
        if harunoJutsu == -1 then
            harunoJutsu = 0
        end

        if harunoJutsu >= 6 then
            npcHandler:say(messages[currentLang].alreadyLearnedNinpou, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        if npcHandler.topic[cid] == 20 and harunoJutsu == 3 then
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerRank == -1 then playerRank = 0 end

            if player:getLevel() < 80 or getRankLevel(playerRank) < 3 then
                npcHandler:say(messages[currentLang].noLvlQuest2, cid)
                npcHandler.topic[cid] = 0
                return true
            end

            player:setStorageValue(HARUNO_JUTSU_STORAGE, 4)
            player:save()
            npcHandler:say(messages[currentLang].quest2Requirements, cid)
            npcHandler:releaseFocus(cid)
            npcHandler.topic[cid] = 0
            return true
        end

        npcHandler.topic[cid] = 0
        return true
    end

    if msgcontains(msgLower, "learn sakuraichi") or msgcontains(msgLower, "aprender sakuraichi") or ((msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 30) then
        local harunoJutsu = player:getStorageValue(HARUNO_JUTSU_STORAGE)
        if harunoJutsu == -1 then
            harunoJutsu = 0
        end

        if harunoJutsu >= 9 then
            npcHandler:say(messages[currentLang].alreadyLearnedSakuraichi, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        if npcHandler.topic[cid] == 30 and harunoJutsu == 6 then
            local playerGraduation = player:getStorageValue(GRADUATION_STORAGE)
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerGraduation == -1 then playerGraduation = 0 end
            if playerRank == -1 then playerRank = 0 end

            -- TODO: Uncomment graduation check when GRADUATION_STORAGE is fully implemented
            -- if player:getLevel() < 120 or playerGraduation < 1 or getRankLevel(playerRank) < 4 then
            if player:getLevel() < 120 or getRankLevel(playerRank) < 4 then
                npcHandler:say(messages[currentLang].noLvlQuest3, cid)
                npcHandler.topic[cid] = 0
                return true
            end

            player:setStorageValue(HARUNO_JUTSU_STORAGE, 7)
            player:save()
            npcHandler:say(messages[currentLang].quest3Requirements, cid)
            npcHandler:releaseFocus(cid)
            npcHandler.topic[cid] = 0
            return true
        end

        npcHandler.topic[cid] = 0
        return true
    end

    if msgcontains(msgLower, "learn okasho") or msgcontains(msgLower, "aprender okasho") or ((msgcontains(msgLower, "sim") or msgcontains(msgLower, "yes")) and npcHandler.topic[cid] == 40) then
        local harunoJutsu = player:getStorageValue(HARUNO_JUTSU_STORAGE)
        if harunoJutsu == -1 then
            harunoJutsu = 0
        end

        if harunoJutsu >= 12 then
            npcHandler:say(messages[currentLang].alreadyLearnedOkasho, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        if npcHandler.topic[cid] == 40 and harunoJutsu == 9 then
            local playerGraduation = player:getStorageValue(GRADUATION_STORAGE)
            local playerRank = player:getStorageValue(RANK_STORAGE)
            if playerGraduation == -1 then playerGraduation = 0 end
            if playerRank == -1 then playerRank = 0 end

            -- TODO: Uncomment graduation check when GRADUATION_STORAGE is fully implemented
            -- if player:getLevel() < 150 or playerGraduation < 2 or getRankLevel(playerRank) < 5 then
            if player:getLevel() < 150 or getRankLevel(playerRank) < 5 then
                npcHandler:say(messages[currentLang].noLvlQuest4, cid)
                npcHandler.topic[cid] = 0
                return true
            end

            player:setStorageValue(HARUNO_JUTSU_STORAGE, 10)
            player:save()
            npcHandler:say(messages[currentLang].quest4Requirements, cid)
            npcHandler:releaseFocus(cid)
            npcHandler.topic[cid] = 0
            return true
        end

        npcHandler.topic[cid] = 0
        return true
    end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
