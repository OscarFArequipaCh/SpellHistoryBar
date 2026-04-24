SpellHistoryBar = SpellHistoryBar or {}

SpellHistoryBar.CONTROL_SPELLS = {
    -- Add the specific IDs of your control spells here.
    [33786] = true,  -- Cyclone
    [339] = true,    -- Entangling Roots
    [51514] = true,  -- Hex
    [2637] = true,   -- Disengage
    [118] = true,    -- Polymorph
    [28272] = true,  -- Pig Polymorph
    [28271] = true,  -- Turtle Polymorph
    [28270] = true,  -- Rabbit Polymorph
    [28269] = true,  -- Sheep Polymorph
    [28268] = true,  -- Monkey Polymorph
    [2641] = true,   -- dismiss-pet
    [34914] = true,  -- Vampiric Touch
    [710] = true,    -- Banish
    [605] = true,    -- Mind Control
    [9484] = true,   -- Shackle Undead
    [30108] = true,  -- Unstable Affliction
    [5782] = true,   -- Fear
    [1513] = true,   -- Intimidating Shout
    [76780] = true,  -- Bind Elemental
    [49203] = true,  -- Hungering Cold
    [65116] = true,  -- Stoneform
    [20549] = true,  -- War Stomp
    [48018] = true,  -- círculo-demoníaco-invocar
    -- [12654] = true,  -- ignite (Activate it if you want to be able to see when ignite is launched.)  
}

SpellHistoryBar.BLACKLIST_SPELLS = {
    -- Hechizos automáticos o pasivos Automatic or passive spells
    -- Warrior
    [44949] = true,  -- whirlwind-off-hand (subskill off-hand)
    [20253] = true,  -- intercept (effect stun)
    [23880] = true,  -- bloodthirst (subskill)
    [85384] = true,  -- raging-blow-off-hand (subskill off-hand)
    [96103] = true,  -- raging-blow (subskill)
    [76858] = true,  -- opportunity-strike (passive weapon talents)
    [22858] = true,  -- retaliation (effect hit returned)
    [50622] = true,  -- whirlwind (subskill)
    [26654] = true,  -- sweeping-strikes (effect additional hits)
    -- Paladin
    [31804] = true,  -- judgement-of-truth(accumulation effect)
    [42463] = true,  -- seal-of-truth(effect)
    [20424] = true,  -- seals-of-command(passive retribution talents)
    [96172] = true,  -- hand-of-light(passive retribution talents)
    [20170] = true,  -- seal-of-justice(hit effect)
    [20167] = true,  -- seal-of-insight(effect of regenerative shocks)
    [101423] = true, -- seal-of-righteousness(effect additional hits)
    [20187] = true,  -- judgement-of-righteousness(pasive with judgment)
    [54158] = true,  -- judgement(pasive with judgment)
    [94289] = true,  -- protector-of-the-innocent(passive holy talents)
    [99075] = true,  -- righteous-flames(passive protecction talents)
    [88263] = true,  -- hammer-of-the-righteous(subskill)
    -- Death Knight
    [52212] = true,  -- death-and-decay(pasive effect)
    [66216] = true,  -- plague-strike-off-hand(subskill off-hand)
    [66196] = true,  -- frost-strike-off-hand(subskill off-hand)
    [66198] = true,  -- obliterate-off-hand(subskill off-hand)
    [66188] = true,  -- death-strike-off-hand(subskill off-hand)
    [66215] = true,  -- blood-strike-off-hand(subskill off-hand)
    [47633] = true,  -- death-coil(subskill)
    [47632] = true,  -- death-coil(subskill)
    [42651] = true,  -- army-of-the-dead(summoning effect)
    [45470] = true,  -- death-strike(healing efect)
    [70890] = true,  -- scourge-strike (subskill)
    [50452] = true,  -- blood-parasite (passive blood talents)
    -- Druid
    [16953] = true,  -- Primal Fury (passive feral talents)
    [81269] = true,  -- efflorescence (pasive effect)
    [78777] = true,  -- wild-mushroom (subskill)
    [22845] = true,  -- frenzied-regeneration (pasive effect)
    [50288] = true,  -- starfall (pasive effect)
    [44203] = true,  -- tranquility (pasive effect)
    -- Rogue
    [86392] = true,  -- Main Gauche (passive combat talents)
    -- [84745] = true,  Shallow Insight (passive combat talents)
    [22482] = true,  -- blade-flurry (effect additional hits)
    [57842] = true,  -- killing-spree-off-hand (subskill off-hand)
    [57841] = true,  -- killing-spree-off-hand (subskill off-hand)
    [5374] = true,   -- mutilate (subskill)
    [27576] = true,  -- mutilate-off-hand (subskill off-hand)
    [79136] = true,  -- venomous-wound (passive assassination talents)
    -- Shaman
    [32176] = true,  -- stormstrike-off-hand (subskill off-hand)
    [17364] = true,  -- stormstrike (subskill)
    [52752] = true,  -- ancestral-awakening(passive restoration talents)
    [26364] = true,  -- Lightning Shield (effect hit returned)
    [88767] = true,  -- fulmination (passive elemental-combat talents)
    [379] = true,    -- earth-shield (effect hit returned)
    [73921] = true,  -- Healing Rain (pasive effect)
    -- Hunter
    [76663] = true,  -- wild-quiver (passive marksmanship talents)
    [53353] = true,  -- disparo-de-quimera (healing efect)
    [13481] = true,  -- tame-beast (pasive effect)
    [83077] = true,  -- improved-serpent-sting (passive survival talents)
    -- Priest
    [49821] = true,  -- mind-sear (effect additional hits)
    [2944] = true,   -- devouring-plague (pasive effect)
    [64844] = true,  -- divine-hymn (pasive effect)
    [94472] = true,  -- atonement (passive dicipline talents)
    [33110] = true,  -- prayer-of-mending (pasive effect)
    [56160] = true,  -- glyph-of-power-word-shield (glyph effect)
    [23455] = true,  -- holy-nova (effect additional hits)
    [20473] = true,  -- holy-shock (subskill)
    [88686] = true,  -- Holy Word: Sanctuary (pasive effect)
    [87426] = true,  -- shadowy-apparition (passive shadow talents)
    -- Mage
    [84721] = true,  -- frostfire-orb (pasive effect)
    [82739] = true,  -- flame-orb (pasive effect)
    [91394] = true,  -- permafrost (passive frost talents)
    [58833] = true,  -- mirror-image (subskill)
    [58831] = true,  -- mirror-image (subskill)
    [58834] = true,  -- mirror-image (subskill)
    [34913] = true,  -- molten-armor (effect hit returned)
    [44461] = true,  -- living-bomb (explosion hit)
    -- Warlock
    [54181] = true,  -- fel-synergy (passive demonology talents)
    [50590] = true,  -- immolation (pasive effect)
    [30294] = true,  -- soul-leech (passive destruction talents)
    [85455] = true,  -- bane-of-havoc (effect additional hits)
    [42223] = true,  -- rain-of-fire (effect additional hits)
    [63106] = true,  -- siphon-life (passive affliction talents)
    [48210] = true,  -- haunt (healing effect)
    [60478] = true,  -- invocar-guardia-apocalíptico (subskill)
    [22703] = true,  -- infernal-awakening (subskill)
    [31117] = true,  -- aflicción-inestable (pasive effect)

    -- Class enchantments on weapons(Death Knight, Rogue, Shaman)
    [50401] = true,  -- Razorice (Effect Rune)
    [53365] = true,  -- unholy-strength (Effect Rune)
    [8680] = true,   -- Instant Poison (effect poison)
    [13218] = true,  -- Wound Poison (effect poison)
    [73683] = true,  -- Unleash Flame (inbution effect)
    [73681] = true,  -- Unleash Wind (inbution effect)
    [73682] = true,  -- Unleash Earth (inbution effect)
    [73684] = true,  -- Unleash Frost (inbution effect)
    [73685] = true,  -- Unleash Life (inbution effect)
    [25504] = true,  -- windfury-attack (inbution effect)
    [74194] = true,  -- Mending (enchanting effect)

    -- Specific item spells (example: No´Kaled, Fetiche, etc.)
    [107789] = true, -- Iceblast (Item: No´Kaled)
    [109872] = true, -- Flameblast (Item: No´Kaled)
    [107785] = true, -- flameblast (Item: No´Kaled)
    [109868] = true, -- shadowblast (Item: No´Kaled)
    [107787] = true, -- shadowblast (Item: No´Kaled)
    [107997] = true, -- whirling-maw(Item: Fetiche)
    [10444] = true,  -- Flametongue Attack (Item: Flametongue)
    [33750] = true,  -- Windfury Attack (Item: Windfury)
    [108005] = true, -- shadowbolt-volley (Item: Astucia de cruel)
    [109800] = true, -- shadowbolt-volley (Item: Astucia de cruel heroico)
    [99058] = true,  -- flaming-arrow(Item: Vishanka)
    [107818] = true, -- summon-tentacle-of-the-old-ones(Gurtalak)
    [109840] = true, -- summon-tentacle-of-the-old-ones(Gurtalak Heorica)
    [108000] = true, -- nick-of-time(item: guardavientos)
    [108022] = true, -- Drain Life (Item: Bebedora de almas)
    [107994] = true, -- Lightning Strike (item: Nokaled?)
    [109870] = true, -- Iceblast (Item: No´Kaled heroica)
    [107835] = true, -- cleansing-flames(item: Fauce)
    [109831] = true, -- drain-life (Item: Bebedora de almas heroica)
    [99035] = true,  -- burning-treant (tier-bonus TF)
    [99063] = true,  -- mirror-image (tier-bonus TF)
    [99221] = true,  -- fiery-imp (tier-bonus TF)
    [96891] = true,  -- lightning-bolt (item: condensador)
}

SpellHistoryBar.PROJECTILE_SPELLS = {
    -- Spells with projectiles that cause duplicates with SPELL_CAST_SUCCESS and SPELL_DAMAGE
    [3044] = true,   -- Arcane Shot
    [53209] = true,  -- Chimera Shot
    [2643] = true,  -- Multi-Shot
    [92315] = true,  -- Piroblast (instant cast version)
}

SpellHistoryBar.CAST_START_SPELLS = {
    -- Spells that are detected with SPELL_CAST_START
    [88685] = true,  -- Holy Word: Sanctuary
    [73920] = true,  -- Healing Rain
}
