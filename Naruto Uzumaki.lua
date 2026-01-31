local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local lang = {}

-- Storage único para rastrear jutsus aprendidos
-- Storage = 0: Nenhum jutsu
-- Storage >= 1: Aprendeu Naruto Rendan (lvl 50)
-- Storage >= 2: Aprendeu Kyuubi no Chakra (lvl 80)
-- Storage >= 3: Aprendeu Oodama Rasengan (lvl 100 + graduated)
-- Storage >= 4: Aprendeu Rasenshuriken (lvl 120 + graduated)
local NARUTO_JUTSU_STORAGE = 70004

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local messages = {
    ["en"] = {
        help = "Hello |PLAYERNAME|. My name is Naruto Uzumaki, and I assist ninjas of the {Uzumaki} clan. Do you need anything from me?",
        noLvl = "Hah, don't ever think about becoming a Uzumaki member with this level. First of all, get {level 5} to join us!",
        askNaruto = "Hey! You want to {become} a member of Uzumaki clan? We are determined to become the best in our village!",
        confirm = "Ok! So you're the optimistic type, hm? Great! But just to be sure, you really want to {join} Uzumaki clan?",
        done = "Great! Now you are a member of the Uzumaki clan! Let's work together to achieve greatness! I trust that one of us will, one day, be the hokage of our village! Ah, I almost forgot. Let me teach you {Kage Bunshin no Jutsu}! It's a jutsu to make copies of yourself. Use it well!",
        isNaruto = "Hello |PLAYERNAME|, what {brings} you here?",
        hasOtherClan = "You already belong to another clan. I cannot assist you.",

        noLvlQuest1 = "Hey |PLAYERNAME|! Sorry but I can't teach you anything right now. Can you come back to me when you're at least {level 50}? Nice! I'll wait for you!",
        quest1 = "Hey hey! You got stronger, right? Now I can teach you a jutsu named {Naruto Rendan}, a jutsu that uses Kage Bunshin to deliver a barrage of attacks at your opponent. Are you ready to {learn Naruto Rendan}?",
        quest1Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Naruto Rendan.",
        quest1Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Naruto Rendan.",
        quest1Done = "Yep, you learned it nice and easy! Now you don't have to worry yourself of not having any technique to use!",

        noLvlQuest2 = "Hey |PLAYERNAME|! I get that you want to learn some new tricks, but see, you need to be a bit stronger to learn more techniques from me. Let's do this: Get {level 80} and I will teach you something nice, okay?",
        quest2 = "So here comes our rising star! I see you've done what I asked for! Ok, so let's teach you a skill named {Kyuubi no Chakra}! It's a buff technique that will increase your general abilities, so you can move faster, hit harder and take less damage! So, let's {learn Kyuubi no Chakra}?",
        quest2Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Kyuubi no Chakra.",
        quest2Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Kyuubi no Chakra.",
        quest2Done = "Such talent! If turning into a Hokage was done using electronic urns, I could consider voting for you! Now I doubt anything would be a problem for you! Let's continue training and getting stronger!",

        noLvlQuest3 = "See, I know I told you to get stronger so I can teach you more techniques, but see, you need to be like, a LOT STRONGER! {Level 100} and {graduated} is enough for the next jutsu, ok? Don't worry, I'll be right here waiting for you!",
        quest3 = "NOW THIS IS WHAT I TALKED ABOUT! I can say for sure you are ready to learn {Oodama Rasengan} from me! This is a powerful technique that materializes your chakra in your palm in a sphere form, but it is like, REALLY BIG! It's not easy to master it, y'know? So, are you ready to {learn Oodama Rasengan}?"
        quest3Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Oodama Rasengan.",
        quest3Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Oodama Rasengan.",
        quest3Done = "Are you sure you aren't like a genius or something? That was not an easy technique, and you still mastered it like it was nothing! But that was the minimum I expect from you! Don't let this get to your head though. Continue training and getting stronger!"

        noLvlQuest4 = "Eager to learn more, hm? I don't mind it at all! I love to see my students getting stronger! I turned into a teacher because of that! BUUUUUUUUT... yeah... You know it, right? I need you to get a bit stronger for this next technique, because boy oh boy, this jutsu will be a BLAST! Let's talk again when you're around {level 120}, kay?",
        quest4 = "So there's our (maybe) future Hokage! I see that you're confident, and I definitely sensed your chakra when you entered the village. You are now ready to learn {Rasenshuriken}! This is like Oodama Rasengan, but smaller... AND MUCH STRONGER! Confused, right? It's because this jutsu has an element embedded in it, turning it extremely destructive AND hard to control. But I'm sure you can handle it! Ready to {learn Rasenshuriken}?",
        quest4Requirements = "So let's start your training. Bring me {one ryo} and I will teach you Rasenshuriken.",
        quest4Incomplete = "You don't have {one ryo} with you. Come back when you do, and I will teach you Rasenshuriken.",
        quest4Done = "That... was... AWESOME! You surpassed yourself and learned to control Rasenshuriken! Just be careful with it, ok? Try not to use it inside the village. When I was learning it I destroyed some houses and the villagers were not happy with me... BUT ANYWAY! Continue training and getting stronger! You are one of the most powerful members in our clan right now, but there's always room to be better!",
        
        alreadyLearnedNarutoRendan = "You have already learned Naruto Rendan from me.",
        alreadyLearnedKyuubiChakra = "You have already learned Kyuubi no Chakra from me.",
        alreadyLearnedOodamaRasengan = "You have already learned Oodama Rasengan from me.",
        alreadyLearnedRasenshuriken = "You have already learned Rasenshuriken from me.",
        allTechniques = "You have mastered all the techniques I can teach you for now. There is nothing more for me to offer.",
    },

    ["pt"] = {
        help = "Olá |PLAYERNAME|. Meu nome é Naruto Uzumaki, e eu auxilio ninjas do clã {Uzumaki}. Você precisa de algo de mim?",
        noLvl = "Opa! Nem pense em se tornar um membro do clã Uzumaki com esse nível. Primeiro, alcance o {level 5} para se juntar a nós!",
        askNaruto = "Ei! Você quer se {tornar} um membro do clã Uzumaki? Nós somos determinados a nos tornar os melhores da nossa vila!",
        confirm = "Ok! Então você é do tipo otimista, hm? Ótimo! Mas só para ter certeza, você realmente quer {fazer parte} do clã Uzumaki?",
        done = "Show! Agora você é um membro do clã Uzumaki! Vamos trabalhar juntos para alcançar o topo! Eu confio que um de nós será, um dia, o hokage da nossa vila! Ah, quase me esqueci. Deixe-me te ensinar {Kage Bunshin no Jutsu}! É um jutsu para fazer cópias de si mesmo. Use-o bem!",        
        isNaruto = "Olá |PLAYERNAME|, o que te {traz} aqui?",
        hasOtherClan = "Você já pertence a outro clã. Não posso te ajudar.",

        noLvlQuest1 = "Hey |PLAYERNAME|! Desculpe, mas não posso te ensinar nada agora. Pode voltar para mim quando você estiver pelo menos no {level 50}? Beleza! Estarei te esperando!",
        quest1 = "Opa! Você ficou mais forte, né? Agora eu posso te ensinar um jutsu chamado {Naruto Rendan}, um jutsu que usa Kage Bunshin para desferir um monte de ataques no seu oponente. Você está pronto para {aprender Naruto Rendan}?",
        quest1Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Naruto Rendan.",
        quest1Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Naruto Rendan.",
        quest1Done = "É isso aí, você aprendeu fácil e rápido! Agora você não precisa mais se preocupar em não ter nenhuma técnica para usar!",

        noLvlQuest2 = "Hey |PLAYERNAME|! Eu entendo que você quer aprender alguns truques novos, mas veja, você precisa ser um pouco mais forte para aprender mais técnicas comigo. Vamos fazer o seguinte: Chegue ao {level 80} e eu te ensinarei algo legal, ok?",
        quest2 = "Lá vem nossa estrela em ascensão! Vejo que você fez o que eu pedi! Ok, então vou te ensinar uma habilidade chamada {Kyuubi no Chakra}! É uma ténica de buff que aumentará seus status gerais, para que você possa se mover mais rápido, bater mais forte e receber menos dano! Então, vamos {aprender Kyuubi no Chakra}?",
        quest2Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Kyuubi no Chakra.",
        quest2Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Kyuubi no Chakra.",
        quest2Done = "Quanto talento! Se virar Hokage fosse feito usando urnas eletrônicas, eu poderia considerar votar em você! Agora eu duvido que algo seria um problema para você! Vamos continuar treinando e ficando mais fortes!",

        noLvlQuest3 = "Olha só, eu sei que te disse para ficar mais forte para que eu possa te ensinar mais técnicas, mas veja, você precisa ser MUITO MAIS FORTE! {Level 100} e ser {graduado} é suficiente para o próximo jutsu, ok? Não se preocupe, estarei bem aqui te esperando!",
        quest3 = "AGORA SIM! É DISSO QUE EU ESTAVA FALANDO! Posso dizer com certeza que você está pronto para aprender {Oodama Rasengan} comigo! Esta é uma técnica que materializa seu chakra na palma da sua mão em forma de esfera, mas é tipo, REALMENTE GRANDE! Não é fácil dominá-la, sabe? Então, você está pronto para {aprender Oodama Rasengan}?",
        quest3Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Oodama Rasengan.",
        quest3Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Oodama Rasengan.",
        quest3Done = "Você tem certeza de que não é algum tipo de gênio ou algo assim? Essa não foi uma técnica fácil, e você ainda assim a dominou como se não fosse nada! Mas esse foi o mínimo que eu esperava de você! Não deixe isso subir à cabeça, ok? Continue treinando e ficando mais forte!",

        noLvlQuest4 = "Sempre querendo aprender mais, em? Eu não me importo nem um pouco! Adoro ver meus alunos ficando mais fortes! Eu me tornei um professor por causa disso! MAAAAAAS... sim... Você sabe, certo? Preciso que você fique um pouco mais forte para essa próxima técnica, porque rapaz, esse jutsu vai ser uma EXPLOSÃO! Vamos conversar novamente quando você estiver por volta do {level 120}, beleza?",
        quest4 = "Então aqui está nosso (talvez) futuro Hokage! Vejo que você está confiante, e definitivamente senti seu chakra quando você entrou na vila. Você agora está pronto para aprender {Rasenshuriken}! É parecido com o Oodama Rasengan, mas menor... E MUITO MAIS FORTE! Confuso, né? É porque esse jutsu tem um elemento embutido, tornando-o extremamente destrutivo E difícil de controlar. Mas tenho certeza que você pode lidar com isso! Pronto para {aprender Rasenshuriken}?",
        quest4Requirements = "Então, vamos começar seu treinamento. Traga-me {um ryo} e eu te ensinarei Rasenshuriken.",
        quest4Incomplete = "Você não tem {um ryo} com você. Volte quando tiver, e eu te ensinarei Rasenshuriken.",
        quest4Done = "Isso... foi... INCRÍVEL! Você se superou e aprendeu a controlar o Rasenshuriken! Só tome cuidado com ele, ok? Tente não usar dentro da vila. Quando eu estava aprendendo, destruí algumas casas e os moradores não ficaram felizes comigo... MAS ENFIM! Continue treinando e ficando mais forte! Você é um dos membros mais poderosos do nosso clã agora, mas sempre há espaço para melhorar!",

        alreadyLearnedNarutoRendan = "Você já aprendeu Naruto Rendan de mim.",
        alreadyLearnedKyuubiChakra = "Você já aprendeu Kyuubi no Chakra de mim.",
        alreadyLearnedOodamaRasengan = "Você já aprendeu Oodama Rasengan de mim.",
        alreadyLearnedRasenshuriken = "Você já aprendeu Rasenshuriken de mim.",
        allTechniques = "Você já dominou todas as técnicas que posso te ensinar por enquanto. Não tenho mais nada a oferecer.",
    }
}

local validWords = {
    ["pt"] = {"ajudar", "uzumaki", "tornar", "fazer parte", "traz", "aprender naruto rendan", "aprender kyuubi no chakra", "aprender oodama rasengan", "aprender rasenshuriken"},
    ["en"] = {"help", "uzumaki", "become", "join", "brings", "learn naruto rendan", "learn kyuubi no chakra", "learn oodama rasengan", "learn rasenshuriken"}
}

local function creatureSayCallback(cid, type, msg)
    local msgLower = string.lower(msg)
    local player = Player(cid)
    local narutoVocationId = 10
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

    -- Fluxo Uzumaki
    if msgcontains(msgLower, "uzumaki") then
        if playerVocation ~= 0 and playerVocation ~= narutoVocationId then
            npcHandler:say(messages[currentLang].hasOtherClan, cid)
            npcHandler:releaseFocus(cid)
            return true
        elseif playerVocation == narutoVocationId then
            npcHandler:say(string.gsub(messages[currentLang].isNaruto, "|PLAYERNAME|", player:getName()), cid)
            npcHandler.topic[cid] = 0
            return true
        else
            npcHandler:say(messages[currentLang].askNaruto, cid)
            npcHandler.topic[cid] = 1
            return true
        end
    end

    -- Fluxo de confirmação
    if npcHandler.topic[cid] == 1 and (msgcontains(msgLower, "tornar") or msgcontains(msgLower, "become")) then
        if player:getLevel() < 5 then
            npcHandler:say(messages[currentLang].noLvl, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        npcHandler:say(messages[currentLang].confirm, cid)
        npcHandler.topic[cid] = 2
        return true
    elseif npcHandler.topic[cid] == 2 and (msgcontains(msgLower, "fazer parte") or msgcontains(msgLower, "join")) then
        player:setVocation(Vocation(narutoVocationId))
        player:save()
        player:setOutfit({lookType = 380})
        player:addOutfit(380)
        player:learnSpell("Kage Bunshin no Jutsu")
        player:getPosition():sendMagicEffect(478)
        npcHandler:say(messages[currentLang].done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Verifica qual jutsu o jogador pode aprender
    if msgcontains(msgLower, "brings") or msgcontains(msgLower, "traz") then
        if playerVocation ~= narutoVocationId then
            npcHandler:say(messages[currentLang].help, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        local narutoJutsu = player:getStorageValue(NARUTO_JUTSU_STORAGE)
        if narutoJutsu == -1 then
            narutoJutsu = 0
        end
        
        -- Determinar qual é o próximo jutsu baseado no storage
        if narutoJutsu == 0 then
            if player:getLevel() < 50 then
                npcHandler:say(messages[currentLang].noLvlQuest1, cid)
            else
                npcHandler:say(messages[currentLang].quest1, cid)
                npcHandler.topic[cid] = 10
            end
        elseif narutoJutsu == 1 then
            if player:getLevel() < 80 then
                npcHandler:say(messages[currentLang].noLvlQuest2, cid)
            else
                npcHandler:say(messages[currentLang].quest2, cid)
                npcHandler.topic[cid] = 20
            end
        elseif narutoJutsu == 2 then
            if player:getLevel() < 100 then
                npcHandler:say(messages[currentLang].noLvlQuest3, cid)
            else
                npcHandler:say(messages[currentLang].quest3, cid)
                npcHandler.topic[cid] = 30
            end
        elseif narutoJutsu == 3 then
            if player:getLevel() < 120 then
                npcHandler:say(messages[currentLang].noLvlQuest4, cid)
            else
                npcHandler:say(messages[currentLang].quest4, cid)
                npcHandler.topic[cid] = 40
            end
        else
            npcHandler:say(messages[currentLang].allTechniques, cid)
        end
        return true
    end

    -- Learn Naruto Rendan
    if msgcontains(msgLower, "learn naruto rendan") or msgcontains(msgLower, "aprender naruto rendan") then
        local narutoJutsu = player:getStorageValue(NARUTO_JUTSU_STORAGE)
        if narutoJutsu == -1 then
            narutoJutsu = 0
            npcHandler:say(messages[currentLang].quest1Requirements, cid)
        end
        
        if narutoJutsu >= 1 then
            npcHandler:say(messages[currentLang].alreadyLearnedNarutoRendan, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest1Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Naruto Rendan")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(NARUTO_JUTSU_STORAGE, 1)
        player:save()
        npcHandler:say(messages[currentLang].quest1Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Kyuubi no Chakra
    if msgcontains(msgLower, "learn kyuubi no chakra") or msgcontains(msgLower, "aprender kyuubi no chakra") then
        local narutoJutsu = player:getStorageValue(NARUTO_JUTSU_STORAGE)
        if narutoJutsu == -1 then
            narutoJutsu = 0
            npcHandler:say(messages[currentLang].quest2Requirements, cid)
        end
        
        if narutoJutsu >= 2 then
            npcHandler:say(messages[currentLang].alreadyLearnedKyuubiChakra, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest2Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Kyuubi no Chakra")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(NARUTO_JUTSU_STORAGE, 2)
        player:save()
        npcHandler:say(messages[currentLang].quest2Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Oodama Rasengan
    if msgcontains(msgLower, "learn oodama rasengan") or msgcontains(msgLower, "aprender oodama rasengan") then
        local narutoJutsu = player:getStorageValue(NARUTO_JUTSU_STORAGE)
        if narutoJutsu == -1 then
            narutoJutsu = 0
            npcHandler:say(messages[currentLang].quest3Requirements, cid)
        end
        
        if narutoJutsu >= 3 then
            npcHandler:say(messages[currentLang].alreadyLearnedOodamaRasengan, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest3Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Oodama Rasengan")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(NARUTO_JUTSU_STORAGE, 3)
        player:save()
        npcHandler:say(messages[currentLang].quest3Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end

    -- Learn Rasenshuriken
    if msgcontains(msgLower, "learn rasenshuriken") or msgcontains(msgLower, "aprender rasenshuriken") then
        local narutoJutsu = player:getStorageValue(NARUTO_JUTSU_STORAGE)
        if narutoJutsu == -1 then
            narutoJutsu = 0
            npcHandler:say(messages[currentLang].quest4Requirements, cid)
        end
        
        if narutoJutsu >= 4 then
            npcHandler:say(messages[currentLang].alreadyLearnedRasenshuriken, cid)
            npcHandler.topic[cid] = 0
            return true
        end

        if player:getItemCount(10549) < 1 then
            npcHandler:say(messages[currentLang].quest4Incomplete, cid)
            npcHandler.topic[cid] = 0
            return true
        end
        
        player:removeItem(10549, 1)
        player:learnSpell("Rasenshuriken")
        player:getPosition():sendMagicEffect(478)
        player:setStorageValue(NARUTO_JUTSU_STORAGE, 4)
        player:save()
        npcHandler:say(messages[currentLang].quest4Done, cid)
        npcHandler:releaseFocus(cid)
        npcHandler.topic[cid] = 0
        return true
    end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
