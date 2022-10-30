local scalform = {}
_Cardealer = {}
_Cardealer.ShowRoomPosition = vector3(-789.903320, -236.043945, 37.521558-0.20)
local active = false

function CreateVehicleStatsScaleformLsCustoms(cars)
    local VehicleModel = GetEntityModel(cars)
    local VehicleSpeed = GetVehicleEstimatedMaxSpeed(cars) * 1.25
    local VehicleAcceleration = GetVehicleAcceleration(cars) * 200
    local VehicleBraking = GetVehicleMaxBraking(cars) * 100
    local VehicleTraction = GetVehicleMaxTraction(cars) * 25
    local VehicleHealth = GetVehicleBodyHealth(cars)
    local scall = RedFW.Client.Functions:CreateScaleform("mp_car_stats_01", {{
       name = "SET_VEHICLE_INFOR_AND_STATS",
       param = {GetLabelText(GetDisplayNameFromVehicleModel(VehicleModel)), "État du véhicule: "..VehicleHealth.."%", "MPCarHUD","Annis", "Vitesse max", "Accélération", "Frein", "Suspension", VehicleSpeed, VehicleAcceleration, VehicleBraking, VehicleTraction}
    }})
    return scall
end

local Props = {}
local Plate

function _Cardealer.ShowVehicle(vehicleName)
    if (_Cardealer.ShowedVehicle == vehicleName) then
        return
    end
    if (_Cardealer.ShowedVehicle ~= nil) then
        DeleteVehicle(_Cardealer.ShowedVehicle)
    end
    local vehicle = RedFW.Client.Functions:spawnVehicle(vehicleName, _Cardealer.ShowRoomPosition, 10.0)
    local test = CreateVehicleStatsScaleformLsCustoms(vehicle)
    _Cardealer.ShowedVehicle = vehicle
    Plate = GetVehicleNumberPlateText(vehicle)
    Props = RedFW.Client.Functions:getVehicleProperties(vehicle)
    local vHeight = GetEntityHeight(vehicle, _Cardealer.ShowRoomPosition.x, _Cardealer.ShowRoomPosition.y, _Cardealer.ShowRoomPosition.z, true, false)
    local PosScalform = {(10*0.8) * .9, (6 * 0.9) * .9, 1 * .9}
    CreateThread(function()
        if (DoesEntityExist(vehicle)) then
            local heading = 0.0
            while (true) do
                if (active == false) then
                    DeleteVehicle(vehicle)
                    _Cardealer.ShowedVehicle = nil
                    if HasScaleformMovieLoaded(test) then
                        SetScaleformMovieAsNoLongerNeeded(test)
                        test = nil
                    end
                    break
                end
                if test and HasScaleformMovieLoaded(test) then
                    DrawScaleformMovie_3dNonAdditive(test, _Cardealer.ShowRoomPosition.x, _Cardealer.ShowRoomPosition.y, _Cardealer.ShowRoomPosition.z + 2.4 + vHeight, GetGameplayCamRot(0), 0.0, 1.0, 0.0, PosScalform[1], PosScalform[2], PosScalform[3])
                end
                Wait(0)
                heading = (heading + 0.2)
                SetEntityHeading(vehicle, heading)
            end
        end
    end)
end

local vehPrice = {
    faggio3 = 770,
    faggio2 = 970,
    faggio = 1220,
    ratbike = 5420,
    blazer = 2620,
    caddy = 2450,
    blazer3 = 3030,
    kalahari = 3280,
    stromberg = 325000,
    mower = 1210,
    panto = 3107,
    blista = 3450,
    blazer4 = 3650,
    emperor2 = 2650,
    Dilettante = 3450,
    asea = 3350,
    emperor = 4050,
    glendale = 4050,
    rhapsody = 4050,
    issi2 = 4450,
    brioso = 4900,
    primo = 7580,
    regina = 3905,
    asterope = 3350,
    ingot = 4350,
    premier = 4350,
    surge = 5250,
    stratum = 5350,
    bagger = 6050,
    prairie = 4350,
    blista2 = 6290,
    fagaloa = 5280,
    manchez = 8480,
    blista3 = 6290,
    dinghy2 = 13280,
    intruder = 5760,
    stanier = 6860,
    washington = 6860,
    daemon = 8760,
    dloader = 5260,
    futo = 10260,
    issi3 = 7260,
    sanchez = 7260,
    tornado4 = 2930,
    warrener = 7260,
    wolfsbane = 7260,
    dinghy = 14580,
    innovation = 7680,
    tractor = 1001,
    hexer = 7910,
    daemon2 = 8140,
    sanchez2 = 8140,
    thrust = 12140,
    zombiea = 13140,
    avarus = 12470,
    zombieb = 13470,
    scrap = 4590,
    bfinjection = 9120,
    esskey = 12120,
    lectro = 12120,
    sovereign = 12120,
    taxi = 12120,
    clique = 13240,
    ruffian = 7240,
    tornado3 = 4585,
    voodoo2 = 5240,
    tiptruck2 = 13620,
    manana = 13710,
    mixer2 = 13710,
    picador = 13710,
    tractor2 = 13710,
    rubble = 13990,
    cheburek = 14260,
    chimera = 14260,
    faction = 14260,
    peyote = 14260,
    squalo = 20958,
    primo2 = 21870,
    tiptruck = 14870,
    mixer = 14980,
    enduro = 15420,
    fcr = 19420,
    pcj = 15420,
    tornado6 = 6420,
    ratloader = 7970,
    chino = 16520,
    cliffhanger = 21520,
    gargoyle = 22520,
    nightblade = 22520,
    tornado = 12520,
    tropic = 20503,
    vader = 11520,
    nemesis = 11080,
    phoenix = 12080,
    virgo = 17080,
    bifta = 6620,
    deathbike = 12620,
    ruiner = 12620,
    vigero = 13620,
    vindicator = 17620,
    voodoo = 13620,
    vortex = 17620,
    faction2 = 18190,
    blade = 18730,
    carbonrs = 18730,
    dukes = 24730,
    fugitive = 12730,
    jetmax = 21812,
    tornado2 = 12520,
    buccaneer = 19280,
    fcr2 = 19830,
    michelli = 19830,
    minivan = 19830,
    sanctus = 19830,
    surfer2 = 8830,
    toro = 32120,
    defiler = 20380,
    chino2 = 20930,
    faction3 = 20930,
    speeder = 31989,
    taco = 20930,
    ratloader2 = 21480,
    hustler = 22030,
    journey = 22030,
    moonbeam = 32030,
    rumpo2 = 22030,
    surfer = 10830,
    tr2 = 22030,
    virgo3 = 22030,
    youga = 22030,
    double = 22600,
    sabregt = 22600,
    gauntlet = 23150,
    speedo = 23150,
    speedo3 = 23150,
    slamvan = 23650,
    buccaneer2 = 24250,
    diablous = 24250,
    pony = 24250,
    radi = 6402,
    tailgater = 11855,
    tampa = 24250,
    virgo2 = 24250,
    minivan2 = 14600,
    akuma = 24800,
    habanero = 7460,
    burrito3 = 25250,
    hermes = 25400,
    bati = 26441,
    gauntlet2 = 26441,
    romero = 6660,
    bobcatxl = 21703,
    bati2 = 27600,
    diablous2 = 27600,
    dominator = 27600,
    felon = 32600,
    marquis = 31540,
    moonbeam2 = 38030,
    oracle = 27600,
    paradise = 27600,
    rebel2 = 27600,
    retinue = 27600,
    rumpo = 27600,
    schafter2 = 27600,
    tornado5 = 27600,
    trailers3 = 27600,
    yosemite = 27600,
    youga2 = 27600,
    gburrito = 35200,
    pony2 = 28200,
    gburrito2 = 36350,
    slamvan2 = 29350,
    rumpo3 = 30000,
    savestra = 30500,
    superd = 30500,
    dominator2 = 31200,
    felon2 = 35200,
    sabregt2 = 31200,
    penumbra = 21800,
    oracle2 = 32400,
    slamvan3 = 33000,
    bison3 = 33550,
    bodhi2 = 19550,
    tulip = 53550,
    fq2 = 24750,
    hakuchou = 34750,
    sentinel = 26750,
    stockade = 35300,
    bjxl = 13990,
    gresley = 28050,
    seminole = 12500,
    dubsta = 36500,
    sentinel2 = 28400,
    stafford = 25600,
    bf400 = 39500,
    bison = 39500,
    camper = 28500,
    gmcs = 39500,
    hakuchou2 = 39500,
    hotknife = 39500,
    jackal = 39500,
    rancherxl = 24131,
    serrano = 11681,
    speedo2 = 39500,
    vamos = 59500,
    zion = 24500,
    tug = 40500,
    dubsta2 = 41900,
    rebel = 41900,
    rocoto = 19898,
    zion2 = 27900,
    xls = 38100,
    landstalker = 15541,
    cavalcade = 18400,
    cognoscenti = 53400,
    hauler = 45500,
    sadler = 31240,
    huntley = 27881,
    baller = 30645,
    cavalcade2 = 25327,
    cogcabrio = 57544,
    deviant = 73500,
    patriot = 37856,
    schwarzer = 41500,
    trophytruck = 53500,
    baller2 = 48560,
    granger = 32680,
    f620 = 59500,
    sandking = 31890,
    baller3 = 60800,
    windsor = 60800,
    mesa = 31250,
    cog55 = 45981,
    imperator = 62000,
    baller4 = 65400,
    bestiagts = 115400,
    brawler = 65400,
    sandking2 = 28400,
    sultan = 49400,
    windsor2 = 65400,
    mesa3 = 42127,
    alpha = 48500,
    revolter = 171500,
    tampa2 = 71500,
    trophytruck2 = 71500,
    buffalo = 48500,
    fusilade = 35500,
    kuruma = 88000,
    omnis = 78000,
    pigalle = 78000,
    sentinel3 = 65000,
    stretch = 61000,
    riata = 88020,
    buffalo2 = 154010,
    elegy2 = 83890,
    surano = 49000,
    banshee = 75250,
    lynx = 120250,
    schafter3 = 130250,
    streiter = 130250,
    furoregt = 75000,
    carbonizzare = 75500,
    exemplar = 115500,
    havok = 95500,
    coquette = 102500,
    feltzer2 = 78500,
    kamacho = 112500,
    phantom3 = 102500,
    comet2 = 108000,
    jester2 = 138000,
    massacro2 = 108000,
    ninef = 108000,
    schafter4 = 108000,
    dubsta3 = 115000,
    hotring = 115000,
    jester = 115000,
    massacro = 115000,
    ninef2 = 115000,
    khamelion = 121000,
    rapidgt = 121000,
    stunt = 121000,
    rapidgt2 = 127000,
    schlagen = 187000,
    tropos = 127000,
    comet4 = 133600,
    verlierer2 = 133600,
    monroe = 145900,
    seven70 = 151400,
    comet3 = 198000,
    elegy = 198000,
    z190 = 158000,
    seabreeze = 164500,
    contender = 170600,
    ellie = 170600,
    jester3 = 170600,
    raiden = 170600,
    ruston = 70600,
    nightshade = 128200,
    rapidgt3 = 178200,
    flashgt = 184400,
    mamba = 134400,
    neon = 234400,
    patriot2 = 103510,
    casco = 197000,
    dominator3 = 197000,
    btype = 210600,
    comet5 = 210600,
    feltzer3 = 210600,
    coquette2 = 216000,
    coquette3 = 216000,
    gt500 = 216000,
    btype3 = 222300,
    sultanrs = 222300,
    stinger = 229300,
    btype2 = 236000,
    sheava = 236000,
    ztype = 236000,
    stingergt = 242300,
    guardian = 246800,
    torero = 249100,
    specter = 301800,
    viseris = 261800,
    gb200 = 276000,
    italigto = 371000,
    voltic = 211000,
    infernus = 243000,
    rogue = 343000,
    toros = 343000,
    pariah = 150200,
    specter2 = 400200,
    vacca = 350200,
    duster = 375000,
    alphaz1 = 389300,
    howard = 401900,
    tempesta = 401900,
    vestra = 408100,
    bullet = 433900,
    frogger = 443100,
    deluxo = 446000,
    entityxf = 472000,
    mammatus = 472000,
    sc1 = 472000,
    ardent = 473000,
    infernus2 = 510000,
    cheetah2 = 517000,
    buzzard2 = 578000,
    swinger = 579000,
    penetrator = 600000,
    gp1 = 606000,
    reaper = 619000,
    turismo2 = 619000,
    banshee2 = 621000,
    cheetah = 645000,
    d2 = 664000,
    pfister811 = 664000,
    adder = 667000,
    turismor = 670000,
    italigtb = 696000,
    t20 = 696000,
    tyrus = 696000,
    entity2 = 702000,
    swift2 = 702000,
    vagner = 708000,
    xa21 = 715000,
    cyclone = 721000,
    osiris = 721000,
    autarch = 727000,
    le7b = 727000,
    fmj = 733000,
    visione = 733000,
    zentorno = 746000,
    deveste = 752000,
    taipan = 760000,
    cargobob2 = 766000,
    nero = 766000,
    volatus = 771000,
    tyrant = 778000,
    italigtb2 = 791000,
    tezeract = 797000,
    prototipo = 822000,
    nero2 = 849000,
    schafter5 = 1000000,
    schafter6 = 1000000,
    monster = 1040000,
    baller6 = 1129000,
    jb700 = 440000,
    impaler = 50200,
    issi4 = 13000,
    issi5 = 17000,
    bmx = 50,
    cruiser = 75,
    fixter = 140,
    scorcher = 175,
    tribike2 = 225,
    tribike3 = 225,
    tribike = 225,
    romeo = 25430,
    imperator2 = 75700,
    asbo = 7550,
    kanjo = 16730,
    coquette4 = 380667,
    tigon = 317252,
    penumbra2 = 108326,
    landstalker2 = 46100,
    yosemite3 = 34560,
    yosemite2 = 36872,
    club = 17550,
    gauntlet5 = 50842,
    dukes3 = 22740,
    youga3 = 34330,
    glendale2 = 14800,
    seminole2 = 41463,
    peyote3 = 21520,
    manana2 = 17710,
    paragon = 225623,
    paragon2 = 54850,
    jugular = 315585,
    neo = 452750,
    krieger = 543620,
    peyote2 = 20650,
    gauntlet4 = 210745,
    s80 = 345560,
    caracara2 = 217551,
    thrax = 1460750,
    rebla = 140220,
    novak = 162225,
    zorrusso = 826333,
    issi7 = 179985,
    locust = 132100,
    emerus = 955460,
    hellion = 51620,
    dynasty = 11150,
    gauntlet3 = 52360,
    nebula = 45700,
    zion3 = 42823,
    jb7002 = 400150,
    drafter = 281147,
    retinue2 = 32230,
    komoda = 335574,
    sugoi = 152452,
    sultan2 = 172650,
    vstr = 225750,
    furia = 625991,
    stryder = 35850,
    everon = 205630,
    outlaw = 134350,
    vagrant = 165657,
    brioso2 = 3521,
    italirsx = 376510,
    manchez2 = 8105,
    slamntruck = 27412,
    squaddie = 43150,
    toreador = 320980,
    weevil = 6850,
    winky = 16432,
}

local main = RageUI.CreateMenu("Car Dealer", "Welcome to the car dealer")
main.Closed = function()
    active = false
end

local sub = RageUI.CreateSubMenu(main, "Car Dealer", "Welcome to the car dealer")
local sub2 = RageUI.CreateSubMenu(main, "Car Dealer", "Welcome to the car dealer")

local function openMenu()
    if active then return end
    local allVehs = {}
    RedFW.Client.Components.Callback:triggerServer('CarDealer:getAllVeh', function(allVeh)
        allVehs = allVeh
    end)
    active = true
    local index = 1
    RageUI.Visible(main, true)
    Citizen.CreateThread(function()
        while active do
            RageUI.IsVisible(main, function()
                RageUI.Button("Commander un véhicule", nil, {RightLabel = "→→→"}, true, {}, sub)
                RageUI.Button("Véhicules vendus", nil, {RightLabel = "→→→"}, true, {}, sub2)
            end)
            RageUI.IsVisible(sub, function()
                for _, v in pairs(GetAllVehicleModels()) do
                    if vehPrice[v] ~= nil then
                        RageUI.List(GetLabelText(GetDisplayNameFromVehicleModel(v)), {"Voir le véhicule", "Acheter le véhicule"}, index, ('Prix : %s'):format(vehPrice[v]), {}, true, {
                            onListChange = function(Index, Item)
                                index = Index
                            end,
                            onSelected = function(_, Items)
                                if (Items == "Voir le véhicule") then
                                    _Cardealer.ShowVehicle(v)
                                else
                                    RedFW.Client.Components.Callback:triggerServer('CarDealer:canBuy', function(canBuy)
                                        if (canBuy) then
                                            RedFW.Client.Components.Callback:triggerServer('CarDealer:buyVeh', function(canBuy)
                                                if (canBuy) then
                                                    RedFW.Client.Functions:notification("Vous avez commandé un véhicule pour ~g~"..vehPrice[v].."$")
                                                end
                                            end, vehPrice[v], Props, Plate)
                                        else
                                            RedFW.Client.Functions:notification("L'entreprise ne peut pas vous fournir de véhicule pour le moment.")
                                        end
                                    end, vehPrice[v])
                                end
                            end,
                        })
                    end
                end
            end)
            RageUI.IsVisible(sub2, function()
                for key, value in pairs(allVehs) do
                    RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(value.props.model)) .. " [".. value.plate.."]", ('Model: %s\nPlaque: %s\nSituation: %s\nVendu: %s'):format(value.props.model, value.plate, value.situation, value.owner ~= "cardealer"), {}, value.owner == "cardealer", {
                        onSelected = function()
                            local player, distance = RedFW.Client.Functions:getClosestPlayer()
                            if (distance ~= -1 and distance <= 3.0) then
                                RedFW.Shared.Event:triggerServerEvent('CarDealer:giveVeh', GetPlayerServerId(player), value)
                            else
                                RedFW.Client.Functions:notification("Aucun joueur à proximité.")
                            end
                        end
                    })
                end
            end)
            Wait(0)
        end
    end)
end

RedFW.Shared.Event:registerEvent("openCarDealer", function()
    if RedFW.Client.Components.Player.job.name == "cardealer" then
        openMenu()
    end
end)