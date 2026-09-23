local SUPPORTED_GAME_IDS = {
    [10298144467] = true,
    [10445190670] = true,
}
local LOBBY_PLACE_ID = 107653945083776
local TOWER_PLACE_ID = 133623616308412
local RAID_PLACE_IDS = {
    [133207600268474] = true,
    [107431701292918] = true,
    [87737123573764] = true,
    [88223935702156] = true,
}
local DUNGEON_PLACE_IDS = {
    [100480543373112] = true,
    [89230410866378] = true,
}
local IS_TOWER = game.PlaceId == TOWER_PLACE_ID
local IS_RAID = RAID_PLACE_IDS[game.PlaceId] == true
local IS_DUNGEON = DUNGEON_PLACE_IDS[game.PlaceId] == true
local IS_RUN = IS_TOWER or IS_RAID or IS_DUNGEON
local LOBBY_PLACE_IDS = {
    [LOBBY_PLACE_ID] = true,
    [72769188242214] = true,
}
local IS_LOBBY = LOBBY_PLACE_IDS[game.PlaceId] == true
if not SUPPORTED_GAME_IDS[game.GameId] then
    warn("[ARF Hub] Unsupported game: " .. tostring(game.GameId))
    return
end
print("[ARF Hub] starting at place " .. tostring(game.PlaceId))

local env = getgenv and getgenv() or _G
local previous = env.__ARF_HUB
local configHttp = game:GetService("HttpService")
local configPlayers = game:GetService("Players")
local configPlayer = configPlayers.LocalPlayer
while not configPlayer do
    configPlayers:GetPropertyChangedSignal("LocalPlayer"):Wait()
    configPlayer = configPlayers.LocalPlayer
end
local configFile = "Anime roll to fight_" .. tostring(configPlayer.UserId) .. ".json"
local readFile = env.readfile or readfile
local writeFile = env.writefile or writefile
local isFile = env.isfile or isfile
local SavedConfig = {}
if type(readFile) == "function" then
    local ok, raw = pcall(function()
        if type(isFile) == "function" and not isFile(configFile) then
            return nil
        end
        return readFile(configFile)
    end)
    if ok and type(raw) == "string" and raw ~= "" then
        local decodedOk, decoded = pcall(configHttp.JSONDecode, configHttp, raw)
        if decodedOk and type(decoded) == "table" then
            SavedConfig = decoded
        end
    end
end

local function configValue(key, default)
    if previous and previous[key] ~= nil then
        return previous[key]
    end
    if SavedConfig[key] ~= nil then
        return SavedConfig[key]
    end
    return default
end

local PreviousConfig = {
    AutoBuy = configValue("AutoBuy", false),
    BuyAll = configValue("BuyAll", false),
    KeepGold = configValue("KeepGold", 0),
    NativeAutoPlay = configValue("NativeAutoPlay", false),
    AutoMerchant = configValue("AutoMerchant", false),
    MerchantBuyAll = configValue("MerchantBuyAll", false),
    AutoTower = configValue("AutoTower", false),
    AutoRunReturn = configValue("AutoRunReturn", true),
    AutoPortal = configValue("AutoPortal", false),
    PortalAutoStart = configValue("PortalAutoStart", true),
    PortalMinMembers = configValue("PortalMinMembers", 1),
    AutoRaid = configValue("AutoRaid", false),
    RaidAutoStart = configValue("RaidAutoStart", false),
    RaidMinMembers = configValue("RaidMinMembers", 1),
    AutoSpin = configValue("AutoSpin", false),
    AutoEquipBest = configValue("AutoEquipBest", false),
    GameSpeed = configValue("GameSpeed", "x1"),
    AutoUpgrade = configValue("AutoUpgrade", false),
    AutoClaimPass = configValue("AutoClaimPass", false),
    AutoClaimQuest = configValue("AutoClaimQuest", false),
    StartAtWave = configValue("StartAtWave", 0),
    StopAtWave = configValue("StopAtWave", 0),
    AntiAFK = configValue("AntiAFK", true),
    AutoReconnect = configValue("AutoReconnect", false),
    Bypass = configValue("Bypass", false),
    RemoveOtherBases = configValue("RemoveOtherBases", false),
    MobileToggle = configValue("MobileToggle", true),
    AutoClone = configValue("AutoClone", false),
    AutoEvolve = configValue("AutoEvolve", false),
    WebhookEnabled = configValue("WebhookEnabled", false),
    WebhookURL = configValue("WebhookURL", ""),
    FixLag = configValue("FixLag", false),
    HideNames = configValue("HideNames", false),
    HideMode = configValue("HideMode", "My Name"),
    SelectedUnits = {},
    SelectedRarities = {},
    SelectedMutations = {},
    SelectedMerchantItems = {},
    SelectedUpgradeTypes = {},
    SelectedCloneUnits = {},
    SelectedEvolveUnits = {},
    SelectedPortalDifficulties = {},
    SelectedPortalNames = {},
    SelectedRaidDifficulties = {},
    SelectedRaidMaps = {},
    RaidHistory = {},
}
local selectionSource = previous or SavedConfig
if selectionSource then
    for name, selected in pairs(selectionSource.SelectedUnits or {}) do
        PreviousConfig.SelectedUnits[name] = selected
    end
    for rarity, selected in pairs(selectionSource.SelectedRarities or {}) do
        PreviousConfig.SelectedRarities[rarity] = selected
    end
    for mutation, selected in pairs(selectionSource.SelectedMutations or {}) do
        PreviousConfig.SelectedMutations[mutation] = selected
    end
    for name, selected in pairs(selectionSource.SelectedMerchantItems or {}) do
        PreviousConfig.SelectedMerchantItems[name] = selected
    end
    for name, selected in pairs(selectionSource.SelectedUpgradeTypes or {}) do
        PreviousConfig.SelectedUpgradeTypes[name] = selected
    end
    for uuid, selected in pairs(selectionSource.SelectedCloneUnits or {}) do
        PreviousConfig.SelectedCloneUnits[uuid] = selected
    end
    for uuid, selected in pairs(selectionSource.SelectedEvolveUnits or {}) do
        PreviousConfig.SelectedEvolveUnits[uuid] = selected
    end
    for name, selected in pairs(selectionSource.SelectedPortalDifficulties or {}) do
        PreviousConfig.SelectedPortalDifficulties[name] = selected
    end
    for name, selected in pairs(selectionSource.SelectedPortalNames or {}) do
        PreviousConfig.SelectedPortalNames[name] = selected
    end
    for name, selected in pairs(selectionSource.SelectedRaidDifficulties or {}) do
        PreviousConfig.SelectedRaidDifficulties[name] = selected
    end
    for name, selected in pairs(selectionSource.SelectedRaidMaps or {}) do
        PreviousConfig.SelectedRaidMaps[name] = selected
    end
    if type(selectionSource.RaidHistory) == "table" then
        for _, w in ipairs(selectionSource.RaidHistory) do
            if type(w) == "table" and tonumber(w.s) and tonumber(w.e) and tonumber(w.t) == 1 then
                table.insert(PreviousConfig.RaidHistory, { s = tonumber(w.s), e = tonumber(w.e), j = tostring(w.j or "") })
            end
        end
    end
end
if previous and previous.Alive and previous.LoadTime and os.clock() - previous.LoadTime < 5 then
    warn("[ARF Hub] Reload debounced")
    env.__ARF_HUB = previous
    return
end
if previous and previous.Cleanup then
    pcall(previous.Cleanup)
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local function safeWait(parent, name, timeout)
    if parent == nil then
        return nil
    end
    local ok, obj = pcall(parent.WaitForChild, parent, name, timeout or 10)
    if ok then
        return obj
    end
    return nil
end
local function safeRequire(path)
    local ok, mod = pcall(require, path)
    if ok then
        return mod
    end
    return nil
end
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 15)
local CharacterRemotes = safeWait(Remotes, "Characters")
local FightFolder = safeWait(Remotes, "Fight")
local FightRemote = safeWait(FightFolder, "Start")
local RollRemote = safeWait(CharacterRemotes, "Roll")
local BuyRemote = safeWait(CharacterRemotes, "Buy")
local UpdateInventoryRemote = safeWait(CharacterRemotes, "UpdateInventory")
local TraderRemotes = Remotes and Remotes:FindFirstChild("Trader")
local TraderStockRemote = TraderRemotes and TraderRemotes:FindFirstChild("GetStock")
local TraderBuyRemote = TraderRemotes and TraderRemotes:FindFirstChild("Buy")
local JoinTowerRemote = safeWait(Remotes, "JoinTower")
local PortalsFolder = safeWait(Remotes, "Portals")
local PortalRequest = safeWait(PortalsFolder, "Request")
local PortalUpdate = safeWait(PortalsFolder, "Update")
local RaidsFolder = safeWait(Remotes, "Raids")
local RaidRequest = safeWait(RaidsFolder, "Request")
local RaidUpdate = safeWait(RaidsFolder, "Update")
local SpinRemote = safeWait(safeWait(Remotes, "SpinWheel"), "Spin")
local UpgradeRemote = safeWait(Remotes, "Upgrade")
local TopModules = safeWait(ReplicatedStorage, "Modules")
local BattlepassModule = safeWait(TopModules, "Battlepass")
local ClaimPassRemote = safeWait(BattlepassModule, "Claim")
local BattlepassQuest = safeWait(BattlepassModule, "BattlepassQuest")
local GetQuestDataRemote = safeWait(BattlepassQuest, "GetQuestData")
local ClaimQuestRemote = safeWait(BattlepassQuest, "ClaimQuest")
local CloneRemote = safeWait(safeWait(Remotes, "CloneRemotes"), "Request")
local EvolveRemote = safeWait(safeWait(Remotes, "EvolutionRemotes"), "Evolve")
local SharedModules = safeWait(TopModules, "Shared")
local CharactersFolder = TopModules and TopModules:FindFirstChild("Characters")
local CharacterInfo = safeRequire(CharactersFolder and CharactersFolder:FindFirstChild("CharactersInfo")) or { Characters = {}, Mutations = {} }
local SharedItems = SharedModules and SharedModules:FindFirstChild("Items")
local ItemsInfo = safeRequire(SharedItems and SharedItems:FindFirstChild("ItemsInfo")) or { Items = {} }
local DataService = safeRequire(ReplicatedStorage:FindFirstChild("Data") and ReplicatedStorage.Data:FindFirstChild("DataService"))
local DataClient = DataService and DataService.client
local HasDataClient = DataClient ~= nil
if not DataClient then
    warn("[ARF Hub] No DataService, continuing degraded")
    DataClient = {
        get = function()
            return nil
        end,
        waitForData = function()
            return false
        end,
    }
end
local SharedEvolve = SharedModules and SharedModules:FindFirstChild("Evolve")
local EvolutionInfo = safeRequire(SharedEvolve and SharedEvolve:FindFirstChild("EvolutionInfo")) or { Characters = {} }
local AnimeState = safeRequire(SharedModules and SharedModules:FindFirstChild("AnimeState")) or {
    GetCloning = function() return {} end,
    GetEvolution = function() return {} end,
    GetCloneLeft = function() return 1 end,
    GetTimerLeft = function() return math.huge end,
}
local UpgradesInfo = safeRequire(SharedModules and SharedModules:FindFirstChild("UpgradesInfo")) or {
    IsMaxed = function() return true end,
}
local BattlepassReward = safeRequire(BattlepassModule and BattlepassModule:FindFirstChild("BattlepassReward")) or {}
local PortalsInfo = nil
pcall(function()
    PortalsInfo = require(ReplicatedStorage.Modules.Shared.Portals.PortalsInfo)
end)
local AccesoryInfo = nil
pcall(function()
    AccesoryInfo = require(ReplicatedStorage.Modules.Shared.Accesory.AccesoryInfo)
end)
if HasDataClient then
    local dataReady = false
    task.spawn(function()
        pcall(function()
            DataClient:waitForData()
        end)
        dataReady = true
    end)
    local deadline = os.clock() + 20
    while not dataReady and os.clock() < deadline do
        task.wait(0.5)
    end
    if not dataReady then
        warn("[ARF Hub] DataService not ready after 20s, continuing degraded")
    end
end

local State = {
    Alive = true,
    AutoBuy = PreviousConfig.AutoBuy,
    BuyAll = PreviousConfig.BuyAll,
    KeepGold = PreviousConfig.KeepGold,
    NativeAutoPlay = PreviousConfig.NativeAutoPlay,
    AutoMerchant = PreviousConfig.AutoMerchant,
    MerchantBuyAll = PreviousConfig.MerchantBuyAll,
    AutoTower = PreviousConfig.AutoTower,
    AutoSpin = PreviousConfig.AutoSpin,
    AutoEquipBest = PreviousConfig.AutoEquipBest,
    GameSpeed = PreviousConfig.GameSpeed,
    AutoUpgrade = PreviousConfig.AutoUpgrade,
    AutoClaimPass = PreviousConfig.AutoClaimPass,
    AutoClaimQuest = PreviousConfig.AutoClaimQuest,
    StartAtWave = PreviousConfig.StartAtWave,
    StopAtWave = PreviousConfig.StopAtWave,
    AntiAFK = PreviousConfig.AntiAFK,
    AutoReconnect = PreviousConfig.AutoReconnect,
    Bypass = PreviousConfig.Bypass,
    RemoveOtherBases = PreviousConfig.RemoveOtherBases,
    MobileToggle = PreviousConfig.MobileToggle,
    LastSpinAt = 0,
    LastEquipAt = 0,
    EquipBusy = false,
    AutoClone = PreviousConfig.AutoClone,
    AutoEvolve = PreviousConfig.AutoEvolve,
    AutoPortal = PreviousConfig.AutoPortal,
    PortalAutoStart = PreviousConfig.PortalAutoStart,
    PortalMinMembers = PreviousConfig.PortalMinMembers,
    AutoRaid = PreviousConfig.AutoRaid,
    RaidAutoStart = PreviousConfig.RaidAutoStart,
    RaidMinMembers = PreviousConfig.RaidMinMembers,
    AutoRunReturn = PreviousConfig.AutoRunReturn,
    SelectedPortalDifficulties = PreviousConfig.SelectedPortalDifficulties,
    SelectedPortalNames = PreviousConfig.SelectedPortalNames,
    SelectedRaidDifficulties = PreviousConfig.SelectedRaidDifficulties,
    SelectedRaidMaps = PreviousConfig.SelectedRaidMaps,
    RaidHistory = PreviousConfig.RaidHistory,
    PortalSession = nil,
    PortalInviteId = nil,
    LastPortalAction = 0,
    RaidParty = nil,
    RaidBrowse = {},
    RaidInviteId = nil,
    LastRaidAction = 0,
    WebhookEnabled = PreviousConfig.WebhookEnabled,
    WebhookURL = PreviousConfig.WebhookURL,
    SelectedUnits = PreviousConfig.SelectedUnits,
    SelectedRarities = PreviousConfig.SelectedRarities,
    SelectedMutations = PreviousConfig.SelectedMutations,
    SelectedMerchantItems = PreviousConfig.SelectedMerchantItems,
    SelectedUpgradeTypes = PreviousConfig.SelectedUpgradeTypes,
    SelectedCloneUnits = PreviousConfig.SelectedCloneUnits,
    SelectedEvolveUnits = PreviousConfig.SelectedEvolveUnits,
    MobileGui = nil,
    PendingBuys = {},
    ConfirmedPurchases = {},
    PurchaseBusy = false,
    ActionBusy = false,
    MerchantBusy = false,
    MerchantPending = false,
    MerchantLabels = {},
    CloneLabels = {},
    EvolveLabels = {},
    PurchaseResults = {},
    LastCloneAction = 0,
    LastEvolveAction = 0,
    LastEvolveClaim = nil,
    FixLag = PreviousConfig.FixLag,
    RollRequests = 0,
    RollPending = false,
    RollBusy = false,
    RollAttempt = 0,
    LastRollId = nil,
    NextRollAt = 0,
    Connections = {},
    VFXConnections = {},
    MemoryPurged = false,
    HiddenHumanoids = {},
    HiddenBillboards = {},
    HiddenVisuals = setmetatable({}, { __mode = "k" }),
    DetachedPlots = {},
    OriginalPlotSpeeds = setmetatable({}, { __mode = "k" }),
    OriginalBypassAttributes = {},
    HideNames = PreviousConfig.HideNames,
    HideMode = PreviousConfig.HideMode,
    OriginalGlobalShadows = Lighting.GlobalShadows,
    OriginalQuality = settings().Rendering.QualityLevel,
    OriginalFPSBoost = LocalPlayer:GetAttribute("FPSBoost"),
}
env.__ARF_HUB = State
local PurchaseSignal = Instance.new("BindableEvent")
for _, attribute in ipairs({ "Luck2x", "SuperLuck", "UltraLuck", "Mutation2x" }) do
    local value = LocalPlayer:GetAttribute(attribute)
    State.OriginalBypassAttributes[attribute] = value == nil and "__nil" or value
end

local function saveConfigNow()
    if type(writeFile) ~= "function" then
        return false
    end
    local config = {
        AutoBuy = State.AutoBuy,
        BuyAll = State.BuyAll,
        KeepGold = State.KeepGold,
        NativeAutoPlay = State.NativeAutoPlay,
        AutoMerchant = State.AutoMerchant,
        MerchantBuyAll = State.MerchantBuyAll,
        AutoTower = State.AutoTower,
        AutoPortal = State.AutoPortal,
        PortalAutoStart = State.PortalAutoStart,
        PortalMinMembers = State.PortalMinMembers,
        AutoRaid = State.AutoRaid,
        RaidAutoStart = State.RaidAutoStart,
        RaidMinMembers = State.RaidMinMembers,
        AutoRunReturn = State.AutoRunReturn,
        AutoSpin = State.AutoSpin,
        AutoEquipBest = State.AutoEquipBest,
        GameSpeed = State.GameSpeed,
        AutoUpgrade = State.AutoUpgrade,
        AutoClaimPass = State.AutoClaimPass,
        AutoClaimQuest = State.AutoClaimQuest,
        StartAtWave = State.StartAtWave,
        StopAtWave = State.StopAtWave,
        AntiAFK = State.AntiAFK,
        AutoReconnect = State.AutoReconnect,
        Bypass = State.Bypass,
        RemoveOtherBases = State.RemoveOtherBases,
        MobileToggle = State.MobileToggle,
        AutoClone = State.AutoClone,
        AutoEvolve = State.AutoEvolve,
        WebhookEnabled = State.WebhookEnabled,
        WebhookURL = State.WebhookURL,
        FixLag = State.FixLag,
        HideNames = State.HideNames,
        HideMode = State.HideMode,
        SelectedUnits = State.SelectedUnits,
        SelectedRarities = State.SelectedRarities,
        SelectedMutations = State.SelectedMutations,
        SelectedMerchantItems = State.SelectedMerchantItems,
        SelectedUpgradeTypes = State.SelectedUpgradeTypes,
        SelectedCloneUnits = State.SelectedCloneUnits,
        SelectedEvolveUnits = State.SelectedEvolveUnits,
        SelectedPortalDifficulties = State.SelectedPortalDifficulties,
        SelectedPortalNames = State.SelectedPortalNames,
        SelectedRaidDifficulties = State.SelectedRaidDifficulties,
        SelectedRaidMaps = State.SelectedRaidMaps,
        RaidHistory = State.RaidHistory,
    }
    return pcall(writeFile, configFile, configHttp:JSONEncode(config))
end

local saveRevision = 0
local function scheduleConfigSave()
    saveRevision += 1
    local revision = saveRevision
    task.delay(0.35, function()
        if State.Alive and revision == saveRevision then
            saveConfigNow()
        end
    end)
end

local function connect(signal, callback)
    if signal == nil then
        return nil
    end
    local connection = signal:Connect(callback)
    table.insert(State.Connections, connection)
    return connection
end

local httpRequest = env.request or env.http_request or (env.syn and env.syn.request) or (env.fluxus and env.fluxus.request)
local function sendWebhook(title, description, color)
    if not State.WebhookEnabled or State.WebhookURL == "" or type(httpRequest) ~= "function" then
        return
    end

    task.spawn(function()
        pcall(function()
            httpRequest({
                Url = State.WebhookURL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({
                    username = "Anime Rolls Hub - made by Truyem789",
                    allowed_mentions = { parse = {} },
                    embeds = {{
                        author = {
                            name = "Anime Rolls Hub - made by Truyem789",
                        },
                        title = tostring(title or "Notification"),
                        description = tostring(description or "No details available."),
                        color = color or 5793266,
                        fields = {
                            {
                                name = "Player",
                                value = string.format("`%s` (@%s)", LocalPlayer.DisplayName, LocalPlayer.Name),
                                inline = true,
                            },
                            {
                                name = "User ID",
                                value = "`" .. tostring(LocalPlayer.UserId) .. "`",
                                inline = true,
                            },
                            {
                                name = "Server",
                                value = string.format("Place `%s` | Version `%s`\nJob `%s`", tostring(game.PlaceId), tostring(game.PlaceVersion), tostring(game.JobId)),
                                inline = false,
                            },
                        },
                        footer = { text = "Anime Rolls Hub | made by Truyem789" },
                        timestamp = DateTime.now():ToIsoDate(),
                    }},
                }),
            })
        end)
    end)
end

local unitNames = {}
local unitRarities = {}
local unitPrices = {}
local raritySet = {}
local mutationNames = { "None" }
local mutationSet = { None = true }

local function addMutationName(name)
    name = tostring(name or "")
    if name ~= "" and not mutationSet[name] then
        mutationSet[name] = true
        table.insert(mutationNames, name)
    end
end

for name in pairs(CharacterInfo.Mutations or {}) do
    addMutationName(name)
end
local mutationAssets = ReplicatedStorage:FindFirstChild("Assets")
mutationAssets = mutationAssets and mutationAssets:FindFirstChild("Mutations")
if mutationAssets then
    for _, mutation in ipairs(mutationAssets:GetChildren()) do
        addMutationName(mutation.Name)
    end
end
table.sort(mutationNames, function(a, b)
    if a == "None" or b == "None" then
        return a == "None" and b ~= "None"
    end
    return a < b
end)

for _, info in pairs(CharacterInfo.Characters) do
    if type(info) == "table" and type(info.Name) == "string" then
        table.insert(unitNames, info.Name)
        unitRarities[info.Name] = tostring(info.Rarity or "Unknown")
        unitPrices[info.Name] = tonumber(info.Price) or 0
        raritySet[tostring(info.Rarity or "Unknown")] = true
    end
end

table.sort(unitNames)
local rarityNames = {}
for rarity in pairs(raritySet) do
    table.insert(rarityNames, rarity)
end
table.sort(rarityNames)

local function replaceSelection(target, value)
    if type(value) ~= "table" then
        table.clear(target)
        return
    end

    local selectedValues = {}
    for key, selected in pairs(value) do
        if type(key) == "number" then
            table.insert(selectedValues, tostring(selected))
        elseif selected == true then
            table.insert(selectedValues, tostring(key))
        end
    end
    table.clear(target)
    for _, selected in ipairs(selectedValues) do
        target[selected] = true
    end
end

local function normalizeSelection(value)
    return string.lower(tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function selectionContains(selection, wanted)
    if type(selection) ~= "table" then
        return false
    end
    local normalizedWanted = normalizeSelection(wanted)
    for key, selected in pairs(selection) do
        if type(key) == "number" then
            if normalizeSelection(selected) == normalizedWanted then
                return true
            end
        elseif selected == true and normalizeSelection(key) == normalizedWanted then
            return true
        elseif type(selected) == "string" and normalizeSelection(selected) == normalizedWanted then
            return true
        end
    end
    return false
end

local function shouldBuy(result)
    local name = tostring(result.Name or "")
    local rarity = tostring(result.Rarity or unitRarities[name] or "Unknown")
    local mutation = tostring(result.Mutation or "None")
    local price = tonumber(result.Price) or unitPrices[name] or 0
    local options = State.Fluent and State.Fluent.Options
    local liveUnits = options and options.BuyUnits and options.BuyUnits.Value
    local liveRarities = options and options.BuyRarities and options.BuyRarities.Value
    local matched = State.BuyAll
        or selectionContains(State.SelectedUnits, name)
        or selectionContains(liveUnits, name)
        or selectionContains(State.SelectedRarities, rarity)
        or selectionContains(liveRarities, rarity)
    if not matched then
        return false
    end
    if next(State.SelectedMutations) ~= nil and not selectionContains(State.SelectedMutations, mutation) then
        return false
    end
    return true
end

State.RollConnection = connect(RollRemote and RollRemote.OnClientEvent, function(player, _, results, _, rollId)
    if not State.Alive or not State.AutoBuy or player ~= LocalPlayer or type(results) ~= "table" or rollId == nil then
        return
    end
    State.RollPending = false
    local currentRollId = tostring(rollId or "")
    local rollCooldown = LocalPlayer:GetAttribute("FastSummon") == true and 0.65 or 2.25
    if currentRollId == "" or currentRollId == State.LastRollId then
        State.NextRollAt = os.clock() + rollCooldown
        return
    end
    State.LastRollId = currentRollId
    State.NextRollAt = os.clock() + rollCooldown

    if not State.AutoBuy then
        return
    end

    local queued = false
    for slot, result in pairs(results) do
        if type(result) == "table" and shouldBuy(result) then
            local purchaseKey = tostring(rollId) .. ":" .. tostring(slot)
            queued = true
            table.insert(State.PendingBuys, {
                Key = purchaseKey,
                RollId = rollId,
                Slot = slot,
                Result = result,
                Price = tonumber(result.Price) or unitPrices[tostring(result.Name or "")] or 0,
                ReadyAt = os.clock() + 0.05,
            })
            State.PurchaseResults[purchaseKey] = result
        end
    end

    if queued then
        State.NextRollAt = math.huge
        PurchaseSignal:Fire()
    end

end)

State.BuyConnection = connect(BuyRemote and BuyRemote.OnClientEvent, function(player, rollId, slot)
    if player ~= LocalPlayer then
        return
    end
    local key = tostring(rollId) .. ":" .. tostring(slot)
    local result = State.PurchaseResults[key]
    if not result then
        return
    end
    State.ConfirmedPurchases[key] = true
    if result and State.WebhookEnabled then
        sendWebhook(
            "Unit Purchased",
            string.format("**%s**\nRarity: `%s`\nMutation: `%s`\nPrice: `%s`", tostring(result.Name or "Unknown"), tostring(result.Rarity or unitRarities[tostring(result.Name or "")] or "Unknown"), tostring(result.Mutation or "None"), tostring(result.Price or unitPrices[tostring(result.Name or "")] or 0)),
            5763719
        )
    end
    PurchaseSignal:Fire()
end)

task.spawn(function()
    while State.Alive do
        local pending = State.PendingBuys[1]
        if not pending or not State.AutoBuy then
            PurchaseSignal.Event:Wait()
        elseif not State.PurchaseBusy then
            if State.ConfirmedPurchases[pending.Key] then
                table.remove(State.PendingBuys, 1)
                State.ConfirmedPurchases[pending.Key] = nil
                State.PurchaseResults[pending.Key] = nil
                if #State.PendingBuys == 0 then
                    State.NextRollAt = os.clock() + 0.5
                end
                continue
            end
            local waitTime = pending.ReadyAt - os.clock()
            if waitTime > 0 then
                task.wait(math.min(waitTime, 0.5))
                continue
            end
            local gold = tonumber(DataClient:get({ "Gold" })) or 0
            if gold < pending.Price + State.KeepGold then
                task.wait(1)
            else
                State.PurchaseBusy = true
                local sent = pcall(function()
                    BuyRemote:FireServer(pending.RollId, pending.Slot)
                end)
                if sent then
                    local deadline = os.clock() + 2
                    repeat
                        task.wait(0.05)
                    until not State.Alive or not State.AutoBuy or State.PendingBuys[1] ~= pending or State.ConfirmedPurchases[pending.Key] or os.clock() >= deadline
                end
                if State.ConfirmedPurchases[pending.Key] then
                    if State.PendingBuys[1] == pending then
                        table.remove(State.PendingBuys, 1)
                    end
                    State.ConfirmedPurchases[pending.Key] = nil
                    State.PurchaseResults[pending.Key] = nil
                elseif State.PendingBuys[1] == pending then
                    pending.ReadyAt = os.clock() + 0.5
                end
                State.PurchaseBusy = false
                if #State.PendingBuys == 0 then
                    State.NextRollAt = os.clock() + 0.5
                end
            end
        end
    end
end)

local function setNativeAutoPlay(enabled)
    State.NativeAutoPlay = enabled
    local current = LocalPlayer:GetAttribute("FightAutoPlay") == true
    if FightRemote and current ~= enabled then
        FightRemote:FireServer("AutoPlay")
    end
    scheduleConfigSave()
end

local lastAutoStart = 0
local function getLocalPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then
        return nil
    end

    for _, plot in ipairs(plots:GetChildren()) do
        if plot:GetAttribute("Owner") == LocalPlayer.Name or plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            return plot
        end
    end
    return nil
end

local function applyBypass(enabled)
    for _, attribute in ipairs({ "Luck2x", "SuperLuck", "UltraLuck", "Mutation2x" }) do
        if enabled then
            LocalPlayer:SetAttribute(attribute, true)
        else
            local original = State.OriginalBypassAttributes[attribute]
            LocalPlayer:SetAttribute(attribute, original == "__nil" and nil or original)
        end
    end
    local plot = getLocalPlot()
    if plot then
        if enabled then
            if State.OriginalPlotSpeeds[plot] == nil then
                local original = plot:GetAttribute("FightFastForwardSpeed")
                State.OriginalPlotSpeeds[plot] = original == nil and "__nil" or original
            end
            plot:SetAttribute("FightFastForwardSpeed", 10)
        else
            local original = State.OriginalPlotSpeeds[plot]
            if original ~= nil then
                plot:SetAttribute("FightFastForwardSpeed", original == "__nil" and nil or original)
                State.OriginalPlotSpeeds[plot] = nil
            end
        end
    end
end

local function applyRemoveOtherBases(enabled)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then
        return
    end
    if enabled then
        for _, plot in ipairs(plots:GetChildren()) do
            local owned = plot:GetAttribute("Owner") == LocalPlayer.Name or plot:GetAttribute("OwnerUserId") == LocalPlayer.UserId
            if not owned and not State.DetachedPlots[plot] then
                State.DetachedPlots[plot] = plots
                plot.Parent = nil
            end
        end
    else
        for plot, parent in pairs(State.DetachedPlots) do
            if not plot.Parent and parent.Parent then
                plot.Parent = parent
            end
        end
        table.clear(State.DetachedPlots)
    end
end

connect(LocalPlayer.Idled, function()
    if State.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

local reconnecting = false
local function reconnect()
    if not State.Alive or not State.AutoReconnect or reconnecting then
        return
    end
    reconnecting = true
    saveConfigNow()
    task.delay(2, function()
        local ok = pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
        if not ok then
            reconnecting = false
        end
    end)
end

connect(GuiService.ErrorMessageChanged, function(message)
    if type(message) == "string" and message ~= "" then
        reconnect()
    end
end)

connect(Players.PlayerRemoving, function(player)
    if player == LocalPlayer then
        reconnect()
    end
end)

local cachedRollPrompt
local function getLocalRollPrompt()
    if cachedRollPrompt and cachedRollPrompt.Parent then
        return cachedRollPrompt
    end
    local plot = getLocalPlot()
    local roll = plot and plot:FindFirstChild("Roll")
    local rollButton = roll and roll:FindFirstChild("RollButton")
    local button = rollButton and rollButton:FindFirstChild("Button")
    cachedRollPrompt = button and button:FindFirstChild("RollPrompt")
    return cachedRollPrompt
end

local function activatePrompt(prompt)
    if State.ActionBusy or not prompt or not prompt:IsA("ProximityPrompt") then
        return false
    end

    local targetCFrame
    if prompt.Parent:IsA("BasePart") then
        targetCFrame = prompt.Parent.CFrame
    elseif prompt.Parent:IsA("Attachment") then
        targetCFrame = prompt.Parent.WorldCFrame
    else
        return false
    end

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then
        return false
    end

    State.ActionBusy = true
    local originalCFrame = root.CFrame
    local success = pcall(function()
        root.CFrame = targetCFrame * CFrame.new(0, 0, 3)
        task.wait(0.25)
        prompt:InputHoldBegin()
        task.wait(math.max(prompt.HoldDuration + 0.2, 0.3))
        prompt:InputHoldEnd()
    end)
    if root.Parent then
        root.CFrame = originalCFrame
    end
    State.ActionBusy = false
    return success
end

local function triggerRoll()
    if State.RollBusy or #State.PendingBuys > 0 then
        return false
    end

    local prompt = getLocalRollPrompt()
    if not prompt or not prompt:IsA("ProximityPrompt") then
        return false
    end

    State.RollPending = true
    State.RollBusy = true
    State.RollAttempt += 1
    local attempt = State.RollAttempt
    State.RollRequests += 1
    local success = activatePrompt(prompt)
    State.RollBusy = false
    if not success then
        State.RollPending = false
        return false
    end

    task.delay(5, function()
        if State.Alive and State.RollPending and State.RollAttempt == attempt then
            State.RollPending = false
            State.NextRollAt = os.clock() + 1
        end
    end)
    return true
end

task.spawn(function()
    while State.Alive do
        if State.AutoBuy and #State.PendingBuys == 0 and not State.RollPending and not State.RollBusy and os.clock() >= State.NextRollAt then
            triggerRoll()
        end
        task.wait(State.AutoBuy and 0.1 or 2)
    end
end)

local function getInfiniteTickets()
    for _, item in pairs(DataClient:get({ "Items" }) or {}) do
        if item.Name == "Infinite Ticket" then
            return tonumber(item.amount or item.Amount or item.Quantity) or 0
        end
    end
    return 0
end

task.spawn(function()
    local joinPending = false
    local joinRequestedAt = 0
    while State.Alive do
        local running = LocalPlayer:GetAttribute("FightRunning") == true
        if running then
            joinPending = false
        elseif not IS_RUN and State.AutoTower and getInfiniteTickets() > 0 then
            if not joinPending or os.clock() - joinRequestedAt >= 30 then
                joinPending = true
                joinRequestedAt = os.clock()
                saveConfigNow()
                if JoinTowerRemote then
                    pcall(function()
                        JoinTowerRemote:FireServer(IS_TOWER and "Play" or nil)
                    end)
                end
            end
        else
            joinPending = false
        end
        task.wait(State.AutoTower and 1 or 5)
    end
end)

local portalDifficultyNames = { "Easy", "Medium", "Hard", "Extreme" }
if PortalsInfo and type(PortalsInfo.DifficultyOrder) == "table" and #PortalsInfo.DifficultyOrder > 0 then
    portalDifficultyNames = PortalsInfo.DifficultyOrder
end
local portalNames = { "Clover Portal" }
if PortalsInfo and type(PortalsInfo.Portals) == "table" then
    portalNames = {}
    for name in pairs(PortalsInfo.Portals) do
        table.insert(portalNames, tostring(name))
    end
    table.sort(portalNames)
end
if #portalNames == 0 then
    portalNames = { "Clover Portal" }
end
local raidDifficultyNames = { "Easy", "Medium", "Hard", "Extreme" }
local raidMapNames = {}
if AccesoryInfo and type(AccesoryInfo.IndividualChance) == "table" then
    for name in pairs(AccesoryInfo.IndividualChance) do
        table.insert(raidMapNames, tostring(name))
    end
end
if AccesoryInfo and AccesoryInfo.RaidConfig and type(AccesoryInfo.RaidConfig.RaidChances) == "table" then
    for name in pairs(AccesoryInfo.RaidConfig.RaidChances) do
        if not selectionContains(raidMapNames, name) then
            table.insert(raidMapNames, tostring(name))
        end
    end
end
table.sort(raidMapNames)
if #raidMapNames == 0 then
    raidMapNames = { "Ant Kingdom", "Red Knight's Dungeon" }
end

local function getRaidCountdownText()
    local mainUI = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
    local frames = mainUI and mainUI:FindFirstChild("Frames")
    local raids = frames and frames:FindFirstChild("Raids")
    local panel = raids and raids:FindFirstChild("Raids")
    local frame = panel and panel:FindFirstChild("Frame")
    local closeTime = frame and frame:FindFirstChild("CloseTime")
    local label = closeTime and closeTime:FindFirstChild("Time")
    if label and label:IsA("TextLabel") then
        return label.Text
    end
    return nil
end

local function parseClockText(text)
    local m, s = tostring(text or ""):match("(%d+):(%d+)")
    m, s = tonumber(m), tonumber(s)
    if m ~= nil and s ~= nil then
        return m * 60 + s
    end
    return nil
end

local function getRaidTimeLeft()
    if tonumber(workspace:GetAttribute("RaidEndsAt")) == nil then
        return 0
    end
    local left = parseClockText(getRaidCountdownText())
    if left ~= nil then
        return left
    end
    return 1
end

local function isRaidOpen()
    return getRaidTimeLeft() > 0
end

local function portalFilterEmpty(selection)
    return type(selection) ~= "table" or next(selection) == nil
end

local function raidWindowMatches()
    if not portalFilterEmpty(State.SelectedRaidDifficulties) then
        local diff = workspace:GetAttribute("RaidDifficulty")
        if not selectionContains(State.SelectedRaidDifficulties, diff) then
            return false
        end
    end
    if not portalFilterEmpty(State.SelectedRaidMaps) then
        local map = workspace:GetAttribute("RaidMapName")
        if not selectionContains(State.SelectedRaidMaps, map) then
            return false
        end
    end
    return true
end

local function formatClock(seconds)
    seconds = math.max(math.floor(tonumber(seconds) or 0), 0)
    return string.format("%02d:%02d", math.floor(seconds / 60), seconds % 60)
end

local function recordRaidWindow(startTime, endTime)
    if type(startTime) ~= "number" or type(endTime) ~= "number" or endTime <= startTime then
        return
    end
    State.RaidHistory = State.RaidHistory or {}
    table.insert(State.RaidHistory, { s = startTime, e = endTime, j = tostring(game.JobId), t = 1 })
    while #State.RaidHistory > 10 do
        table.remove(State.RaidHistory, 1)
    end
    scheduleConfigSave()
end

local function estimateNextRaid()
    local now = os.clock()
    if not now then
        return nil
    end
    local wins = {}
    for _, w in ipairs(State.RaidHistory or {}) do
        if type(w) == "table" and type(w.s) == "number" and type(w.e) == "number" and tostring(w.j or "") == tostring(game.JobId) then
            table.insert(wins, w)
        end
    end
    table.sort(wins, function(a, b) return a.s < b.s end)
    if #wins < 2 then
        return nil
    end
    if wins[#wins].e > now + 60 then
        return nil
    end
    local gapSum, gapN = 0, 0
    for i = 2, #wins do
        local gap = wins[i].s - wins[i - 1].e
        if gap > 0 and gap < 86400 then
            gapSum += gap
            gapN += 1
        end
    end
    if gapN == 0 then
        return nil
    end
    return (wins[#wins].e + gapSum / gapN) - now, gapN
end

local function portalWants(difficulty, portalName)
    if not portalFilterEmpty(State.SelectedPortalDifficulties) and not selectionContains(State.SelectedPortalDifficulties, difficulty) then
        return false
    end
    if not portalFilterEmpty(State.SelectedPortalNames) and not selectionContains(State.SelectedPortalNames, portalName) then
        return false
    end
    return true
end

local function countMembers(members)
    local count = 0
    if type(members) == "table" then
        for _ in pairs(members) do
            count += 1
        end
    end
    return count
end

local function getPortalItemCount(portalName, difficulty)
    local target = nil
    if PortalsInfo and type(PortalsInfo.ItemName) == "function" then
        local ok, resolved = pcall(PortalsInfo.ItemName, portalName, difficulty)
        if ok and type(resolved) == "string" then
            target = normalizeSelection(resolved)
        end
    end
    if not target then
        target = normalizeSelection(tostring(portalName) .. " (" .. tostring(difficulty) .. ")")
    end
    local total = 0
    for _, item in pairs(DataClient:get({ "Items" }) or {}) do
        if type(item) == "table" and normalizeSelection(item.Name) == target then
            total += tonumber(item.amount or item.Amount or item.Quantity) or 0
        end
    end
    return total
end

local function getOwnedPortalItems()
    local owned = {}
    if PortalsInfo and type(PortalsInfo.Resolve) == "function" then
        local seen = {}
        for _, item in pairs(DataClient:get({ "Items" }) or {}) do
            if type(item) == "table" and type(item.Name) == "string" then
                local ok, portalName, difficulty = pcall(PortalsInfo.Resolve, item.Name)
                if ok and type(portalName) == "string" and type(difficulty) == "string" then
                    local count = tonumber(item.amount or item.Amount or item.Quantity) or 0
                    local key = portalName .. "|" .. difficulty
                    if count > 0 and not seen[key] then
                        seen[key] = true
                        table.insert(owned, { Portal = portalName, Difficulty = difficulty, Count = count })
                    end
                end
            end
        end
    end
    table.sort(owned, function(a, b)
        if a.Portal ~= b.Portal then
            return a.Portal < b.Portal
        end
        return a.Difficulty < b.Difficulty
    end)
    return owned
end

local function safeOwnedPortalItems()
    local ok, result = pcall(getOwnedPortalItems)
    if ok and type(result) == "table" then
        return result
    end
    warn("[ARF Hub] portal item scan failed: " .. tostring(result))
    return {}
end

local function refreshStatusParas()
    if State.PortalStatusPara then
        local lines = {}
        local owned = safeOwnedPortalItems()
        if #owned == 0 then
            table.insert(lines, "No portal item — farm bosses for portals.")
        else
            for _, entry in ipairs(owned) do
                table.insert(lines, string.format("%s (%s) x%d", entry.Portal, entry.Difficulty, entry.Count))
            end
        end
        local setDesc = State.PortalStatusPara and State.PortalStatusPara.SetDesc
        if type(setDesc) ~= "function" then
            warn("[ARF Hub] portal status paragraph has no SetDesc")
        else
            local ok, err = pcall(setDesc, State.PortalStatusPara, table.concat(lines, "\n"))
            if not ok then
                warn("[ARF Hub] portal status update failed: " .. tostring(err))
            end
        end
    end
    if State.RaidStatusPara then
        local left = getRaidTimeLeft()
        local text
            if left <= 0 then
                local remaining, samples = estimateNextRaid()
                if remaining ~= nil and remaining > 0 then
                    text = string.format("CLOSED — next ~%s (est. n=%d)", formatClock(remaining), samples)
                elseif remaining ~= nil then
                    text = "CLOSED — window overdue, watching..."
                else
                    text = "CLOSED — watching schedule..."
                end
        elseif not raidWindowMatches() then
            text = string.format("OPEN but filtered out: %s (%s) — %s left", tostring(workspace:GetAttribute("RaidMapName") or "?"), tostring(workspace:GetAttribute("RaidDifficulty") or "?"), formatClock(left))
        else
            text = string.format("OPEN: %s (%s) — %s left", tostring(workspace:GetAttribute("RaidMapName") or "?"), tostring(workspace:GetAttribute("RaidDifficulty") or "?"), formatClock(left))
        end
        local setDesc = State.RaidStatusPara and State.RaidStatusPara.SetDesc
        if type(setDesc) ~= "function" then
            warn("[ARF Hub] raid status paragraph has no SetDesc")
        else
            local ok, err = pcall(setDesc, State.RaidStatusPara, text)
            if not ok then
                warn("[ARF Hub] raid status update failed: " .. tostring(err))
            end
        end
    end
end

local function hasAnyPortalItem()
    for _, portalName in ipairs(portalNames) do
        for _, difficulty in ipairs(portalDifficultyNames) do
            if portalWants(difficulty, portalName) and getPortalItemCount(portalName, difficulty) > 0 then
                return true
            end
        end
    end
    return false
end

connect(PortalUpdate and PortalUpdate.OnClientEvent, function(action, data)
    if not State.Alive then
        return
    end
    if action == "Session" and type(data) == "table" then
        State.PortalSession = data
    elseif action == "Closed" then
        State.PortalSession = nil
        State.PortalInviteId = nil
    elseif action == "Invite" and type(data) == "table" then
        State.PortalInviteId = nil
    end
end)

connect(RaidUpdate and RaidUpdate.OnClientEvent, function(action, data)
    if not State.Alive then
        return
    end
    if action == "Party" and type(data) == "table" then
        State.RaidParty = data
    elseif action == "Browse" and type(data) == "table" then
        State.RaidBrowse = data.Parties or data
    elseif action == "Closed" then
        State.RaidParty = nil
        State.RaidInviteId = nil
    elseif action == "Invite" and type(data) == "table" then
        State.RaidInviteId = nil
    elseif action == "End" and type(data) == "table" then
        local victory = data.Victory == true
        local rewardBits = {}
        if type(data.Rewards) == "table" then
            for _, reward in pairs(data.Rewards) do
                if type(reward) == "table" and #rewardBits < 10 then
                    local bit = tostring(reward.Name or reward.ItemName or reward.Character or "?")
                    if reward.Amount ~= nil then
                        bit ..= " x" .. tostring(reward.Amount)
                    end
                    table.insert(rewardBits, bit)
                end
            end
        end
        State.LastRunResult = victory and "Run Victory" or "Run Defeat"
        State.LastRunEndAt = os.clock()
        sendWebhook(victory and "Raid Victory" or "Raid Defeat", string.format("**%s** (%s)\nTime: `%s`\nRewards: %s", tostring(data.MapName or "?"), tostring(data.Difficulty or "?"), tostring(data.Duration or "?"), (#rewardBits > 0 and table.concat(rewardBits, ", ") or "none shown")), victory and 5763719 or 15548997)
    end
end)

task.spawn(function()
    while State.Alive do
        if not State.AutoPortal then
            task.wait(5)
            continue
        end
        local session = State.PortalSession
        local isOwner = session and session.Owner == LocalPlayer.UserId
        if session == nil then
            if os.clock() - State.LastPortalAction >= 5 then
                State.LastPortalAction = os.clock()
                pcall(function()
                    PortalRequest:FireServer("Refresh")
                end)
                if hasAnyPortalItem() then
                    task.wait(1)
                    if State.Alive and State.AutoPortal and State.PortalSession == nil then
                        pcall(function()
                            PortalRequest:FireServer("Create", "Private")
                        end)
                        sendWebhook("Portal Created", "Created a solo portal party.", 5793266)
                    end
                end
            end
        elseif isOwner and State.PortalAutoStart then
            local members = countMembers(session.Members)
            local needSetup = session.Privacy == nil
            if not needSetup and members >= math.max(tonumber(State.PortalMinMembers) or 1, 1) and os.clock() - State.LastPortalAction >= 5 then
                State.LastPortalAction = os.clock()
                pcall(function()
                    PortalRequest:FireServer("Start")
                end)
            end
        end
        task.wait(2)
    end
end)

task.spawn(function()
    while State.Alive do
        local ok, err = pcall(refreshStatusParas)
        if not ok then
            warn("[ARF Hub] status refresh failed: " .. tostring(err))
        end
        task.wait(5)
    end
end)

task.spawn(function()
    local wasOpen = isRaidOpen()
    local windowStart = nil
    while State.Alive do
        local open = isRaidOpen()
        if open and not wasOpen then
            windowStart = os.clock()
            if not State.AutoRaid then
                warn("[ARF Hub] raid window open but Auto Raid (Solo) is OFF - enable it to auto-join")
            end
            pcall(function()
                local f = State.Fluent
                if f then
                    f:Notify({
                        Title = "Raid Window Open",
                        Content = string.format("%s (%s)", tostring(workspace:GetAttribute("RaidMapName") or "?"), tostring(workspace:GetAttribute("RaidDifficulty") or "?")),
                        Duration = 10,
                    })
                end
            end)
        elseif not open and wasOpen then
            if windowStart then
                recordRaidWindow(windowStart, os.clock())
            end
            windowStart = nil
        end
        wasOpen = open
        task.wait(5)
    end
end)

task.spawn(function()
    local notifiedOpen = false
    while State.Alive do
        if not State.AutoRaid then
            task.wait(5)
            continue
        end
        if not isRaidOpen() then
            notifiedOpen = false
            task.wait(5)
            continue
        end
        if not notifiedOpen then
            notifiedOpen = true
            sendWebhook("Raid Window Open", string.format("**%s** (%s) — %s left", tostring(workspace:GetAttribute("RaidMapName") or "?"), tostring(workspace:GetAttribute("RaidDifficulty") or "?"), formatClock(getRaidTimeLeft())), 5793266)
            State.RaidParty = nil
            pcall(function()
                RaidRequest:FireServer("Leave")
            end)
        end
        if not raidWindowMatches() then
            task.wait(5)
            continue
        end
        if State.AutoMerchant and TraderBuyRemote then
            if State.MerchantBusy or State.MerchantPending then
                task.wait(2)
                continue
            end
            local mStock = nil
            if TraderStockRemote then
                local mOk, mRes = pcall(function()
                    return TraderStockRemote:InvokeServer()
                end)
                if mOk and type(mRes) == "table" then
                    mStock = mRes
                end
            end
            if mStock == nil then
                local fOk, fRes = pcall(function()
                    return DataClient:get({ "Trader" })
                end)
                if fOk and type(fRes) == "table" then
                    mStock = fRes
                end
            end
            if type(mStock) == "table" then
                local mGold = tonumber(DataClient:get({ "Gold" })) or 0
                local needMerchant = false
                for _, mItem in ipairs(mStock.Items or {}) do
                    local mName = tostring(mItem.Name or "")
                    local mPrice = tonumber(mItem.Price) or 0
                    local mAmount = tonumber(mItem.Stock) or 0
                    local mWanted = State.MerchantBuyAll or State.SelectedMerchantItems[mName] == true
                    if mName ~= "" and mAmount > 0 and mWanted and mGold >= mPrice then
                        needMerchant = true
                        break
                    end
                end
                if needMerchant then
                    State.MerchantPending = true
                    task.wait(2)
                    continue
                end
            end
        end
        local party = State.RaidParty
        local isLeader = party and (party.Leader == LocalPlayer.UserId or party.Created == true)
        if party == nil or (type(party.Members) == "table" and #party.Members <= 1 and party.Created ~= true) then
            if os.clock() - State.LastRaidAction >= 8 then
                State.LastRaidAction = os.clock()
                pcall(function()
                    RaidRequest:FireServer("Refresh")
                end)
                task.wait(1)
                if State.Alive and State.AutoRaid and State.RaidParty == nil then
                    pcall(function()
                        RaidRequest:FireServer("Create", "Private")
                    end)
                    print("[ARF Hub] raid Create fired")
                    sendWebhook("Raid Created", "Created a solo raid party.", 5793266)
                    task.wait(2)
                    if State.Alive and State.AutoRaid and isRaidOpen() then
                        State.LastRaidAction = os.clock()
                        pcall(function()
                            RaidRequest:FireServer("Start")
                        end)
                        print("[ARF Hub] raid Start fired (post-create)")
                    end
                end
            end
        elseif isLeader and State.RaidAutoStart then
            local members = countMembers(party.Members)
            if members >= math.max(tonumber(State.RaidMinMembers) or 1, 1) and os.clock() - State.LastRaidAction >= 5 then
                State.LastRaidAction = os.clock()
                pcall(function()
                    RaidRequest:FireServer("Start")
                end)
                print(string.format("[ARF Hub] raid Start fired (leader, members=%d)", members))
            end
        end
        if State.RaidAutoStart and (party == nil or isLeader) then
            if os.clock() - State.LastRaidAction >= 10 then
                State.LastRaidAction = os.clock()
                pcall(function()
                    RaidRequest:FireServer("Start")
                end)
                print("[ARF Hub] raid Start fired (force)")
            end
        end
        task.wait(3)
    end
end)

task.spawn(function()
    while State.Alive do
        if State.AutoSpin and os.clock() - State.LastSpinAt >= 15 then
            local spin = tonumber(DataClient:get({ "Spin" })) or 0
            if spin > 0 then
                State.LastSpinAt = os.clock()
                pcall(function()
                    SpinRemote:FireServer("Spin")
                end)
            end
        end
        task.wait(5)
    end
end)

local function fetchMerchantStock()
    if TraderStockRemote then
        local ok, stock = pcall(function()
            return TraderStockRemote:InvokeServer()
        end)
        if ok and type(stock) == "table" then
            return stock
        end
    end
    local ok2, fallback = pcall(function()
        return DataClient:get({ "Trader" })
    end)
    if ok2 and type(fallback) == "table" then
        return fallback
    end
    return nil
end

local function isMerchantItemWanted(name)
    return State.MerchantBuyAll or State.SelectedMerchantItems[name] == true
end

local function hasMerchantWork(stock, gold)
    if type(stock) ~= "table" then
        return false
    end
    gold = gold or tonumber(DataClient:get({ "Gold" })) or 0
    for _, item in ipairs(stock.Items or {}) do
        local name = tostring(item.Name or "")
        local price = tonumber(item.Price) or 0
        local amount = tonumber(item.Stock) or 0
        if name ~= "" and amount > 0 and isMerchantItemWanted(name) and gold >= price then
            return true
        end
    end
    return false
end

local function buyMerchantSweep()
    if not State.AutoMerchant or not TraderBuyRemote then
        State.MerchantPending = false
        return false
    end
    if State.MerchantBusy then
        return true
    end
    local stock = fetchMerchantStock()
    if type(stock) ~= "table" then
        State.MerchantPending = false
        return false
    end
    local gold = tonumber(DataClient:get({ "Gold" })) or 0
    if not hasMerchantWork(stock, gold) then
        State.MerchantPending = false
        return false
    end
    State.MerchantBusy = true
    State.MerchantPending = true
    local boughtAny = false
    for _, item in ipairs(stock.Items or {}) do
        if not State.Alive or not State.AutoMerchant then
            break
        end
        local name = tostring(item.Name or "")
        local price = tonumber(item.Price) or 0
        local amount = math.floor(tonumber(item.Stock) or 0)
        if name ~= "" and amount > 0 and isMerchantItemWanted(name) then
            for _ = 1, amount do
                if gold < price then
                    break
                end
                local ok = pcall(function()
                    TraderBuyRemote:FireServer(name)
                end)
                if not ok then
                    break
                end
                gold -= price
                boughtAny = true
                task.wait(0.2)
            end
        end
    end
    State.MerchantBusy = false
    if boughtAny then
        State.MerchantPending = true
    else
        State.MerchantPending = hasMerchantWork(fetchMerchantStock(), nil)
    end
    return boughtAny or State.MerchantPending
end

task.spawn(function()
    while State.Alive do
        if not State.AutoMerchant then
            State.MerchantPending = false
            State.MerchantBusy = false
            task.wait(15)
            continue
        end
        if not TraderStockRemote or not TraderBuyRemote then
            task.wait(15)
            continue
        end
        local ok, err = pcall(buyMerchantSweep)
        if not ok then
            State.MerchantBusy = false
            warn("[ARF Hub] merchant sweep failed: " .. tostring(err))
        end
        task.wait(State.AutoMerchant and 1 or 8)
    end
end)

local charLookup = {}
for _, info in pairs(CharacterInfo.Characters) do
    if info.Name then
        charLookup[info.Name] = info
    end
end

local function getButtonText(button)
    if not button:IsA("GuiButton") then
        return ""
    end
    local parts = {}
    if button:IsA("TextButton") and button.Text ~= "" then
        table.insert(parts, button.Text)
    end
    for _, descendant in ipairs(button:GetDescendants()) do
        if descendant:IsA("TextLabel") and descendant.Text ~= "" then
            table.insert(parts, descendant.Text)
        end
    end
    return string.lower(table.concat(parts, " "))
end

local function clickNativeButton(button)
    local fired = false
    if type(firesignal) == "function" then
        fired = pcall(firesignal, button.MouseButton1Click)
    end
    if not fired then
        fired = pcall(function()
            button:Activate()
        end)
    end
    return fired
end

local function activateEquipBest()
    if State.EquipBusy or not State.Alive then
        return false
    end
    State.EquipBusy = true
    local success = pcall(function()
        UpdateInventoryRemote:FireServer("EquipBest")
    end)
    State.EquipBusy = false
    return success
end

task.spawn(function()
    while State.Alive do
        if State.AutoEquipBest and #State.PendingBuys == 0 and not State.RollPending and LocalPlayer:GetAttribute("FightRunning") ~= true and os.clock() - State.LastEquipAt >= 5 then
            State.LastEquipAt = os.clock()
            activateEquipBest()
        end
        task.wait(State.AutoEquipBest and 1 or 10)
    end
end)

local function applyGameSpeed()
    local wanted = string.lower(tostring(State.GameSpeed or "x1"))
    local alternate = string.sub(wanted, 2) .. "x"
    local mainUI = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
    if not mainUI then
        return false
    end
    for _, instance in ipairs(mainUI:GetDescendants()) do
        if instance:IsA("GuiButton") and not instance:FindFirstAncestor("Configuration") then
            local text = getButtonText(instance):gsub("%s", "")
            local name = string.lower(instance.Name):gsub("%s", "")
            if text == wanted or text == alternate or name == wanted or name == alternate then
                return clickNativeButton(instance)
            end
        end
    end
    return false
end

local upgradeTypes = { "Gold", "Luck", "Slots", "Inventory" }

local function getBattlepassLevel(exp)
    local level = 0
    local cumulative = 0
    local maxLevel = tonumber(BattlepassReward.Config and BattlepassReward.Config.MaxLevel) or 30
    for index = 1, maxLevel do
        local reward = BattlepassReward.Rewards and BattlepassReward.Rewards[index]
        local required = reward and tonumber(reward.EXP) or math.huge
        if cumulative + required > (tonumber(exp) or 0) then
            break
        end
        cumulative += required
        level = index
    end
    return level
end

local function claimBattlepassRewards()
    local data = DataClient:get({ "Battlepass" })
    if type(data) ~= "table" then
        return
    end
    local claimed = data.Claimed or {}
    local freeClaimed = claimed.Free or {}
    local premiumClaimed = claimed.Premium or {}
    local premium = data.Premium or {}
    local currentSeason = tonumber(BattlepassReward.Config and BattlepassReward.Config.Season) or 1
    local premiumOwned = premium.Owned == true and tonumber(premium.Season) == currentSeason
    local level = getBattlepassLevel(data.Exp)
    for index = 1, level do
        if freeClaimed[tostring(index)] ~= true then
            ClaimPassRemote:FireServer(index, "Free")
            task.wait(0.15)
        end
        if premiumOwned and premiumClaimed[tostring(index)] ~= true then
            ClaimPassRemote:FireServer(index, "Premium")
            task.wait(0.15)
        end
    end
end

local function claimBattlepassQuests()
    local ok, questData = pcall(function()
        return GetQuestDataRemote:InvokeServer()
    end)
    if not ok or type(questData) ~= "table" then
        return
    end
    for _, category in ipairs({ "Daily", "Weekly" }) do
        for _, quest in ipairs(questData[category] or {}) do
            if type(quest) == "table" and quest.ID and quest.Claimed ~= true then
                local progress = tonumber(quest.Progress) or 0
                local requirement = tonumber(quest.Requirement) or 1
                if (quest.Completed == true or progress >= requirement) and ClaimQuestRemote then
                    ClaimQuestRemote:FireServer(category, quest.ID)
                    task.wait(0.3)
                end
            end
        end
    end
end

task.spawn(function()
    local lastSpeed = 0
    local lastUpgrade = 0
    local lastPass = 0
    local lastQuest = 0
    local lastBypass = 0
    local upgradeIndex = 0
    while State.Alive do
        local now = os.clock()
        if State.GameSpeed ~= "x1" and now - lastSpeed >= 5 then
            lastSpeed = now
            applyGameSpeed()
        end
        if State.AutoUpgrade and now - lastUpgrade >= 1.5 then
            lastUpgrade = now
            local choices = {}
            for _, upgradeType in ipairs(upgradeTypes) do
                if next(State.SelectedUpgradeTypes) == nil or selectionContains(State.SelectedUpgradeTypes, upgradeType) then
                    table.insert(choices, upgradeType)
                end
            end
            if #choices > 0 then
                upgradeIndex = upgradeIndex % #choices + 1
                local upgradeType = choices[upgradeIndex]
                local level = DataClient:get({ "Upgrades", upgradeType })
                if level == nil and UpgradesInfo.Upgrades and UpgradesInfo.Upgrades.Default then
                    level = UpgradesInfo.Upgrades.Default[upgradeType]
                end
                if not UpgradesInfo.IsMaxed(upgradeType, level) then
                    local price = UpgradesInfo.GetPrice(upgradeType, level)
                    local gold = tonumber(DataClient:get({ "Gold" })) or 0
                    if price and gold >= price and UpgradeRemote then
                        UpgradeRemote:FireServer("Gold", upgradeType)
                    end
                end
            end
        end
        if State.AutoClaimPass and now - lastPass >= 30 then
            lastPass = now
            pcall(claimBattlepassRewards)
        end
        if State.AutoClaimQuest and now - lastQuest >= 30 then
            lastQuest = now
            claimBattlepassQuests()
        end
        if State.Bypass and now - lastBypass >= 1 then
            lastBypass = now
            applyBypass(true)
        end
        local active = State.GameSpeed ~= "x1" or State.AutoUpgrade or State.AutoClaimPass or State.AutoClaimQuest or State.Bypass
        task.wait(active and 0.5 or 10)
    end
end)

if State.Bypass then
    task.defer(function()
        if State.Alive then
            applyBypass(true)
        end
    end)
end
if State.RemoveOtherBases then
    task.defer(function()
        if State.Alive then
            applyRemoveOtherBases(true)
        end
    end)
end
if (IS_RAID or IS_DUNGEON) and State.NativeAutoPlay then
    task.defer(function()
        if State.Alive then
            setNativeAutoPlay(true)
        end
    end)
end

local function getAllUnits()
    local units = {}
    local seen = {}
    for _, containerName in ipairs({ "Inventory", "Equipped" }) do
        for _, unit in pairs(DataClient:get({ containerName }) or {}) do
            local uuid = tostring(unit.UUID or unit.CharacterId or "")
            if uuid ~= "" and not seen[uuid] then
                seen[uuid] = true
                table.insert(units, unit)
            end
        end
    end
    return units
end

local evolutionTargets = {}
for targetName, info in pairs(EvolutionInfo.Characters or {}) do
    for sourceName in pairs(info.Requirements and info.Requirements.Character or {}) do
        evolutionTargets[sourceName] = targetName
    end
end

local function buildMachineOptions()
    local cloneValues = {}
    local evolveValues = {}
    local cloneSelected = {}
    local evolveSelected = {}
    table.clear(State.CloneLabels)
    table.clear(State.EvolveLabels)

    for _, unit in ipairs(getAllUnits()) do
        local uuid = tostring(unit.UUID or unit.CharacterId or "")
        local mutation = unit.Mutation and unit.Mutation ~= "" and (" | " .. unit.Mutation) or ""
        local label = tostring(unit.Name or "Unknown") .. mutation .. " | Lv." .. tostring(unit.Level or 1) .. " | " .. string.sub(uuid, 1, 8)
        local info = charLookup[unit.Name]

        if info and info.Rarity ~= "Limited" and info.CanClone ~= false and tostring(unit.Mutation or "") ~= "Astronaut" then
            State.CloneLabels[label] = uuid
            table.insert(cloneValues, label)
            if State.SelectedCloneUnits[uuid] then
                cloneSelected[label] = true
            end
        end

        if evolutionTargets[tostring(unit.Name or "")] then
            State.EvolveLabels[label] = uuid
            table.insert(evolveValues, label)
            if State.SelectedEvolveUnits[uuid] then
                evolveSelected[label] = true
            end
        end
    end

    table.sort(cloneValues)
    table.sort(evolveValues)
    return cloneValues, cloneSelected, evolveValues, evolveSelected
end

local function firstActive(rows)
    for _, row in pairs(rows or {}) do
        if type(row) == "table" and tostring(row.UUID or row.CharacterId or "") ~= "" then
            return row
        end
    end
end

connect(CloneRemote and CloneRemote.OnClientEvent, function(action, data)
    if action == "Claimed" then
        sendWebhook("Clone Completed", "Claimed clone of **" .. tostring(data and data.Name or "unit") .. "**.", 10181046)
    end
end)

connect(EvolveRemote and EvolveRemote.OnClientEvent, function(action, data)
    if action == "Claimed" or action == "Claim" then
        sendWebhook("Evolution Completed", "Claimed evolution of **" .. tostring(data and data.Name or "unit") .. "**.", 10181046)
        State.LastEvolveClaim = nil
    end
end)

task.spawn(function()
    while State.Alive do
        if not State.AutoClone and not State.AutoEvolve then
            task.wait(10)
            continue
        end

        if State.AutoClone and os.clock() - State.LastCloneAction >= 3 then
            local active = firstActive(AnimeState.GetCloning())
            if active then
                local uuid = tostring(active.UUID or active.CharacterId or "")
                if AnimeState.GetCloneLeft(active) <= 0 then
                    State.LastCloneAction = os.clock()
                    CloneRemote:FireServer("Claim", { UUID = uuid, CharacterId = uuid })
                end
            else
                for _, unit in ipairs(getAllUnits()) do
                    local uuid = tostring(unit.UUID or unit.CharacterId or "")
                    if State.SelectedCloneUnits[uuid] then
                        State.LastCloneAction = os.clock()
                        CloneRemote:FireServer("Start", { UUID = uuid, CharacterId = uuid })
                        break
                    end
                end
            end
        end

        if State.AutoEvolve and os.clock() - State.LastEvolveAction >= 3 then
            local active = firstActive(AnimeState.GetEvolution())
            if active then
                local uuid = tostring(active.UUID or active.CharacterId or "")
                local okLeft, left = pcall(AnimeState.GetTimerLeft, active)
                if okLeft and (tonumber(left) or math.huge) <= 0 then
                    State.LastEvolveAction = os.clock()
                    State.LastEvolveClaim = tostring(active.EvolutionName or active.Name or "unit")
                    EvolveRemote:FireServer({ UUID = uuid, Action = "Claim" })
                end
            else
                if State.LastEvolveClaim then
                    sendWebhook("Evolution Completed", "Claimed evolution **" .. State.LastEvolveClaim .. "**.", 10181046)
                    State.LastEvolveClaim = nil
                end
                for _, unit in ipairs(getAllUnits()) do
                    local uuid = tostring(unit.UUID or unit.CharacterId or "")
                    if State.SelectedEvolveUnits[uuid] and evolutionTargets[tostring(unit.Name or "")] then
                        State.LastEvolveAction = os.clock()
                        EvolveRemote:FireServer({ UUID = uuid, Action = "Start" })
                        break
                    end
                end
            end
        end
        task.wait(1)
    end
end)

local fightWasRunning = LocalPlayer:GetAttribute("FightRunning") == true
local fightStartGold = tonumber(DataClient:get({ "Gold" })) or 0
local lastAliveEnemies = 0
local lastAliveUnits = 0
local function countAlive(folder)
    local count = 0
    if folder then
        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model") and not model:GetAttribute("RollPreview") then
                local humanoid = model:FindFirstChildOfClass("Humanoid")
                local health = tonumber(model:GetAttribute("Health")) or (humanoid and humanoid.Health) or 1
                if health > 0 then
                    count += 1
                end
            end
        end
    end
    return count
end

task.spawn(function()
    while State.Alive do
        if not State.WebhookEnabled or IS_RAID or IS_DUNGEON then
            task.wait(5)
            continue
        end
        local running = LocalPlayer:GetAttribute("FightRunning") == true
        local plot = getLocalPlot()
        if running then
            if not fightWasRunning then
                fightStartGold = tonumber(DataClient:get({ "Gold" })) or 0
            end
            lastAliveEnemies = countAlive(plot and plot:FindFirstChild("Enemies"))
            lastAliveUnits = countAlive(plot and plot:FindFirstChild("Characters"))
        elseif fightWasRunning then
            local result = lastAliveEnemies <= 0 and "Victory" or (lastAliveUnits <= 0 and "Defeat" or "Fight Ended")
            local color = result == "Victory" and 5763719 or (result == "Defeat" and 15548997 or 16776960)
            local goldEarned = (tonumber(DataClient:get({ "Gold" })) or 0) - fightStartGold
            sendWebhook(result, string.format("Wave: `%s`\nGold change: `%s`", tostring(LocalPlayer:GetAttribute("FightWave") or 1), tostring(goldEarned)), color)
        end
        fightWasRunning = running
        task.wait(running and 0.5 or 2)
    end
end)

State.LastRunEndAt = nil
State.LastRunResult = nil
if (IS_RAID or IS_DUNGEON) and not State.RunPlaceJoinedAt then
    State.RunPlaceJoinedAt = os.clock()
end

local function countRaidEnemies()
    local folder = workspace:FindFirstChild("RaidEnemies")
    if not folder then
        return nil
    end
    local count = 0
    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") and not model:GetAttribute("RollPreview") then
            local humanoid = model:FindFirstChildOfClass("Humanoid")
            local health = tonumber(model:GetAttribute("Health")) or (humanoid and humanoid.Health) or 1
            if health > 0 then
                count += 1
            end
        end
    end
    return count
end

task.spawn(function()
    local wasRunning = LocalPlayer:GetAttribute("FightRunning") == true
    local startGold = tonumber(DataClient:get({ "Gold" })) or 0
    local lastEnemies = nil
    while State.Alive do
        if not IS_RAID and not IS_DUNGEON then
            task.wait(10)
            continue
        end
        local running = LocalPlayer:GetAttribute("FightRunning") == true
        if running then
            State.SawRunFight = true
            if not wasRunning then
                startGold = tonumber(DataClient:get({ "Gold" })) or 0
            end
            local n = countRaidEnemies()
            if n ~= nil then
                lastEnemies = n
            end
        elseif wasRunning then
            local victory = lastEnemies ~= nil and lastEnemies <= 0
            local result = victory and "Run Victory" or (lastEnemies == nil and "Run Ended" or "Run Defeat")
            State.LastRunResult = result
            State.LastRunEndAt = os.clock()
            local goldEarned = (tonumber(DataClient:get({ "Gold" })) or 0) - startGold
            sendWebhook(result, string.format("Wave: `%s`\nEnemies left: `%s`\nGold change: `%s`", tostring(LocalPlayer:GetAttribute("FightWave") or 1), tostring(lastEnemies), tostring(goldEarned)), victory and 5763719 or 15548997)
            lastEnemies = nil
        end
        wasRunning = running
        task.wait(running and 1 or 2)
    end
end)

task.spawn(function()
    while State.Alive do
        if (IS_RAID or IS_DUNGEON) and State.AutoRunReturn and State.LastRunEndAt and LocalPlayer:GetAttribute("FightRunning") ~= true then
            State.LastRunEndAt = nil
            pcall(function()
                TeleportService:Teleport(LOBBY_PLACE_ID, LocalPlayer)
            end)
        end
        if IS_RAID and State.AutoRunReturn and State.LastRunEndAt == nil and LocalPlayer:GetAttribute("FightRunning") ~= true and workspace:GetAttribute("RaidEndsAt") == nil and State.RunPlaceJoinedAt and os.clock() - State.RunPlaceJoinedAt >= 60 then
            State.RunPlaceJoinedAt = os.clock()
            pcall(function()
                TeleportService:Teleport(LOBBY_PLACE_ID, LocalPlayer)
            end)
        end
        if IS_RAID and State.AutoRunReturn and State.LastRunEndAt == nil and not State.SawRunFight and LocalPlayer:GetAttribute("FightRunning") ~= true and State.RunPlaceJoinedAt and os.clock() - State.RunPlaceJoinedAt >= 180 then
            State.RunPlaceJoinedAt = os.clock()
            pcall(function()
                TeleportService:Teleport(LOBBY_PLACE_ID, LocalPlayer)
            end)
        end
        task.wait(5)
    end
end)
task.spawn(function()
    while State.Alive do
        if IS_RAID and State.AutoRaid and not State.LastRunEndAt and LocalPlayer:GetAttribute("FightRunning") ~= true then
            pcall(function()
                RaidRequest:FireServer("Ready")
            end)
            task.wait(1)
            if State.Alive and LocalPlayer:GetAttribute("FightRunning") ~= true then
                pcall(function()
                    RaidRequest:FireServer("Open")
                end)
            end
        end
        task.wait(5)
    end
end)

local function playerMatchesMode(player)
    if State.HideMode == "All Players" then
        return true
    end
    if State.HideMode == "Other Players" then
        return player ~= LocalPlayer
    end
    return player == LocalPlayer
end

local function isNameBillboard(instance, player)
    if not instance:IsA("BillboardGui") then
        return false
    end

    local lowered = string.lower(instance.Name)
    if string.find(lowered, "name", 1, true) or string.find(lowered, "tag", 1, true) or string.find(lowered, "overhead", 1, true) then
        return true
    end

    for _, descendant in ipairs(instance:GetDescendants()) do
        if descendant:IsA("TextLabel") then
            local text = tostring(descendant.Text)
            if string.find(text, player.Name, 1, true) or string.find(text, player.DisplayName, 1, true) then
                return true
            end
        end
    end
    return false
end

local function hideCharacterName(player, character)
    if not State.HideNames or not playerMatchesMode(player) then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and not State.HiddenHumanoids[humanoid] then
        State.HiddenHumanoids[humanoid] = {
            DisplayDistanceType = humanoid.DisplayDistanceType,
            NameDisplayDistance = humanoid.NameDisplayDistance,
        }
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        humanoid.NameDisplayDistance = 0
    end

    for _, descendant in ipairs(character:GetDescendants()) do
        if isNameBillboard(descendant, player) and State.HiddenBillboards[descendant] == nil then
            State.HiddenBillboards[descendant] = descendant.Enabled
            descendant.Enabled = false
        end
    end
end

local function restoreNames()
    for humanoid, original in pairs(State.HiddenHumanoids) do
        if humanoid.Parent then
            humanoid.DisplayDistanceType = original.DisplayDistanceType
            humanoid.NameDisplayDistance = original.NameDisplayDistance
        end
    end
    for billboard, enabled in pairs(State.HiddenBillboards) do
        if billboard.Parent then
            billboard.Enabled = enabled
        end
    end
    table.clear(State.HiddenHumanoids)
    table.clear(State.HiddenBillboards)
end

local function applyHideNames()
    restoreNames()
    if not State.HideNames then
        return
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            hideCharacterName(player, player.Character)
        end
    end
end

local function watchPlayer(player)
    connect(player.CharacterAdded, function(character)
        task.wait(0.5)
        if State.Alive then
            hideCharacterName(player, character)
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    watchPlayer(player)
end
connect(Players.PlayerAdded, watchPlayer)

local vfxClasses = {
    ParticleEmitter = true,
    Beam = true,
    Trail = true,
    Smoke = true,
    Fire = true,
    Sparkles = true,
    Explosion = true,
    PointLight = true,
    SpotLight = true,
    SurfaceLight = true,
    Highlight = true,
}

local function isVFXModel(instance)
    if not instance:IsA("Model") then
        return false
    end
    local debris = workspace:FindFirstChild("Debris")
    if debris and instance:IsDescendantOf(debris) then
        return true
    end
    local name = string.lower(instance.Name)
    return string.find(name, "vfx", 1, true) ~= nil
        or string.find(name, "effect", 1, true) ~= nil
        or string.find(name, "projectile", 1, true) ~= nil
        or name == "impact"
        or name == "aura"
end

local processedVisuals = setmetatable({}, { __mode = "k" })
local function hideVisualModel(model)
    if not model or not model.Parent or processedVisuals[model] then
        return
    end
    processedVisuals[model] = true
    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            State.HiddenVisuals[descendant] = State.HiddenVisuals[descendant] or { "LocalTransparencyModifier", descendant.LocalTransparencyModifier }
            descendant.LocalTransparencyModifier = 1
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            State.HiddenVisuals[descendant] = State.HiddenVisuals[descendant] or { "Transparency", descendant.Transparency }
            descendant.Transparency = 1
        elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
            State.HiddenVisuals[descendant] = State.HiddenVisuals[descendant] or { "Enabled", descendant.Enabled }
            descendant.Enabled = false
        end
    end
end

local function restoreVisuals()
    for instance, original in pairs(State.HiddenVisuals) do
        if instance.Parent then
            pcall(function()
                instance[original[1]] = original[2]
            end)
        end
    end
    table.clear(State.HiddenVisuals)
    table.clear(processedVisuals)
end

local function removeVFX(instance)
    if not State.FixLag or not instance.Parent then
        return
    end

    if instance:IsA("Model") and (instance:GetAttribute("RollPreview") == true or instance:GetAttribute("ClientFightBody") == true) then
        hideVisualModel(instance)
        return
    end

    if vfxClasses[instance.ClassName] or instance:IsA("PostEffect") or isVFXModel(instance) then
        instance:Destroy()
    end
end

local function clearAllVFX()
    local debris = workspace:FindFirstChild("Debris")
    if debris then
        debris:ClearAllChildren()
    end
    local flexModels = workspace:FindFirstChild("FlexDisplayModels")
    if flexModels then
        flexModels:ClearAllChildren()
    end
    local fightModels = workspace:FindFirstChild("ClientFightCharacters")
    if fightModels then
        for _, model in ipairs(fightModels:GetChildren()) do
            if model:IsA("Model") then
                hideVisualModel(model)
            end
        end
    end

    for _, instance in ipairs(workspace:GetDescendants()) do
        removeVFX(instance)
    end
    for _, instance in ipairs(Lighting:GetDescendants()) do
        if instance:IsA("PostEffect") then
            instance:Destroy()
        end
    end
end

local function stopVFXWatchers()
    for _, connection in ipairs(State.VFXConnections) do
        connection:Disconnect()
    end
    table.clear(State.VFXConnections)
end

local function startVFXWatchers()
    if #State.VFXConnections > 0 then
        return
    end
    local workspaceConnection = workspace.DescendantAdded:Connect(function(instance)
        if vfxClasses[instance.ClassName] or instance:IsA("PostEffect") or instance:IsA("Model") then
            task.defer(function()
                if State.Alive and State.FixLag then
                    removeVFX(instance)
                end
            end)
        end
    end)
    local lightingConnection = Lighting.DescendantAdded:Connect(function(instance)
        if instance:IsA("PostEffect") then
            task.defer(function()
                if State.Alive and State.FixLag and instance.Parent then
                    instance:Destroy()
                end
            end)
        end
    end)
    table.insert(State.VFXConnections, workspaceConnection)
    table.insert(State.VFXConnections, lightingConnection)
    table.insert(State.Connections, workspaceConnection)
    table.insert(State.Connections, lightingConnection)
end

local function purgeClientMemory()
    if State.MemoryPurged then
        return
    end
    State.MemoryPurged = true

    local fightModels = workspace:FindFirstChild("ClientFightCharacters")
    if fightModels then
        fightModels:ClearAllChildren()
    end

    pcall(function()
        collectgarbage("collect")
    end)
end

local function enableFPSBoostCleanup()
    task.spawn(function()
        local deadline = os.clock() + 20
        if type(getconnections) == "function" then
            while State.Alive and FightRemote and #getconnections(FightRemote.OnClientEvent) == 0 and os.clock() < deadline do
                task.wait(0.25)
            end
        else
            task.wait(8)
        end
        if not State.Alive or not State.FixLag then return end
        startVFXWatchers()
        clearAllVFX()
        purgeClientMemory()
    end)
end

local function setFPSBoost(enabled)
    State.FixLag = enabled
    LocalPlayer:SetAttribute("FPSBoost", enabled)
    Lighting.GlobalShadows = not enabled and State.OriginalGlobalShadows or false
    pcall(function()
        settings().Rendering.QualityLevel = enabled and Enum.QualityLevel.Level01 or State.OriginalQuality
    end)
    if enabled then
        enableFPSBoostCleanup()
    else
        stopVFXWatchers()
        restoreVisuals()
    end
    scheduleConfigSave()
end

if State.FixLag then
    enableFPSBoostCleanup()
end

function State.Cleanup()
    if not State.Alive then
        return
    end
    saveConfigNow()
    applyBypass(false)
    applyRemoveOtherBases(false)
    State.Alive = false
    PurchaseSignal:Fire()
    stopVFXWatchers()
    restoreVisuals()
    for _, connection in ipairs(State.Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    restoreNames()
    Lighting.GlobalShadows = State.OriginalGlobalShadows
    LocalPlayer:SetAttribute("FPSBoost", State.OriginalFPSBoost)
    pcall(function()
        settings().Rendering.QualityLevel = State.OriginalQuality
    end)
    if State.MobileGui then
        pcall(function() State.MobileGui:Destroy() end)
        State.MobileGui = nil
    end
    if State.Fluent then
        pcall(function()
            State.Fluent:Destroy()
        end)
    end
    PurchaseSignal:Destroy()
end

local FluentSrc = env.__ARF_FLUENT_SRC
if not FluentSrc then
    FluentSrc = game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua")
    env.__ARF_FLUENT_SRC = FluentSrc
end
local Fluent = loadstring(FluentSrc)()
State.Fluent = Fluent
State.LoadTime = os.clock()
State.HubVersion = "2026.09.23-teleport-fix"
print("[ARF Hub] loaded " .. State.HubVersion .. " at place " .. tostring(game.PlaceId))

local Window = Fluent:CreateWindow({
    Title = "Anime Rolls Hub",
    SubTitle = "made by Truyem789",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl,
})

local function safeParentScreenGui(gui)
    if type(gethui) == "function" then
        local ok, parent = pcall(gethui)
        if ok and parent and pcall(function() gui.Parent = parent end) then return true end
    end
    if pcall(function() gui.Parent = CoreGui end) then return true end
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    return playerGui ~= nil and pcall(function() gui.Parent = playerGui end)
end

do
    local MobileGui = Instance.new("ScreenGui")
    MobileGui.Name = "ARFMobileToggle"
    MobileGui.ResetOnSpawn = false
    MobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MobileGui.DisplayOrder = 100
    local ToggleBtn = Instance.new("ImageButton", MobileGui)
    ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    ToggleBtn.AnchorPoint = Vector2.new(1, 0.5)
    ToggleBtn.Position = UDim2.new(1, -14, 0.30, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtn.Image = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=150&h=150"
    local corner = Instance.new("UICorner", ToggleBtn)
    corner.CornerRadius = UDim.new(0, 8)
    ToggleBtn.MouseButton1Click:Connect(function()
        pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game) end)
        task.wait(0.1)
        pcall(function() game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.RightControl, false, game) end)
    end)
    if safeParentScreenGui(MobileGui) then
        MobileGui.Enabled = State.MobileToggle
        State.MobileGui = MobileGui
    else
        MobileGui:Destroy()
    end
end

local Tabs = {
    Farm = Window:AddTab({ Title = "Farm", Icon = "play" }),
    Extras = Window:AddTab({ Title = "Extras", Icon = "package" }),
    Machines = Window:AddTab({ Title = "Machines", Icon = "cpu" }),
    PortalRaid = Window:AddTab({ Title = "Portal & Raid", Icon = "swords" }),
    Webhook = Window:AddTab({ Title = "Webhook", Icon = "send" }),
    Performance = Window:AddTab({ Title = "Performance", Icon = "gauge" }),
    Privacy = Window:AddTab({ Title = "Privacy", Icon = "eye-off" }),
    Info = Window:AddTab({ Title = "Info", Icon = "info" }),
}

Tabs.Farm:AddToggle("AutoBuy", {
    Title = "Auto Buy",
    Description = "Automatically rolls and buys selected units or rarities",
    Default = State.AutoBuy,
}):OnChanged(function(value)
    State.AutoBuy = value
    if value then
        State.RollPending = false
        State.NextRollAt = 0
        PurchaseSignal:Fire()
    else
        table.clear(State.PendingBuys)
        table.clear(State.PurchaseResults)
        table.clear(State.ConfirmedPurchases)
        State.PurchaseBusy = false
        PurchaseSignal:Fire()
    end
    scheduleConfigSave()
end)

Tabs.Farm:AddToggle("BuyAll", {
    Title = "Buy All Units",
    Description = "Ignores unit and rarity filters",
    Default = State.BuyAll,
}):OnChanged(function(value)
    State.BuyAll = value
    scheduleConfigSave()
end)

Tabs.Farm:AddDropdown("BuyUnits", {
    Title = "Unit Buy List",
    Description = "Select every unit that Auto Buy may purchase",
    Values = unitNames,
    Multi = true,
    Default = State.SelectedUnits,
}):OnChanged(function(value)
    replaceSelection(State.SelectedUnits, value)
    scheduleConfigSave()
end)

Tabs.Farm:AddDropdown("BuyRarities", {
    Title = "Rarity Buy List",
    Values = rarityNames,
    Multi = true,
    Default = State.SelectedRarities,
}):OnChanged(function(value)
    replaceSelection(State.SelectedRarities, value)
    scheduleConfigSave()
end)

local function getMutationDefault()
    if next(State.SelectedMutations) == nil then
        local all = {}
        for _, m in ipairs(mutationNames) do all[m] = true end
        return all
    end
    return State.SelectedMutations
end
Tabs.Farm:AddDropdown("BuyMutations", {
    Title = "Mutation Buy List",
    Description = "All selected by default; uncheck to filter. Empty = all",
    Values = mutationNames,
    Multi = true,
    Default = getMutationDefault(),
}):OnChanged(function(value)
    replaceSelection(State.SelectedMutations, value)
    scheduleConfigSave()
end)

Tabs.Farm:AddInput("KeepGold", {
    Title = "Keep Gold",
    Description = "Never buys if the remaining Gold would be lower than this",
    Default = tostring(State.KeepGold),
    Numeric = true,
    Finished = true,
}):OnChanged(function(value)
    State.KeepGold = tonumber(value) or 0
    scheduleConfigSave()
end)

Tabs.Farm:AddToggle("NativeAutoPlay", {
    Title = "Auto Play",
    Description = "Uses the game's native Auto Play system",
    Default = State.NativeAutoPlay,
}):OnChanged(setNativeAutoPlay)

Tabs.Farm:AddDropdown("GameSpeed", {
    Title = "Fight Speed",
    Description = "Uses the game's native x1/x2/x3 speed button",
    Values = { "x1", "x2", "x3" },
    Multi = false,
    Default = State.GameSpeed,
}):OnChanged(function(value)
    State.GameSpeed = tostring(value or "x1")
    task.defer(applyGameSpeed)
    scheduleConfigSave()
end)

Tabs.Farm:AddInput("StartAtWave", {
    Title = "Start At Wave (0 = disabled)",
    Default = tostring(State.StartAtWave),
    Numeric = true,
    Finished = true,
}):OnChanged(function(value)
    State.StartAtWave = tonumber(value) or 0
    scheduleConfigSave()
end)

Tabs.Farm:AddInput("StopAtWave", {
    Title = "Stop At Wave (0 = disabled)",
    Default = tostring(State.StopAtWave),
    Numeric = true,
    Finished = true,
}):OnChanged(function(value)
    State.StopAtWave = tonumber(value) or 0
    scheduleConfigSave()
end)

Tabs.Farm:AddButton({
    Title = "Start Fight Now",
    Callback = function()
        if FightRemote then
            FightRemote:FireServer("Start")
        end
    end,
})

Tabs.Extras:AddToggle("AutoMerchant", {
    Title = "Auto Buy Merchant",
    Description = "Buys selected in-stock items only when Gold is sufficient",
    Default = State.AutoMerchant,
}):OnChanged(function(value)
    State.AutoMerchant = value
    scheduleConfigSave()
end)

Tabs.Extras:AddToggle("MerchantBuyAll", {
    Title = "Buy All Merchant Items",
    Description = "Ignores the Merchant item list",
    Default = State.MerchantBuyAll,
}):OnChanged(function(value)
    State.MerchantBuyAll = value
    scheduleConfigSave()
end)

local initialMerchantValues = {}
for name, item in pairs(ItemsInfo.Items or {}) do
    if type(item) == "table" and tonumber(item.MerchantPrice) then
        name = tostring(name)
        State.MerchantLabels[name] = name
        table.insert(initialMerchantValues, name)
    end
end
table.sort(initialMerchantValues)
Tabs.Extras:AddDropdown("MerchantItems", {
    Title = "Merchant Item List",
    Description = "Full catalog; purchases selected items only when they are in stock",
    Values = initialMerchantValues,
    Multi = true,
    Default = State.SelectedMerchantItems,
}):OnChanged(function(value)
    replaceSelection(State.SelectedMerchantItems, value)
    scheduleConfigSave()
end)

Tabs.Extras:AddToggle("AutoTower", {
    Title = "Auto Infinite Tower",
    Description = IS_TOWER and "Starts the Tower run when ready" or "Joins Tower when an Infinite Ticket is available",
    Default = State.AutoTower,
}):OnChanged(function(value)
    State.AutoTower = value
    saveConfigNow()
end)

Tabs.Extras:AddButton({
    Title = "Leave Infinite Tower",
    Description = "Returns to the main game from the Tower server",
    Callback = function()
        saveConfigNow()
        if JoinTowerRemote then
            JoinTowerRemote:FireServer("Leave")
        end
    end,
})

Tabs.Extras:AddToggle("AutoSpin", {
    Title = "Auto Spin Wheel",
    Description = "Spins automatically when free spin or ticket is available",
    Default = State.AutoSpin,
}):OnChanged(function(value)
    State.AutoSpin = value
    scheduleConfigSave()
end)

Tabs.Extras:AddToggle("AutoEquipBest", {
    Title = "Auto Equip Best Units",
    Description = "Calls Characters.UpdateInventory with EquipBest",
    Default = State.AutoEquipBest,
}):OnChanged(function(value)
    State.AutoEquipBest = value
    if value then
        State.LastEquipAt = 0
        task.defer(activateEquipBest)
    end
    scheduleConfigSave()
end)

Tabs.Extras:AddButton({
    Title = "Equip Best Now",
    Description = "Equips the strongest team once",
    Callback = activateEquipBest,
})

Tabs.Extras:AddToggle("AutoUpgrade", {
    Title = "Auto Upgrade",
    Description = "Calls Remotes.Upgrade with Gold and the selected upgrade types",
    Default = State.AutoUpgrade,
}):OnChanged(function(value)
    State.AutoUpgrade = value
    scheduleConfigSave()
end)

Tabs.Extras:AddDropdown("UpgradeTypes", {
    Title = "Upgrade Type List",
    Description = "Leave empty to upgrade all available types",
    Values = upgradeTypes,
    Multi = true,
    Default = State.SelectedUpgradeTypes,
}):OnChanged(function(value)
    replaceSelection(State.SelectedUpgradeTypes, value)
    scheduleConfigSave()
end)

Tabs.Extras:AddToggle("AutoClaimPass", {
    Title = "Auto Claim Pass",
    Description = "Claims unlocked Free and owned Premium tier rewards every 30s",
    Default = State.AutoClaimPass,
}):OnChanged(function(value)
    State.AutoClaimPass = value
    scheduleConfigSave()
end)

Tabs.Extras:AddButton({
    Title = "Claim Pass Now",
    Callback = function()
        task.spawn(function()
            pcall(claimBattlepassRewards)
        end)
    end,
})

Tabs.Extras:AddToggle("AutoClaimQuest", {
    Title = "Auto Claim Quest",
    Description = "Calls BattlepassQuest.ClaimQuest for completed quests",
    Default = State.AutoClaimQuest,
}):OnChanged(function(value)
    State.AutoClaimQuest = value
    scheduleConfigSave()
end)

Tabs.Extras:AddButton({
    Title = "Claim Quests Now",
    Callback = function()
        task.spawn(claimBattlepassQuests)
    end,
})

Tabs.Extras:AddToggle("AntiAFK", {
    Title = "Anti AFK",
    Default = State.AntiAFK,
}):OnChanged(function(value)
    State.AntiAFK = value
    scheduleConfigSave()
end)

Tabs.Extras:AddToggle("AutoReconnect", {
    Title = "Auto Reconnect",
    Default = State.AutoReconnect,
}):OnChanged(function(value)
    State.AutoReconnect = value
    scheduleConfigSave()
end)

local initialCloneValues, initialCloneSelection, initialEvolveValues, initialEvolveSelection = buildMachineOptions()
Tabs.Machines:AddToggle("AutoClone", {
    Title = "Auto Clone & Claim",
    Description = "Starts selected unit when possible and claims completed clones",
    Default = State.AutoClone,
}):OnChanged(function(value)
    State.AutoClone = value
    scheduleConfigSave()
end)

Tabs.Machines:AddDropdown("CloneUnits", {
    Title = "Clone Unit List",
    Values = initialCloneValues,
    Multi = true,
    Default = initialCloneSelection,
}):OnChanged(function(value)
    table.clear(State.SelectedCloneUnits)
    for label, selected in pairs(value or {}) do
        if selected == true and State.CloneLabels[label] then
            State.SelectedCloneUnits[State.CloneLabels[label]] = true
        end
    end
    scheduleConfigSave()
end)

Tabs.Machines:AddToggle("AutoEvolve", {
    Title = "Auto Evolution & Claim",
    Description = "Starts selected eligible unit and claims completed evolution",
    Default = State.AutoEvolve,
}):OnChanged(function(value)
    State.AutoEvolve = value
    scheduleConfigSave()
end)

Tabs.Machines:AddDropdown("EvolveUnits", {
    Title = "Evolution Unit List",
    Values = initialEvolveValues,
    Multi = true,
    Default = initialEvolveSelection,
}):OnChanged(function(value)
    table.clear(State.SelectedEvolveUnits)
    for label, selected in pairs(value or {}) do
        if selected == true and State.EvolveLabels[label] then
            State.SelectedEvolveUnits[State.EvolveLabels[label]] = true
        end
    end
    scheduleConfigSave()
end)

Tabs.PortalRaid:AddToggle("AutoPortal", {
    Title = "Auto Portal (Solo)",
    Description = "Self-creates a portal when you own a matching portal item, then starts it solo",
    Default = State.AutoPortal,
}):OnChanged(function(value)
    State.AutoPortal = value
    State.LastPortalAction = 0
    if value then
        task.defer(function()
            pcall(function() PortalRequest:FireServer("Refresh") end)
        end)
    end
    scheduleConfigSave()
end)

Tabs.PortalRaid:AddToggle("PortalAutoStart", {
    Title = "Auto Start Portal",
    Description = "Starts the portal when member count reaches the minimum",
    Default = State.PortalAutoStart,
}):OnChanged(function(value)
    State.PortalAutoStart = value
    scheduleConfigSave()
end)

Tabs.PortalRaid:AddInput("PortalMinMembers", {
    Title = "Portal Min Members (1 = solo)",
    Default = tostring(State.PortalMinMembers),
    Numeric = true,
    Finished = true,
}):OnChanged(function(value)
    State.PortalMinMembers = math.clamp(math.floor(tonumber(value) or 1), 1, 4)
    scheduleConfigSave()
end)

Tabs.PortalRaid:AddDropdown("PortalDifficulties", {
    Title = "Portal Difficulty Filter",
    Description = "Empty = all difficulties",
    Values = portalDifficultyNames,
    Multi = true,
    Default = State.SelectedPortalDifficulties,
}):OnChanged(function(value)
    replaceSelection(State.SelectedPortalDifficulties, value)
    scheduleConfigSave()
end)

Tabs.PortalRaid:AddDropdown("PortalNames", {
    Title = "Portal Name Filter",
    Description = "Empty = all portals",
    Values = portalNames,
    Multi = true,
    Default = State.SelectedPortalNames,
}):OnChanged(function(value)
    replaceSelection(State.SelectedPortalNames, value)
    scheduleConfigSave()
end)

State.PortalStatusPara = Tabs.PortalRaid:AddParagraph({
    Title = "Owned Portal Items",
    Content = "Scanning...",
})

Tabs.PortalRaid:AddButton({
    Title = "Scan Portal Items Now",
    Description = "Shows owned portal items (only owned portals are used)",
    Callback = function()
        pcall(refreshStatusParas)
        local owned = safeOwnedPortalItems()
        local lines = {}
        if #owned == 0 then
            table.insert(lines, "No portal item — farm bosses for portals.")
        else
            for _, entry in ipairs(owned) do
                table.insert(lines, string.format("%s (%s) x%d", entry.Portal, entry.Difficulty, entry.Count))
            end
        end
        pcall(function()
            Fluent:Notify({ Title = "Portal Scan", Content = table.concat(lines, "\n"), Duration = 5 })
        end)
    end,
})

Tabs.PortalRaid:AddToggle("AutoRaid", {
    Title = "Auto Raid (Solo)",
    Description = "Self-creates a raid party and starts it solo while a window is open. Never joins others",
    Default = State.AutoRaid,
}):OnChanged(function(value)
    State.AutoRaid = value
    State.LastRaidAction = 0
    if value then
        task.defer(function()
            pcall(function() RaidRequest:FireServer("Refresh") end)
        end)
    end
    scheduleConfigSave()
end)

Tabs.PortalRaid:AddToggle("RaidAutoStart", {
    Title = "Auto Start Raid",
    Description = "Starts the raid when member count reaches the minimum",
    Default = State.RaidAutoStart,
}):OnChanged(function(value)
    State.RaidAutoStart = value
    scheduleConfigSave()
end)

Tabs.PortalRaid:AddInput("RaidMinMembers", {
    Title = "Raid Min Members (1 = solo)",
    Default = tostring(State.RaidMinMembers),
    Numeric = true,
    Finished = true,
}):OnChanged(function(value)
    State.RaidMinMembers = math.clamp(math.floor(tonumber(value) or 1), 1, 4)
    scheduleConfigSave()
end)

Tabs.PortalRaid:AddDropdown("RaidDifficulties", {
    Title = "Raid Difficulty Filter",
    Description = "Game has no picker (server rotates); empty = run every window",
    Values = raidDifficultyNames,
    Multi = true,
    Default = State.SelectedRaidDifficulties,
}):OnChanged(function(value)
    replaceSelection(State.SelectedRaidDifficulties, value)
    scheduleConfigSave()
end)

Tabs.PortalRaid:AddDropdown("RaidMaps", {
    Title = "Raid Map Filter",
    Description = "Only auto-runs windows on selected maps; empty = all maps",
    Values = raidMapNames,
    Multi = true,
    Default = State.SelectedRaidMaps,
}):OnChanged(function(value)
    replaceSelection(State.SelectedRaidMaps, value)
    scheduleConfigSave()
end)

Tabs.PortalRaid:AddToggle("AutoRunReturn", {
    Title = "Auto Return To Lobby After Run",
    Description = "Right after a raid/dungeon run ends, teleports back to lobby",
    Default = State.AutoRunReturn,
}):OnChanged(function(value)
    State.AutoRunReturn = value
    scheduleConfigSave()
end)

State.RaidStatusPara = Tabs.PortalRaid:AddParagraph({
    Title = "Raid Window Status",
    Content = "Checking...",
})

task.defer(function()
    pcall(refreshStatusParas)
end)

Tabs.Webhook:AddToggle("WebhookEnabled", {
    Title = "Enable Webhook",
    Description = "Win/loss, unit purchases, clone and evolution completion",
    Default = State.WebhookEnabled,
}):OnChanged(function(value)
    State.WebhookEnabled = value
    scheduleConfigSave()
end)

Tabs.Webhook:AddInput("WebhookURL", {
    Title = "Discord Webhook URL",
    Default = State.WebhookURL,
    Placeholder = "https://discord.com/api/webhooks/...",
    Numeric = false,
    Finished = true,
}):OnChanged(function(value)
    State.WebhookURL = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
    scheduleConfigSave()
end)

Tabs.Webhook:AddButton({
    Title = "Test Webhook",
    Callback = function()
        local options = State.Fluent and State.Fluent.Options
        local liveURL = options and options.WebhookURL and options.WebhookURL.Value
        if liveURL ~= nil then
            State.WebhookURL = tostring(liveURL):gsub("^%s+", ""):gsub("%s+$", "")
        end
        if State.WebhookURL == "" then
            Fluent:Notify({ Title = "Webhook", Content = "Enter a Discord webhook URL first.", Duration = 5 })
            return
        end
        if type(httpRequest) ~= "function" then
            Fluent:Notify({ Title = "Webhook", Content = "This executor does not provide HTTP requests.", Duration = 5 })
            return
        end
        saveConfigNow()
        sendWebhook("Webhook Test", "Anime Rolls Hub is connected.", 5793266)
        Fluent:Notify({ Title = "Webhook", Content = "Test request sent.", Duration = 3 })
    end,
})

Tabs.Performance:AddToggle("FPSBoost", {
    Title = "Extreme RAM Saver / FPS Boost",
    Description = "Automation-only mode: removes game UI and preloaded visuals until rejoin",
    Default = State.FixLag,
}):OnChanged(setFPSBoost)

Tabs.Performance:AddToggle("Bypass", {
    Title = "Luck +14 / Mutation x2 / Speed x10",
    Description = "Continuously applies the client attributes from roll_anime.lua",
    Default = State.Bypass,
}):OnChanged(function(value)
    State.Bypass = value
    applyBypass(value)
    scheduleConfigSave()
end)

Tabs.Performance:AddToggle("RemoveOtherBases", {
    Title = "Remove Other Bases",
    Description = "Locally detaches other plots and restores them when disabled",
    Default = State.RemoveOtherBases,
}):OnChanged(function(value)
    State.RemoveOtherBases = value
    applyRemoveOtherBases(value)
    scheduleConfigSave()
end)

Tabs.Performance:AddButton({
    Title = "Clear All VFX Now",
    Description = "Deletes current effects and temporary VFX models once",
    Callback = function()
        local wasEnabled = State.FixLag
        State.FixLag = true
        clearAllVFX()
        State.FixLag = wasEnabled
    end,
})

Tabs.Privacy:AddToggle("HideNames", {
    Title = "Hide Name",
    Default = State.HideNames,
}):OnChanged(function(value)
    State.HideNames = value
    applyHideNames()
    scheduleConfigSave()
end)

Tabs.Privacy:AddDropdown("HideMode", {
    Title = "Hide Name Mode",
    Values = { "My Name", "Other Players", "All Players" },
    Multi = false,
    Default = State.HideMode,
}):OnChanged(function(value)
    State.HideMode = value
    applyHideNames()
    scheduleConfigSave()
end)

Tabs.Info:AddParagraph({
    Title = "Controls",
    Content = "RightCtrl: minimize UI\nRe-execute safe: old connections and local changes are cleaned up.",
})

local executorName = "Unknown"
pcall(function()
    if type(identifyexecutor) == "function" then
        executorName = tostring(identifyexecutor())
    end
end)
Tabs.Info:AddParagraph({
    Title = "Session",
    Content = string.format("Player: %s (@%s)\nExecutor: %s\nJob ID: %s\nHub: %s", LocalPlayer.DisplayName, LocalPlayer.Name, executorName, tostring(game.JobId), tostring(State.HubVersion or "?")),
})

Tabs.Info:AddButton({
    Title = "Copy Join Script",
    Callback = function()
        if type(setclipboard) == "function" then
            setclipboard(string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game:GetService("Players").LocalPlayer)', game.PlaceId, tostring(game.JobId)))
        end
    end,
})

Tabs.Info:AddToggle("MobileToggle", {
    Title = "Mobile Button",
    Description = "Floating game icon (RightCtrl) for mobile",
    Default = State.MobileToggle,
}):OnChanged(function(value)
    State.MobileToggle = value
    if State.MobileGui then State.MobileGui.Enabled = value end
    scheduleConfigSave()
end)

Tabs.Info:AddParagraph({
    Title = "Auto Save Config",
    Content = "Every setting is saved to:\n" .. configFile,
})

Tabs.Info:AddButton({
    Title = "Save Config Now",
    Callback = saveConfigNow,
})

Tabs.Info:AddButton({
    Title = "Unload Hub",
    Callback = function()
        State.Cleanup()
    end,
})

Window:SelectTab(1)
