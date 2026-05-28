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
        { "Track1Split", true, "Split on Track 1", "SplitsGroup" },

        { "LabForestSplit", true, "Split on Lab (Forest)", "SplitsGroup" },
        { "ForestSplit", true, "Split on Forest", "SplitsGroup" },

        { "LabTaigaSplit", true, "Split on Lab (Taiga)", "SplitsGroup" },
        { "TaigaSplit", true, "Split on Taiga", "SplitsGroup" },

        { "LabCavesSplit", true, "Split on Lab (Caves)", "SplitsGroup" },
        { "CavesSplit", true, "Split on Caves", "SplitsGroup" },

        { "LabCliffSplit", true, "Split on Lab (Cliff)", "SplitsGroup" },
        { "CliffSplit", true, "Split on Cliff", "SplitsGroup" },

        { "LabCanyonSplit", true, "Split on Lab (Canyon)", "SplitsGroup" },
        { "CanyonSplit", true, "Split on Canyon", "SplitsGroup" },

        { "LabBeachSplit", true, "Split on Lab (Beach)", "SplitsGroup" },
        { "BeachSplit", true, "Split on Beach", "SplitsGroup" },

        { "LabGlacierSplit", true, "Split on Lab (Glacier)", "SplitsGroup" },
        { "GlacierSplit", true, "Split on Glacier", "SplitsGroup" },

        { "LabRiverSplit", true, "Split on Lab (River)", "SplitsGroup" },
        { "RiverSplit", true, "Split on River", "SplitsGroup" },

        { "LabDesertSplit", true, "Split on Lab (Desert)", "SplitsGroup" },
        { "DesertSplit", true, "Split on Desert", "SplitsGroup" },

        { "LabJungleSplit", true, "Split on Lab (Jungle)", "SplitsGroup" },
        { "JungleSplit", true, "Split on Jungle", "SplitsGroup" },
        
        { "EndTable", true, "Split on Table Ending", "SplitsGroup" },
        { "EndHangar", true, "Split on Hangar Ending", "SplitsGroup" },
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


    vars.Events.FunctionFlag("IntroSplit", "MeteoriteChamber02_Gameplay_C", "MeteoriteChamber02_Gameplay_C", "OnStop");
    // [MeteoriteChamber02_Gameplay_C] [MeteoriteChamber02_Gameplay_C] [OnStop]
    // [BotanicalDome01_P_C] [BotanicalDome01_P_C] [MapLoaded]
    // [BotanicalDome01_P_C] [BotanicalDome01_P_C] [SecondaryMapLoaded]
    // [BotanicalDome01_P_C] [BotanicalDome01_P_C] [OnLoadLevels]


    vars.Events.FunctionFlag("Track1Split", "BotanicalLab01_P_C", "BotanicalLab01_P_C", "SecondaryMapLoaded");
    // [BP_PAPlayerController_C] [BP_PAPlayerController_C] [UpdateInterpCinematic]
    // [BDome01_Audio_C] [BDome01_Audio_C] [BndEvt__TriggerBox11_5_K2Node_ActorBoundEvent_8_ActorBeginOverlapSignature__DelegateSignature]
    // [BotanicalLab01_P_C] [BotanicalLab01_P_C] [MapLoaded]
    // try this:
    // [BotanicalLab01_P_C] [BotanicalLab01_P_C] [SecondaryMapLoaded]


    vars.Events.FunctionFlag("LabForestSplit", "BDome01_Gameplay_C", "BDome01_Gameplay_C", "EntryElevatorDay2");
    // [BotanicalDome01_P_C] [BotanicalDome01_P_C] [MapLoaded] already appears after intro
    // [BotanicalDome01_P_C] [BotanicalDome01_P_C] [SecondaryMapLoaded] already appears after intro
    // [BotanicalDome01_P_C] [BotanicalDome01_P_C] [OnLoadLevels] already appears after intro
    // [BDome01_Gameplay_C] [BDome01_Gameplay_C] [EntryElevatorDay2]


    vars.Events.FunctionFlag("ForestSplit", "PatelRoom_Geo_C", "PatelRoom_Geo_C", "PatelRoomConvers2");
    // [BDome01_Gameplay_C] [BDome01_Gameplay_C] [BndEvt__R_EndDome2_K2Node_ActorBoundEvent_9_ActorEndOverlapSignature__DelegateSignature]
    // [BDome01_Audio_C] [BDome01_Audio_C] [BndEvt__TriggerBox13_11_K2Node_ActorBoundEvent_20_ActorBeginOverlapSignature__DelegateSignature]
    // [Lobby_P_C] [Lobby_P_C] [MapLoaded]
    // [Lobby_P_C] [Lobby_P_C] [SecondaryMapLoaded]
    // [Lobby_P_C] [Lobby_P_C] [OnLoadLevels]
    // [PatelRoom_Geo_C] [PatelRoom_Geo_C] [PatelRoomConvers2]

    vars.Events.FunctionFlag("LabTaigaSplit", "GlaciarDome01_P_C", "GlaciarDome01_P_C", "OnLoadLevels");
    // [GlaciarDome01_P_C] [GlaciarDome01_P_C] [MapLoaded]
    // [GlaciarDome01_P_C] [GlaciarDome01_P_C] [SecondaryMapLoaded]
    // [GlaciarDome01_Audio_C] [GlaciarDome01_Audio_C] [BndEvt__TriggerVolume2_2_K2Node_ActorBoundEvent_0_ActorBeginOverlapSignature__DelegateSignature]
    // Probably the best for all splits:
    // [GlaciarDome01_P_C] [GlaciarDome01_P_C] [OnLoadLevels]

    
    vars.Events.FunctionFlag("TaigaSplit", "GlaciarLab02_P_C", "GlaciarLab02_P_C", "OnLoadLevels");
    // [GlaciarDome01_Audio_C] [GlaciarDome01_Audio_C] [BndEvt__TriggerVolume3_2_K2Node_ActorBoundEvent_0_ActorBeginOverlapSignature__DelegateSignature]
    // [GlaciarLab02_P_C] [GlaciarLab02_P_C] [MapLoaded]
    // [GlaciarLab02_P_C] [GlaciarLab02_P_C] [SecondaryMapLoaded]
    // [GlaciarLab02_P_C] [GlaciarLab02_P_C] [OnLoadLevels]

    vars.Events.FunctionFlag("LabCavesSplit", "GlaciarDome02_P_C", "GlaciarDome02_P_C", "OnLoadLevels");
    // [GlaciarDome02_P_C] [GlaciarDome02_P_C] [MapLoaded]
    // [GlaciarDome02_P_C] [GlaciarDome02_P_C] [SecondaryMapLoaded]
    // [GlaciarDome02_P_C] [GlaciarDome02_P_C] [OnLoadLevels]
    // [GlaciarDome02_Geo_C] [GlaciarDome02_Geo_C] [BndEvt__BP_NarrativeElevator2_5_K2Node_ActorBoundEvent_5_ElevatorGetsToDestination__DelegateSignature]


    vars.Events.FunctionFlag("CavesSplit", "GlaciarLab03_P_C", "GlaciarLab03_P_C", "OnLoadLevels");
    // [BP_NarrativeElevator_C] [BP_NarrativeElevator] [BndEvt__EnterElevatorCollision_K2Node_ComponentBoundEvent_0_ComponentBeginOverlapSignature__DelegateSignature]
    // [GlaciarLab03_P_C] [GlaciarLab03_P_C] [MapLoaded]
    // [GlaciarLab03_P_C] [GlaciarLab03_P_C] [SecondaryMapLoaded]
    // [GlaciarLab03_Gameplay_C] [GlaciarLab03_Gameplay_C] [ExecuteUbergraph_GlaciarLab03_Gameplay]
    // [GlaciarLab03_P_C] [GlaciarLab03_P_C] [OnLoadLevels]

    // Split for Relicta chamber?
    // [MeteoriteChamber02_Gameplay_C] [MeteoriteChamber02_Gameplay_C] [BndEvt__BP_GenericActivator_208_K2Node_ActorBoundEvent_1_LevelEventDelegate_OnActorInteraction__DelegateSignature]
    // [MeteoriteChamber02_Gameplay_C] [MeteoriteChamber02_Gameplay_C] [OnStop]


    vars.Events.FunctionFlag("LabCliffSplit", "BotanicalDome02_P_C", "BotanicalDome02_P_C", "OnLoadLevels");
    // [BotanicalDome02_P_C] [BotanicalDome02_P_C] [MapLoaded]
    // [BotanicalDome02_P_C] [BotanicalDome02_P_C] [SecondaryMapLoaded]
    // [BotanicalDome02_P_C] [BotanicalDome02_P_C] [OnLoadLevels]
    // [BotanicalDome02_Geo_C] [BotanicalDome02_Geo_C] [BndEvt__BP_NarrativeElevator_2_K2Node_ActorBoundEvent_0_ElevatorGetsToDestination__DelegateSignature]


    vars.Events.FunctionFlag("CliffSplit", "BotanicalLab03_P_C", "BotanicalLab03_P_C", "OnLoadLevels");
    // [BotanicalLab03_P_C] [BotanicalLab03_P_C] [MapLoaded]
    // [BotanicalLab03_P_C] [BotanicalLab03_P_C] [SecondaryMapLoaded]
    // [BotanicalLab03_Geo_C] [BotanicalLab03_Geo_C] [ExecuteUbergraph_BotanicalLab03_Geo]
    // [BotanicalLab03_P_C] [BotanicalLab03_P_C] [OnLoadLevels]
    // [BotanicalLab03_Geo_C] [BotanicalLab03_Geo_C] [BndEvt__BP_NarrativeElevator2_5_K2Node_ActorBoundEvent_1_ElevatorGetsToDestination__DelegateSignature]


    vars.Events.FunctionFlag("LabCanyon", "AridDome01_P_C", "AridDome01_P_C", "OnLoadLevels");
    // [AridDome01_P_C] [AridDome01_P_C] [MapLoaded]
    // [AridDome01_P_C] [AridDome01_P_C] [SecondaryMapLoaded]
    // [AridDome01_P_C] [AridDome01_P_C] [OnLoadLevels]
    // [AridDome01_Geo_C] [AridDome01_Geo_C] [BndEvt__BP_NarrativeElevator_2_K2Node_ActorBoundEvent_5_ElevatorGetsToDestination__DelegateSignature]

    vars.Events.FunctionFlag("Canyon", "AridLab02_P_C", "AridLab02_P_C", "OnLoadLevels");
    // [AridLab02_P_C] [AridLab02_P_C] [MapLoaded]
    // [AridLab02_P_C] [AridLab02_P_C] [SecondaryMapLoaded]
    // [AridLab02_P_C] [AridLab02_P_C] [OnLoadLevels]
    // [AridLab02_Geo_C] [AridLab02_Geo_C] [StartStandard]
    // [AridLab02_Gameplay_C] [AridLab02_Gameplay_C] [BndEvt__BP_NarrativeElevator2_5_K2Node_ActorBoundEvent_0_ElevatorGetsToDestination__DelegateSignature]

    vars.Events.FunctionFlag("LabBeach", "TropicalDome01_P_C", "TropicalDome01_P_C", "OnLoadLevels");
    // [TropicalDome01_P_C] [TropicalDome01_P_C] [MapLoaded]
    // [TropicalDome01_P_C] [TropicalDome01_P_C] [SecondaryMapLoaded]
    // [TropicalDome01_P_C] [TropicalDome01_P_C] [OnLoadLevels]
    // [TDome01_Geo_C] [TDome01_Geo_C] [BndEvt__TriggerBox2_3_K2Node_ActorBoundEvent_1_ActorBeginOverlapSignature__DelegateSignature]
    // [TDome01_Geo_C] [TDome01_Geo_C] [ExecuteUbergraph_TDome01_Geo]

    vars.Events.FunctionFlag("Beach", "TropicalLab02_P_C", "TropicalLab02_P_C", "OnLoadLevels");
    // [TDome01_Geo_C] [TDome01_Geo_C] [ExecuteUbergraph_TDome01_Geo]
    // [TropicalLab02_P_C] [TropicalLab02_P_C] [MapLoaded]
    // [TropicalLab02_P_C] [TropicalLab02_P_C] [SecondaryMapLoaded]
    // [TropicalLab02_P_C] [TropicalLab02_P_C] [OnLoadLevels]
    // [TropicalLab02_Geo_C] [TropicalLab02_Geo_C] [StartStandard]
    // [TropicalLab02_Geo_C] [TropicalLab02_Geo_C] [BndEvt__BP_NarrativeElevator2_5_K2Node_ActorBoundEvent_0_ElevatorGetsToDestination__DelegateSignature]

    vars.Events.FunctionFlag("LabGlacier", "GlaciarDome03_P_C", "GlaciarDome03_P_C", "OnLoadLevels");
    // [GlaciarLab03_Gameplay_C] [GlaciarLab03_Gameplay_C] [ExecuteUbergraph_GlaciarLab03_Gameplay]
    // [GlaciarDome03_P_C] [GlaciarDome03_P_C] [MapLoaded]
    // [GlaciarDome03_P_C] [GlaciarDome03_P_C] [SecondaryMapLoaded]
    // [GlaciarDome03_P_C] [GlaciarDome03_P_C] [OnLoadLevels]
    // [GlaciarDome03_Geo_C] [GlaciarDome03_Geo_C] [BndEvt__BP_NarrativeElevator_2_K2Node_ActorBoundEvent_2_ElevatorGetsToDestination__DelegateSignature]

    // GlacierPuzzle 1
    // [GlaciarDome03_Geo_C] [GlaciarDome03_Geo_C] [BndEvt__TriggerBox3_3_K2Node_ActorBoundEvent_3_ActorBeginOverlapSignature__DelegateSignature]

    //GlacierPuzzle 2
    // [GlaciarDome03_Geo_C] [GlaciarDome03_Geo_C] [BndEvt__TriggerBox4_6_K2Node_ActorBoundEvent_4_ActorBeginOverlapSignature__DelegateSignature]

    //GlacierPuzzle 3
    // [GlaciarDome03_Geo_C] [GlaciarDome03_Geo_C] [BndEvt__TriggerBox5_9_K2Node_ActorBoundEvent_5_ActorBeginOverlapSignature__DelegateSignature]

    // GlacierPuzzle 4
    // [GlaciarDome03_Geo_C] [GlaciarDome03_Geo_C] [BndEvt__TriggerBox6_12_K2Node_ActorBoundEvent_6_ActorBeginOverlapSignature__DelegateSignature]

    //GlacierPuzzle 5
    // [GlaciarDome03_Geo_C] [GlaciarDome03_Geo_C] [BndEvt__TriggerBox7_15_K2Node_ActorBoundEvent_7_ActorBeginOverlapSignature__DelegateSignature]

    vars.Events.FunctionFlag("Glacier", "Lobby_Geo_C", "Lobby_Geo_C", "SetLobbyGlaciarActivationScene");
    // [GlaciarDome03_Geo_C] [GlaciarDome03_Geo_C] [OnStop]
    // [BP_PAPlayerController_C] [BP_PAPlayerController_C] [K2_UpdateAchievementProgress]
    // [Lobby_Geo_C] [Lobby_Geo_C] [SetLobbyGlaciarActivationScene]
    // [Lobby_Geo_C] [Lobby_Geo_C] [ExecuteUbergraph_Lobby_Geo]

    vars.Events.FunctionFlag("LabRiver", "BotanicalDome03_P_C", "BotanicalDome03_P_C", "OnLoadLevels");
    // [BotanicalDome03_P_C] [BotanicalDome03_P_C] [MapLoaded]
    // [BotanicalDome03_P_C] [BotanicalDome03_P_C] [SecondaryMapLoaded]
    // [BotanicalDome03_P_C] [BotanicalDome03_P_C] [OnLoadLevels]
    // [BotanicalDome03_Geo_C] [BotanicalDome03_Geo_C] [BndEvt__BP_NarrativeElevator_2_K2Node_ActorBoundEvent_8_ElevatorGetsToDestination__DelegateSignature]

    // RiverPuzzle 1
    // [BotanicalDome03_Geo_C] [BotanicalDome03_Geo_C] [BndEvt__TriggerBox2_4_K2Node_ActorBoundEvent_2_ActorBeginOverlapSignature__DelegateSignature]

    // RiverPuzzle 2
    // [BotanicalDome03_Geo_C] [BotanicalDome03_Geo_C] [BndEvt__TriggerBox3_9_K2Node_ActorBoundEvent_3_ActorBeginOverlapSignature__DelegateSignature]

    // RiverPuzzle 3
    // [BotanicalDome03_Geo_C] [BotanicalDome03_Geo_C] [BndEvt__TriggerBox4_12_K2Node_ActorBoundEvent_4_ActorBeginOverlapSignature__DelegateSignature]

    // RiverPuzzle 5
    // [BotanicalDome03_Geo_C] [BotanicalDome03_Geo_C] [BndEvt__TriggerBox5_15_K2Node_ActorBoundEvent_5_ActorBeginOverlapSignature__DelegateSignature]

    // RiverPuzzle 6
    // [BotanicalDome03_Geo_C] [BotanicalDome03_Geo_C] [BndEvt__TriggerBox6_18_K2Node_ActorBoundEvent_6_ActorBeginOverlapSignature__DelegateSignature]

    vars.Events.FunctionFlag("River", "Lobby_Geo_C", "Lobby_Geo_C", "SetLobbyBotanicalActivationScene");
    // very early (dialogue):
    // [BotanicalDome03_Geo_C] [BotanicalDome03_Geo_C] [BndEvt__TriggerBox7_21_K2Node_ActorBoundEvent_7_ActorBeginOverlapSignature__DelegateSignature]
    // [BotanicalDome03_Geo_C] [BotanicalDome03_Geo_C] [CustomEvent]
    // [BotDome03_Audio_C] [BotDome03_Audio_C] [StopMusic]
    // [Lobby_Geo_C] [Lobby_Geo_C] [SetLobbyBotanicalActivationScene]

    vars.Events.FunctionFlag("LabDesert", "AridDome02_P_C", "AridDome02_P_C", "OnLoadLevels");
    // [AridDome02_P_C] [AridDome02_P_C] [MapLoaded]
    // [AridDome02_P_C] [AridDome02_P_C] [SecondaryMapLoaded]
    // [AridDome02_P_C] [AridDome02_P_C] [OnLoadLevels]
    // [AridDome02_P_C] [AridDome02_P_C] [BndEvt__TriggerBox_1_K2Node_ActorBoundEvent_0_ActorBeginOverlapSignature__DelegateSignature]

    // DesertPuzzle 2
    // [AridDome02_P_C] [AridDome02_P_C] [BndEvt__TriggerBox3_7_K2Node_ActorBoundEvent_2_ActorBeginOverlapSignature__DelegateSignature]

    // DesertPuzzle 3
    // [AridDome02_P_C] [AridDome02_P_C] [BndEvt__TriggerBox4_10_K2Node_ActorBoundEvent_3_ActorBeginOverlapSignature__DelegateSignature]

    vars.Events.FunctionFlag("Desert", "Lobby_Geo_C", "Lobby_Geo_C", "SetLobbyAridActivationScene");
    // [AridDome02_P_C] [AridDome02_P_C] [BndEvt__TriggerBox5_13_K2Node_ActorBoundEvent_4_ActorBeginOverlapSignature__DelegateSignature]
    // [AridDome02_Geo_C] [AridDome02_Geo_C] [BndEvt__BP_ActivationButtonExecutor_2_K2Node_ActorBoundEvent_0_ButtonExecutor_OnActive__DelegateSignature]
    // [BP_PAPlayerController_C] [BP_PAPlayerController_C] [K2_UpdateAchievementProgress]
    // [AridDome02_Geo_C] [AridDome02_Geo_C] [ExecuteUbergraph_AridDome02_Geo]
    // [AridDome02_Geo_C] [AridDome02_Geo_C] [OnStopMachine]
    // [Lobby_Geo_C] [Lobby_Geo_C] [SetLobbyAridActivationScene]

    vars.Events.FunctionFlag("LabJungle", "TropicalDome02_P_C", "TropicalDome02_P_C", "OnLoadLevels");
    // [TropicalLab02_Geo_C] [TropicalLab02_Geo_C] [ExecuteUbergraph_TropicalLab02_Geo]
    // [TropicalDome02_P_C] [TropicalDome02_P_C] [MapLoaded]
    // [TDome02_Geo_C] [TDome02_Geo_C] [BndEvt__TriggerCaveLight2_K2Node_ActorBoundEvent_1_ActorBeginOverlapSignature__DelegateSignature]
    // [TDome02_Geo_C] [TDome02_Geo_C] [BndEvt__TriggerCaveLight_K2Node_ActorBoundEvent_0_ActorBeginOverlapSignature__DelegateSignature]
    // [TropicalDome02_P_C] [TropicalDome02_P_C] [SecondaryMapLoaded]
    // [TDome02_Puzzle71_Reset_C] [TDome02_Puzzle71_Reset_C] [BndEvt__BP_PressurePlate20_2_K2Node_ActorBoundEvent_2_Pressure_OnActive__DelegateSignature]
    // [TropicalDome02_P_C] [TropicalDome02_P_C] [OnLoadLevels]
    // [TDome02_Geo_C] [TDome02_Geo_C] [BndEvt__TriggerBox2_2_K2Node_ActorBoundEvent_5_ActorBeginOverlapSignature__DelegateSignature]

    // JunglePuzzle 1
    // [TDome02_Geo_C] [TDome02_Geo_C] [BndEvt__TriggerBox3_3_K2Node_ActorBoundEvent_6_ActorBeginOverlapSignature__DelegateSignature]

    // Jungle Puzzle 3
    // [TDome02_Geo_C] [TDome02_Geo_C] [BndEvt__TriggerBox4_6_K2Node_ActorBoundEvent_7_ActorBeginOverlapSignature__DelegateSignature]

    // Jungle Puzzle 4
    // [TDome02_Geo_C] [TDome02_Geo_C] [BndEvt__TriggerBox5_9_K2Node_ActorBoundEvent_8_ActorBeginOverlapSignature__DelegateSignature]

    vars.Events.FunctionFlag("Jungle", "Lobby_Geo_C", "Lobby_Geo_C", "SceneLobbyTropicalActivation");
    // [TDome02_Geo_C] [TDome02_Geo_C] [BndEvt__TriggerBox6_12_K2Node_ActorBoundEvent_4_ActorEndOverlapSignature__DelegateSignature]
    // [TDome02_Audio_C] [TDome02_Audio_C] [BndEvt__TriggerVolume4_5_K2Node_ActorBoundEvent_1_ActorBeginOverlapSignature__DelegateSignature]
    // [TDome02_Geo_C] [TDome02_Geo_C] [ExecuteUbergraph_TDome02_Geo]
    // [TDome02_Audio_C] [TDome02_Audio_C] [BndEvt__TriggerVolume5_8_K2Node_ActorBoundEvent_2_ActorBeginOverlapSignature__DelegateSignature]
    // [TDome02_Geo_C] [TDome02_Geo_C] [EndSequenceMachine]
    // [Lobby_Geo_C] [Lobby_Geo_C] [SceneLobbyTropicalActivation]

    vars.Events.FunctionFlag("EndTable", "Lobby_Geo_C", "Lobby_Geo_C", "OnStopEndingB");
    // [Lobby_Geo_C] [Lobby_Geo_C] [BndEvt__HoloTableSeq_Activ_K2Node_ActorBoundEvent_0_LevelEventDelegate_OnActorInteraction__DelegateSignature]
    // [Lobby_Geo_C] [Lobby_Geo_C] [OnStopEndingB]

    vars.Events.FunctionFlag("EndHangar", "Lobby_Geo_C", "Lobby_Geo_C", "OnStopEndingA");
    // [Lobby_Geo_C] [Lobby_Geo_C] [BndEvt__BP_GenericActivator_2_K2Node_ActorBoundEvent_9_LevelEventDelegate_OnActorInteraction__DelegateSignature]
    // [Lobby_Geo_C] [Lobby_Geo_C] [OnStopEndingA]
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
    if (vars.Resolver.CheckFlag("TaigaSplit") && settings["TaigaSplit"] && vars.DoSplitOnce("TaigaSplit")) return true;

    if (vars.Resolver.CheckFlag("LabCavesSplit") && settings["LabCavesSplit"] && vars.DoSplitOnce("LabCavesSplit")) return true;
    if (vars.Resolver.CheckFlag("CavesSplit") && settings["CavesSplit"] && vars.DoSplitOnce("CavesSplit")) return true;

    if (vars.Resolver.CheckFlag("LabCliffSplit") && settings["LabCliffSplit"] && vars.DoSplitOnce("LabCliffSplit")) return true;
    if (vars.Resolver.CheckFlag("CliffSplit") && settings["CliffSplit"] && vars.DoSplitOnce("CliffSplit")) return true;

    if (vars.Resolver.CheckFlag("LabCanyonSplit") && settings["LabCanyonSplit"] && vars.DoSplitOnce("LabCanyonSplit")) return true;
    if (vars.Resolver.CheckFlag("CanyonSplit") && settings["CanyonSplit"] && vars.DoSplitOnce("CanyonSplit")) return true;

    if (vars.Resolver.CheckFlag("LabBeachSplit") && settings["LabBeachSplit"] && vars.DoSplitOnce("LabBeachSplit")) return true;
    if (vars.Resolver.CheckFlag("BeachSplit") && settings["BeachSplit"] && vars.DoSplitOnce("BeachSplit")) return true;

    if (vars.Resolver.CheckFlag("LabGlacierSplit") && settings["LabGlacierSplit"] && vars.DoSplitOnce("LabGlacierSplit")) return true;
    if (vars.Resolver.CheckFlag("GlacierSplit") && settings["GlacierSplit"] && vars.DoSplitOnce("GlacierSplit")) return true;
    
    if (vars.Resolver.CheckFlag("LabRiverSplit") && settings["LabRiverSplit"] && vars.DoSplitOnce("LabRiverSplit")) return true;
    if (vars.Resolver.CheckFlag("RiverSplit") && settings["RiverSplit"] && vars.DoSplitOnce("RiverSplit")) return true;

    if (vars.Resolver.CheckFlag("LabDesertSplit") && settings["LabDesertSplit"] && vars.DoSplitOnce("LabDesertSplit")) return true;
    if (vars.Resolver.CheckFlag("DesertSplit") && settings["DesertSplit"] && vars.DoSplitOnce("DesertSplit")) return true;

    if (vars.Resolver.CheckFlag("JungleSplit") && settings["LabJungleSplit"] && vars.DoSplitOnce("LabJungleSplit")) return true;
    if (vars.Resolver.CheckFlag("JungleSplit") && settings["JungleSplit"] && vars.DoSplitOnce("JungleSplit")) return true;
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
