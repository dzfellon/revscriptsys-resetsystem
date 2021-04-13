--[[ SCRIPTING> MarcelloMkez <scriptING ]]

--[[ [Advanced Reset System]
Autor: MarcelloMkez
Versão: 1.0
TFS: 0.3.6
Testado em: 8.50
Fórum: [Talk Action] Advanced Reset System' - XTibia - A sua comunidade de Tibia e OTserv

[Características]
~ Versão 1.0 ~
- Resets no Look;
- Premium Account ou não;
- Mudar Vocação;
- Limite de Resets;
- Opções para Abilitar e Desabilitar Condições;

[Em Construção]
- Stages Free e Premium;
- 'Talvez' um novo sistema de mudar Vocação;
]]

local resetSys = TalkAction("!reset")

function resetSys.onSay(cid, words, param)

--[Configurações de Condição]

config = {

needPa = false, -- Precisa de Premium Account? [true / false]
needPz = false, -- Precisa estar em Protection Zone? [true / false]
battle = false, -- Precisa estar sem Batlle para Resetar? [true / false]
withe = false, -- Players PK Withe pode Resetar? [true / false]
red = false, -- Players PK Red pode Resetar? [true / false]
tp = true, -- Teleportar para o Templo após o reset? [true / false]
look = true, -- Mostrar Resets no Look do Player? [true / false]
addLimite = true, -- Abilitar Limite de Resets? [true / false]
setClasse = false, -- Mudar Vocação do player quando resetar? [true / false]
storage = 66007, -- Storage [valor]

--[Configurações do Reset]

resetStatus = {
player = getPlayerGUID(cid), -- Não Mude.
lvl = 1000 , -- Level Necessário para Resetar. [valor]
lvlreset = 8, -- Level que retornará após o Reset. [valor]
limite = 50, -- Máximo de resets que um player pode chegar. [valor]
newClasse = 1, -- Id da Nova Vocação após o Reset. [valor]
tempo= 2 -- Tempo para o Player deslogar para Resetar. Em segundos. [valor]
},

}

--[Funções]

function Reseting(cid)
resets = getResets(cid)
setPlayerStorageValue(cid,config.storage,resets+1)
doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
doPlayerSetVocation(cid, config.resetStatus.newClasse)
doRemoveCreature(cid)
db.executeQuery("UPDATE `players` SET `description` = ' [Reset "..resets.."]' WHERE `players`.`id` = "..config.resetStatus.player)
db.executeQuery("UPDATE `players` SET `level` = "..config.resetStatus.lvlreset..", `experience` = 0 WHERE `id` = "..config.resetStatus.player)
return TRUE
end

function noAll(cid)
resets = getResets(cid)
setPlayerStorageValue(cid,config.storage,resets+1)
doRemoveCreature(cid)
db.executeQuery("UPDATE `players` SET `level` = "..config.resetStatus.lvlreset..", `experience` = 0 WHERE `id` = "..config.resetStatus.player)
db.executeQuery("UPDATE `players` SET `description` = '' WHERE `players`.`id` = "..config.resetStatus.player)
return TRUE
end

function noTeleporting(cid)
resets = getResets(cid)
setPlayerStorageValue(cid,config.storage,resets+1)
doPlayerSetVocation(cid, config.resetStatus.newClasse)
doRemoveCreature(cid)
db.executeQuery("UPDATE `players` SET `level` = "..config.resetStatus.lvlreset..", `experience` = 0 WHERE `id` = "..config.resetStatus.player)
db.executeQuery("UPDATE `players` SET `description` = ' [Reset "..resets.."]' WHERE `players`.`id` = "..config.resetStatus.player)
return TRUE
end

function noLook(cid)
resets = getResets(cid)
setPlayerStorageValue(cid,config.storage,resets+1)
doPlayerSetVocation(cid, config.resetStatus.newClasse)
doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
doRemoveCreature(cid)
db.executeQuery("UPDATE `players` SET `level` = "..config.resetStatus.lvlreset..", `experience` = 0 WHERE `id` = "..config.resetStatus.player)
db.executeQuery("UPDATE `players` SET `description` = '' WHERE `players`.`id` = "..config.resetStatus.player)
return TRUE
end

function noClasse(cid)
resets = getResets(cid)
setPlayerStorageValue(cid,config.storage,resets+1)
doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
doRemoveCreature(cid)
db.executeQuery("UPDATE `players` SET `description` = ' [Reset "..resets.."]' WHERE `players`.`id` = "..config.resetStatus.player)
db.executeQuery("UPDATE `players` SET `level` = "..config.resetStatus.lvlreset..", `experience` = 0 WHERE `id` = "..config.resetStatus.player)
return TRUE
end

function setClasse(cid)
resets = getResets(cid)
setPlayerStorageValue(cid,config.storage,resets+1)
doPlayerSetVocation(cid, config.resetStatus.newClasse)
doRemoveCreature(cid)
db.executeQuery("UPDATE `players` SET `description` = '' WHERE `players`.`id` = "..config.resetStatus.player)
db.executeQuery("UPDATE `players` SET `level` = "..config.resetStatus.lvlreset..", `experience` = 0 WHERE `id` = "..config.resetStatus.player)
return TRUE
end

function look(cid)
resets = getResets(cid)
setPlayerStorageValue(cid,config.storage,resets+1)
doRemoveCreature(cid)
db.executeQuery("UPDATE `players` SET `description` = ' [Reset "..resets.."]' WHERE `players`.`id` = "..config.resetStatus.player)
db.executeQuery("UPDATE `players` SET `level` = "..config.resetStatus.lvlreset..", `experience` = 0 WHERE `id` = "..config.resetStatus.player)
return TRUE
end

function teleporting(cid)
resets = getResets(cid)
setPlayerStorageValue(cid,config.storage,resets+1)
doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
doRemoveCreature(cid)
db.executeQuery("UPDATE `players` SET `description` = '' WHERE `players`.`id` = "..config.resetStatus.player)
db.executeQuery("UPDATE `players` SET `level` = "..config.resetStatus.lvlreset..", `experience` = 0 WHERE `id` = "..config.resetStatus.player)
return TRUE
end
  

function getResets(cid)
resets = getPlayerStorageValue(cid,config.storage)
if resets < 0 then
resets = 0
end
return resets
end

local resets = getResets(cid)
--local needLvl ="Vocàprecisa de "config.resetStatus.lvl -player:getLevel(cid)" level's para resetar."
local msg ="~~[Reset: "..getResets(cid).."]~~ 'Sucesso ao Resetar! Vocàserá deslogado em "..config.resetStatus.tempo.." Segundos."

--[Condiçoes]

if(config.needPz == true) and (getTilePzInfo(player:getPosition(cid)) == FALSE) then
doPlayerSendTextMessage(cid,22,"VocàPrecisa estar em Protection Zone Para Resetar.")
return TRUE
elseif(config.addLimite == true) and (getResets(cid) == config.resetStatus.limite) then
doPlayerSendTextMessage(cid, 22, "Vocàja atingiu o Limite de Resets.")
return TRUE

elseif(config.withe == false) and (player:getSkull(cid) == 3) then
doPlayerSendTextMessage(cid,22,"Vocàta PK White, por isso não pode resetar.")
return TRUE

elseif(config.red == false) and (player:getSkull(cid) == 4) then
doPlayerSendTextMessage(cid,22,"Vocàta PK Red, por isso não pode resetar.")
return TRUE

elseif(config.needPa == true) and not isPremium(cid) then
doPlayerSendTextMessage(cid,22,"VocàPrecisa ser Premium Account para Resetar.")
return TRUE

elseif(config.battle == true) and (player:getCondition(cid, CONDITION_INFIGHT) == TRUE) then
doPlayerSendTextMessage(cid,22,"VocàPrecisa estar sem Battle para Resetar.")
return TRUE 

elseif player:getLevel(cid) >= config.resetStatus.lvl and (config.tp == true) and (config.look == true) and (config.setClasse == true) then
addEvent(Reseting, config.resetStatus.tempo* 1000, cid)

elseif player:getLevel(cid) >= config.resetStatus.lvl and (config.tp == false) and (config.look == false) and (config.setClasse == false) then
addEvent(noAll, config.resetStatus.tempo* 1000, cid)

elseif player:getLevel(cid) >= config.resetStatus.lvl and (config.tp == false) and (config.look == true) and (config.setClasse == true) then
addEvent(noTeleporting, config.resetStatus.tempo* 1000, cid)

elseif player:getLevel(cid) >= config.resetStatus.lvl and (config.tp == true) and (config.look == false) and (config.setClasse == true) then
addEvent(noLook, config.resetStatus.tempo* 1000, cid)

elseif player:getLevel(cid) >= config.resetStatus.lvl and (config.tp == true) and (config.look == true) and (config.setClasse == false) then
addEvent(noClasse, config.resetStatus.tempo* 1000, cid)

elseif player:getLevel(cid) >= config.resetStatus.lvl and (config.tp == false) and (config.look == false) and (config.setClasse == true) then
addEvent(setClasse, config.resetStatus.tempo* 1000, cid)

elseif player:getLevel(cid) >= config.resetStatus.lvl and (config.tp == false) and (config.look == true) and (config.setClasse == false) then
addEvent(look, config.resetStatus.tempo* 1000, cid)

elseif player:getLevel(cid) >= config.resetStatus.lvl and (config.tp == true) and (config.look == false) and (config.setClasse == false) then
addEvent(teleporting, config.resetStatus.tempo* 1000, cid)

elseif doPlayerSendCancel(cid, needLvl) then
doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
return TRUE
end

if doPlayerPopupFYI(cid, msg) then

end
return TRUE

end

resetSys:register() 
