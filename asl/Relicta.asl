// Unreal Engine starter template
// Replace the process name with the game's executable name without ".exe".
// Common Unreal packaged games often look like "GameName-Win64-Shipping".
// https://github.com/ru-mii/uhara

state("Relicta-Win64-Shipping"){}

startup
{
    vars.ScriptVersion = "v1.0.0";
    vars.MissingUhara = !File.Exists("Components/uhara10");
    if (vars.MissingUhara)
    {
        System.Windows.Forms.MessageBox.Show(
            "Missing required file: Components/uhara10,\n" +
            "Please place uhara10 in your LiveSplit Components folder.\n" +
            "https://github.com/ru-mii/uhara/raw/refs/heads/main/bin/uhara10",
            "Relicta Autosplitter " + vars.ScriptVersion,
            System.Windows.Forms.MessageBoxButtons.OK,
            System.Windows.Forms.MessageBoxIcon.Error
        );
        return;
    }

    Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
    // vars.Uhara.AlertLoadless(); // Optional: alert that Game Time is being used for load removal

    vars.CompletedDoSplitOnce = new HashSet<string>();

    vars.DoSplitOnce = (Func<string, bool>)((key) =>
    {
    if (vars.CompletedDoSplitOnce.Contains(key)) return false;
    vars.CompletedDoSplitOnce.Add(key);
    return true;
    });

    vars.ResetDoSplitOnce = (Action)(() =>
    {
    vars.CompletedDoSplitOnce.Clear();
    });

    dynamic[,] _settings =
    {
        // Start examples
        { "Reset", true, "Reset on exit game", null },


        { "SplitsGroup", true, "Splits", null },

        { "IntroSplit", true, "Split on Intro", "SplitsGroup" },
        { "Track1Split", true, "Split on Track 1 end", "SplitsGroup" },

        { "LabForestSplit", true, "Split on Forest Enter", "SplitsGroup" },
        { "ForestSplit", true, "Split on Forest end", "SplitsGroup" },

        { "LabTaigaSplit", true, "Split on Taiga Enter", "SplitsGroup" },
        { "TaigaGroup", false, "Taiga puzzles", "SplitsGroup"},
        { "Taiga3", true, "Split on Taiga Puzzle 3", "TaigaGroup"},
        { "TaigaSplit", true, "Split on Taiga end", "SplitsGroup" },

        { "LabCavesSplit", true, "Split on Caves Enter", "SplitsGroup" },
        { "CavesGroup", false, "Caves puzzles", "SplitsGroup"},
        { "Caves2", true, "Split on Caves Puzzle 2", "CavesGroup"},
        { "Caves5", true, "Split on Caves Puzzle 5", "CavesGroup"},
        { "CavesSplit", true, "Split on Caves end", "SplitsGroup" },

        { "LabCliffSplit", true, "Split on Cliff Enter", "SplitsGroup" },
        { "CliffGroup", false, "Cliff puzzles", "SplitsGroup"},
        { "Cliff1", true, "Split on Cliff Puzzle 1", "CliffGroup"},
        { "Cliff3", true, "Split on Cliff Puzzle 3", "CliffGroup"},
        { "Cliff5", true, "Split on Cliff Puzzle 5", "CliffGroup"},
        { "CliffSplit", true, "Split on Cliff end", "SplitsGroup" },

        { "LabCanyonSplit", true, "Split on Canyon Enter", "SplitsGroup" },
        { "CanyonGroup", false, "Canyon puzzles", "SplitsGroup"},
        { "Canyon2", true, "Split on Canyon Puzzle 2", "CanyonGroup"},
        { "Canyon4", true, "Split on Canyon Puzzle 4", "CanyonGroup"},
        { "CanyonSplit", true, "Split on Canyon end", "SplitsGroup" },

        { "LabBeachSplit", true, "Split on Beach Enter", "SplitsGroup" },
        { "BeachGroup", false, "Beach puzzles", "SplitsGroup"},
        { "Beach1", true, "Split on Beach Puzzle 1", "BeachGroup"},
        { "Beach2", true, "Split on Beach Puzzle 2", "BeachGroup"},
        { "Beach3", true, "Split on Beach Puzzle 3", "BeachGroup"},
        { "Beach4", true, "Split on Beach Puzzle 4", "BeachGroup"},
        { "BeachSplit", true, "Split on Beach end", "SplitsGroup" },

        { "LabGlacierSplit", true, "Split on Glacier Enter", "SplitsGroup" },
        { "GlacierGroup", false, "Glacier puzzles", "SplitsGroup"},
        { "Glacier1", true, "Split on Glacier Puzzle 1", "GlacierGroup"},
        { "Glacier2", true, "Split on Glacier Puzzle 2", "GlacierGroup"},
        { "Glacier3", true, "Split on Glacier Puzzle 3", "GlacierGroup"},
        { "Glacier4", true, "Split on Glacier Puzzle 4", "GlacierGroup"},
        { "Glacier5", true, "Split on Glacier Puzzle 5", "GlacierGroup" },
        { "GlacierSplit", true, "Split on Glacier end", "SplitsGroup" },

        { "LabRiverSplit", true, "Split on River Enter", "SplitsGroup" },
        { "RiverGroup", false, "River puzzles", "SplitsGroup"},
        { "River1", true, "Split on River Puzzle 1", "RiverGroup"},
        { "River2", true, "Split on River Puzzle 2", "RiverGroup"},
        { "River3", true, "Split on River Puzzle 3", "RiverGroup"},
        { "River5", true, "Split on River Puzzle 5", "RiverGroup"},
        { "River6", true, "Split on River Puzzle 6", "RiverGroup"},
        { "RiverSplit", true, "Split on River end", "SplitsGroup" },

        { "LabDesertSplit", true, "Split on Desert Enter", "SplitsGroup" },
        { "DesertGroup", false, "Desert puzzles", "SplitsGroup"},
        { "Desert2", true, "Split on Desert Puzzle 2", "DesertGroup"},
        { "Desert3", true, "Split on Desert Puzzle 3", "DesertGroup"},
        { "DesertSplit", true, "Split on Desert end", "SplitsGroup" },

        { "LabJungleSplit", true, "Split on Jungle Enter", "SplitsGroup" },
        { "JungleGroup", false, "Jungle puzzles", "SplitsGroup"},
        { "Jungle1", true, "Split on Jungle Puzzle 1", "JungleGroup"},
        { "Jungle3", true, "Split on Jungle Puzzle 3", "JungleGroup"},
        { "Jungle4", true, "Split on Jungle Puzzle 4", "JungleGroup"},
        { "JungleSplit", true, "Split on Jungle end", "SplitsGroup" },

        { "EndTableSplit", true, "Split on Ending", "SplitsGroup" },
    };
    vars.Uhara.Settings.Create(_settings);
}

init
{
    if (vars.MissingUhara) return;

    // Unreal helpers
    vars.Utils = vars.Uhara.CreateTool("UnrealEngine", "Utils");
    vars.Events = vars.Uhara.CreateTool("UnrealEngine", "Events");

    // Optional Unreal setup helpers. Some games need these, some do not.
    vars.Utils.ExpandScanUtilitySignatures("UObject_BeginDestroy", "40 53 48 83 EC 40 8B 41 08 48 8B D9 0F BA E0 0F 72");
    vars.Utils.GEngine = vars.Uhara.ScanRel(3, "48 89 05 ?? ?? ?? ?? E8 ?? ?? ?? ?? 80 3D ?? ?? ?? ?? ?? 72 ?? 48");

    if (vars.Utils.GEngine != IntPtr.Zero) vars.Uhara.Log("GEngine found at " + vars.Utils.GEngine.ToString("X"));
    if (vars.Utils.GWorld != IntPtr.Zero) vars.Uhara.Log("GWorld found at " + vars.Utils.GWorld.ToString("X"));
    if (vars.Utils.FNames != IntPtr.Zero) vars.Uhara.Log("FNames found at " + vars.Utils.FNames.ToString("X"));

    // Example event listeners.
    // Replace the placeholder strings with the real function names for your game.
    vars.Events.FunctionFlag("StartGame", "MeteoriteChamber02_Gameplay_C", "MeteoriteChamber02_Gameplay_C", "OnSeqFinish");
    vars.Events.FunctionFlag("Reset", "UI_ApplyExitGame_C", "UI_ApplyExitGame_C", "BndEvt__AcceptBtn_K2Node_ComponentBoundEvent_17_ButtonPressed__DelegateSignature");


    vars.Events.FunctionFlag("IntroSplit", "BDome01_Gameplay_C", "BDome01_Gameplay_C", "EntryElvatorDay1");
    vars.Events.FunctionFlag("Track1Split", "BDome01_Gameplay_C", "BDome01_Gameplay_C", "BndEvt__TriggerNarrative16_K2Node_ActorBoundEvent_137_ActorBeginOverlapSignature__DelegateSignature");

    vars.Events.FunctionFlag("LabForestSplit", "BDome01_Gameplay_C", "BDome01_Gameplay_C", "EntryElevatorDay2");
    vars.Events.FunctionFlag("ForestSplit", "BDome01_Gameplay_C", "BDome01_Gameplay_C", "BndEvt__TriggerBox_1_K2Node_ActorBoundEvent_3_ActorBeginOverlapSignature__DelegateSignature");

    vars.Events.FunctionFlag("LabTaigaSplit", "GlaciarDome01_P_C", "GlaciarDome01_P_C", "OnLoadLevels");
    vars.Events.FunctionFlag("Taiga3", "GlaciarDome01_Geo_C", "GlaciarDome01_Geo_C", "BndEvt__TriggerBox_1_K2Node_ActorBoundEvent_2_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("TaigaSplit", "GlaciarDome01_Geo_C", "GlaciarDome01_Geo_C", "BndEvt__TriggerBox2_3_K2Node_ActorBoundEvent_4_ActorBeginOverlapSignature__DelegateSignature");

    vars.Events.FunctionFlag("LabCavesSplit", "GlaciarDome02_P_C", "GlaciarDome02_P_C", "OnLoadLevels");
    vars.Events.FunctionFlag("Caves2", "GlaciarDome02_Geo_C", "GlaciarDome02_Geo_C", "BndEvt__TriggerBox3_5_K2Node_ActorBoundEvent_1_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Caves5", "GlaciarDome02_Geo_C", "GlaciarDome02_Geo_C", "BndEvt__TriggerBox4_8_K2Node_ActorBoundEvent_2_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("CavesSplit", "GlaciarDome02_Geo_C", "GlaciarDome02_Geo_C", "BndEvt__TriggerBox5_11_K2Node_ActorBoundEvent_3_ActorBeginOverlapSignature__DelegateSignature");

    vars.Events.FunctionFlag("LabCliffSplit", "BotanicalDome02_P_C", "BotanicalDome02_P_C", "OnLoadLevels");
    vars.Events.FunctionFlag("Cliff1", "BotanicalDome02_Audio_C", "BotanicalDome02_Audio_C", "BndEvt__TriggerBox_1_K2Node_ActorBoundEvent_0_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Cliff3", "BotanicalDome02_Audio_C", "BotanicalDome02_Audio_C", "BndEvt__TriggerBox3_3_K2Node_ActorBoundEvent_2_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Cliff5", "BotanicalDome02_Audio_C", "BotanicalDome02_Audio_C", "BndEvt__TriggerBox2_2_K2Node_ActorBoundEvent_1_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("CliffSplit", "BotanicalDome02_Audio_C", "BotanicalDome02_Audio_C", "BndEvt__TriggerBox4_3_K2Node_ActorBoundEvent_3_ActorBeginOverlapSignature__DelegateSignature");

    vars.Events.FunctionFlag("LabCanyonSplit", "AridDome01_P_C", "AridDome01_P_C", "OnLoadLevels");
    vars.Events.FunctionFlag("Canyon2", "AridDome01_Geo_C", "AridDome01_Geo_C", "BndEvt__TriggerBox_1_K2Node_ActorBoundEvent_3_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Canyon4", "AridDome01_Geo_C", "AridDome01_Geo_C", "BndEvt__TriggerBox2_4_K2Node_ActorBoundEvent_4_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("CanyonSplit", "AridDome01_Geo_C", "AridDome01_Geo_C", "BndEvt__TriggerVolume4_4_K2Node_ActorBoundEvent_7_ActorEndOverlapSignature__DelegateSignature");

    vars.Events.FunctionFlag("LabBeachSplit", "TropicalDome01_P_C", "TropicalDome01_P_C", "OnLoadLevels");
    vars.Events.FunctionFlag("Beach1", "TDome01_Geo_C", "TDome01_Geo_C", "BndEvt__TriggerBox3_6_K2Node_ActorBoundEvent_2_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Beach2", "TDome01_Geo_C", "TDome01_Geo_C", "BndEvt__TriggerBox4_2_K2Node_ActorBoundEvent_3_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Beach3", "TDome01_Geo_C", "TDome01_Geo_C", "BndEvt__TriggerBox5_3_K2Node_ActorBoundEvent_4_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Beach4", "TDome01_Geo_C", "TDome01_Geo_C", "BndEvt__TriggerBox6_6_K2Node_ActorBoundEvent_5_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("BeachSplit", "TDome01_Geo_C", "TDome01_Geo_C", "BndEvt__TriggerBox_1_K2Node_ActorBoundEvent_0_ActorBeginOverlapSignature__DelegateSignature");

    vars.Events.FunctionFlag("LabGlacierSplit", "GlaciarDome03_P_C", "GlaciarDome03_P_C", "OnLoadLevels");
    vars.Events.FunctionFlag("Glacier1", "GlaciarDome03_Geo_C", "GlaciarDome03_Geo_C", "BndEvt__TriggerBox3_3_K2Node_ActorBoundEvent_3_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Glacier2", "GlaciarDome03_Geo_C", "GlaciarDome03_Geo_C", "BndEvt__TriggerBox4_6_K2Node_ActorBoundEvent_4_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Glacier3", "GlaciarDome03_Geo_C", "GlaciarDome03_Geo_C", "BndEvt__TriggerBox5_9_K2Node_ActorBoundEvent_5_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Glacier4", "GlaciarDome03_Geo_C", "GlaciarDome03_Geo_C", "BndEvt__TriggerBox6_12_K2Node_ActorBoundEvent_6_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Glacier5", "GlaciarDome03_Geo_C", "GlaciarDome03_Geo_C", "BndEvt__TriggerBox7_15_K2Node_ActorBoundEvent_7_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("GlacierSplit", "GlaciarDome03_Geo_C", "GlaciarDome03_Geo_C", "BndEvt__BP_Elevator_74_K2Node_ActorBoundEvent_0_LevelEventDelegate_OnActorInteraction__DelegateSignature");

    vars.Events.FunctionFlag("LabRiverSplit", "BotanicalDome03_P_C", "BotanicalDome03_P_C", "OnLoadLevels");
    vars.Events.FunctionFlag("River1", "BotanicalDome03_Geo_C", "BotanicalDome03_Geo_C", "BndEvt__TriggerBox2_4_K2Node_ActorBoundEvent_2_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("River2", "BotanicalDome03_Geo_C", "BotanicalDome03_Geo_C", "BndEvt__TriggerBox3_9_K2Node_ActorBoundEvent_3_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("River3", "BotanicalDome03_Geo_C", "BotanicalDome03_Geo_C", "BndEvt__TriggerBox4_12_K2Node_ActorBoundEvent_4_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("River5", "BotanicalDome03_Geo_C", "BotanicalDome03_Geo_C", "BndEvt__TriggerBox5_15_K2Node_ActorBoundEvent_5_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("River6", "BotanicalDome03_Geo_C", "BotanicalDome03_Geo_C", "BndEvt__TriggerBox6_18_K2Node_ActorBoundEvent_6_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("RiverSplit", "BotanicalDome03_Geo_C", "BotanicalDome03_Geo_C", "BndEvt__TriggerBox7_21_K2Node_ActorBoundEvent_7_ActorBeginOverlapSignature__DelegateSignature");

    vars.Events.FunctionFlag("LabDesertSplit", "AridDome02_P_C", "AridDome02_P_C", "OnLoadLevels");
    vars.Events.FunctionFlag("Desert2", "AridDome02_P_C", "AridDome02_P_C", "BndEvt__TriggerBox3_7_K2Node_ActorBoundEvent_2_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Desert3", "AridDome02_P_C", "AridDome02_P_C", "BndEvt__TriggerBox4_10_K2Node_ActorBoundEvent_3_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("DesertSplit", "AridDome02_P_C", "AridDome02_P_C", "BndEvt__TriggerBox5_13_K2Node_ActorBoundEvent_4_ActorBeginOverlapSignature__DelegateSignature");

    vars.Events.FunctionFlag("LabJungleSplit", "TropicalDome02_P_C", "TropicalDome02_P_C", "OnLoadLevels");
    vars.Events.FunctionFlag("Jungle1", "TDome02_Geo_C", "TDome02_Geo_C", "BndEvt__TriggerBox3_3_K2Node_ActorBoundEvent_6_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Jungle3", "TDome02_Geo_C", "TDome02_Geo_C", "BndEvt__TriggerBox4_6_K2Node_ActorBoundEvent_7_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("Jungle4", "TDome02_Geo_C", "TDome02_Geo_C", "BndEvt__TriggerBox5_9_K2Node_ActorBoundEvent_8_ActorBeginOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("JungleSplit", "TDome02_Geo_C", "TDome02_Geo_C", "BndEvt__TriggerBox6_12_K2Node_ActorBoundEvent_9_ActorBeginOverlapSignature__DelegateSignature");

    vars.Events.FunctionFlag("EndTableSplit", "Lobby_Geo_C", "Lobby_Geo_C", "OnStopEndingB");
    vars.Events.FunctionFlag("EndHangarSplit", "Lobby_Geo_C", "Lobby_Geo_C", "OnStopEndingA");
}

start
{
    if (vars.MissingUhara) return false;

    // Simple start example
    if (vars.Resolver.CheckFlag("StartGame")) 
    {
        vars.ResetDoSplitOnce();
        return true;
    }

}

onStart
{
    if (vars.MissingUhara) return;
    vars.ResetDoSplitOnce();
}

split
{
    if (vars.MissingUhara) return false;

    if (vars.Resolver.CheckFlag("IntroSplit") && settings["IntroSplit"] && vars.DoSplitOnce("IntroSplit")) return true;
    if (vars.Resolver.CheckFlag("Track1Split") && settings["Track1Split"] && vars.DoSplitOnce("Track1Split")) return true;

    if (vars.Resolver.CheckFlag("LabForestSplit") && settings["LabForestSplit"] && vars.DoSplitOnce("LabForestSplit")) return true;
    if (vars.Resolver.CheckFlag("ForestSplit") && settings["ForestSplit"] && vars.DoSplitOnce("ForestSplit")) return true;

    if (vars.Resolver.CheckFlag("LabTaigaSplit") && settings["LabTaigaSplit"] && vars.DoSplitOnce("LabTaigaSplit")) return true;
    if (vars.Resolver.CheckFlag("Taiga3") && settings["Taiga3"] && vars.DoSplitOnce("Taiga3")) return true;
    if (vars.Resolver.CheckFlag("TaigaSplit") && settings["TaigaSplit"] && vars.DoSplitOnce("TaigaSplit")) return true;

    if (vars.Resolver.CheckFlag("LabCavesSplit") && settings["LabCavesSplit"] && vars.DoSplitOnce("LabCavesSplit")) return true;
    if (vars.Resolver.CheckFlag("Caves2") && settings["Caves2"] && vars.DoSplitOnce("Caves2")) return true;
    if (vars.Resolver.CheckFlag("Caves5") && settings["Caves5"] && vars.DoSplitOnce("Caves5")) return true;
    if (vars.Resolver.CheckFlag("CavesSplit") && settings["CavesSplit"] && vars.DoSplitOnce("CavesSplit")) return true;

    if (vars.Resolver.CheckFlag("LabCliffSplit") && settings["LabCliffSplit"] && vars.DoSplitOnce("LabCliffSplit")) return true;
    if (vars.Resolver.CheckFlag("Cliff1") && settings["Cliff1"] && vars.DoSplitOnce("Cliff1")) return true;
    if (vars.Resolver.CheckFlag("Cliff3") && settings["Cliff3"] && vars.DoSplitOnce("Cliff3")) return true;
    if (vars.Resolver.CheckFlag("Cliff5") && settings["Cliff5"] && vars.DoSplitOnce("Cliff5")) return true;
    if (vars.Resolver.CheckFlag("CliffSplit") && settings["CliffSplit"] && vars.DoSplitOnce("CliffSplit")) return true;

    if (vars.Resolver.CheckFlag("LabCanyonSplit") && settings["LabCanyonSplit"] && vars.DoSplitOnce("LabCanyonSplit")) return true;
    if (vars.Resolver.CheckFlag("Canyon2") && settings["Canyon2"] && vars.DoSplitOnce("Canyon2")) return true;
    if (vars.Resolver.CheckFlag("Canyon4") && settings["Canyon4"] && vars.DoSplitOnce("Canyon4")) return true;
    if (vars.Resolver.CheckFlag("CanyonSplit") && settings["CanyonSplit"] && vars.DoSplitOnce("CanyonSplit")) return true;

    if (vars.Resolver.CheckFlag("LabBeachSplit") && settings["LabBeachSplit"] && vars.DoSplitOnce("LabBeachSplit")) return true;
    if (vars.Resolver.CheckFlag("Beach1") && settings["Beach1"] && vars.DoSplitOnce("Beach1")) return true;
    if (vars.Resolver.CheckFlag("Beach2") && settings["Beach2"] && vars.DoSplitOnce("Beach2")) return true;
    if (vars.Resolver.CheckFlag("Beach3") && settings["Beach3"] && vars.DoSplitOnce("Beach3")) return true;
    if (vars.Resolver.CheckFlag("Beach4") && settings["Beach4"] && vars.DoSplitOnce("Beach4")) return true;
    if (vars.Resolver.CheckFlag("BeachSplit") && settings["BeachSplit"] && vars.DoSplitOnce("BeachSplit")) return true;

    if (vars.Resolver.CheckFlag("LabGlacierSplit") && settings["LabGlacierSplit"] && vars.DoSplitOnce("LabGlacierSplit")) return true;
    if (vars.Resolver.CheckFlag("Glacier1") && settings["Glacier1"] && vars.DoSplitOnce("Glacier1")) return true;
    if (vars.Resolver.CheckFlag("Glacier2") && settings["Glacier2"] && vars.DoSplitOnce("Glacier2")) return true;
    if (vars.Resolver.CheckFlag("Glacier3") && settings["Glacier3"] && vars.DoSplitOnce("Glacier3")) return true;
    if (vars.Resolver.CheckFlag("Glacier4") && settings["Glacier4"] && vars.DoSplitOnce("Glacier4")) return true;
    if (vars.Resolver.CheckFlag("Glacier5") && settings["Glacier5"] && vars.DoSplitOnce("Glacier5")) return true;
    if (vars.Resolver.CheckFlag("GlacierSplit") && settings["GlacierSplit"] && vars.DoSplitOnce("GlacierSplit")) return true;
    
    if (vars.Resolver.CheckFlag("LabRiverSplit") && settings["LabRiverSplit"] && vars.DoSplitOnce("LabRiverSplit")) return true;
    if (vars.Resolver.CheckFlag("River1") && settings["River1"] && vars.DoSplitOnce("River1")) return true;
    if (vars.Resolver.CheckFlag("River2") && settings["River2"] && vars.DoSplitOnce("River2")) return true;
    if (vars.Resolver.CheckFlag("River3") && settings["River3"] && vars.DoSplitOnce("River3")) return true;
    if (vars.Resolver.CheckFlag("River5") && settings["River5"] && vars.DoSplitOnce("River5")) return true;
    if (vars.Resolver.CheckFlag("River6") && settings["River6"] && vars.DoSplitOnce("River6")) return true;
    if (vars.Resolver.CheckFlag("RiverSplit") && settings["RiverSplit"] && vars.DoSplitOnce("RiverSplit")) return true;

    if (vars.Resolver.CheckFlag("LabDesertSplit") && settings["LabDesertSplit"] && vars.DoSplitOnce("LabDesertSplit")) return true;
    if (vars.Resolver.CheckFlag("Desert2") && settings["Desert2"] && vars.DoSplitOnce("Desert2")) return true;
    if (vars.Resolver.CheckFlag("Desert3") && settings["Desert3"] && vars.DoSplitOnce("Desert3")) return true;
    if (vars.Resolver.CheckFlag("DesertSplit") && settings["DesertSplit"] && vars.DoSplitOnce("DesertSplit")) return true;

    if (vars.Resolver.CheckFlag("LabJungleSplit") && settings["LabJungleSplit"] && vars.DoSplitOnce("LabJungleSplit")) return true;
    if (vars.Resolver.CheckFlag("Jungle1") && settings["Jungle1"] && vars.DoSplitOnce("Jungle1")) return true;
    if (vars.Resolver.CheckFlag("Jungle3") && settings["Jungle3"] && vars.DoSplitOnce("Jungle3")) return true;
    if (vars.Resolver.CheckFlag("Jungle4") && settings["Jungle4"] && vars.DoSplitOnce("Jungle4")) return true;
    if (vars.Resolver.CheckFlag("JungleSplit") && settings["JungleSplit"] && vars.DoSplitOnce("JungleSplit")) return true;

    if (vars.Resolver.CheckFlag("EndTableSplit") && settings["EndTableSplit"] && vars.DoSplitOnce("EndTableSplit")) return true;
    if (vars.Resolver.CheckFlag("EndHangarSplit") && settings["EndTableSplit"] && vars.DoSplitOnce("EndHangarSplit")) return true;
}

reset
{
    if (vars.MissingUhara) return false;

    if (vars.Resolver.CheckFlag("Reset") && settings["Reset"])
    {
        vars.ResetDoSplitOnce();
        return true;
    }
}

onReset
{
    if (vars.MissingUhara) return;
    vars.ResetDoSplitOnce();
}

update
{
    if (vars.MissingUhara) return;

    vars.Uhara.Update();
}
