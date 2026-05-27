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

    // Intro Split
    vars.Events.FunctionFlag("IntroSplit", "BotanicalDome01_P_C", "BotanicalDome01_P_C", "SecondaryMapLoaded");
    // [MeteoriteChamber02_Gameplay_C] [MeteoriteChamber02_Gameplay_C] [OnStop]
    // [BotanicalDome01_P_C] [BotanicalDome01_P_C] [SecondaryMapLoaded]


    // Track 1 Split
    vars.Events.FunctionFlag("Track1Split", "BotanicalLab01_P_C", "BotanicalLab01_P_C", "MapLoaded");
    // [BP_PAPlayerController_C] [BP_PAPlayerController_C] [UpdateInterpCinematic]
    // [BDome01_Audio_C] [BDome01_Audio_C] [BndEvt__TriggerBox11_5_K2Node_ActorBoundEvent_8_ActorBeginOverlapSignature__DelegateSignature]
    // [BotanicalLab01_P_C] [BotanicalLab01_P_C] [MapLoaded]


    // Lab Forest Split. Currently splits like 10 times.
    vars.Events.FunctionFlag("LabForestSplit", "BotanicalDome01_P_C", "BotanicalDome01_P_C", "MapLoaded");
    // [BDome01_Gameplay_C] [BDome01_Gameplay_C] [EntryElevatorDay2]
    // [BotanicalLab01_Audio_C] [BotanicalLab01_Audio_C] [BndEvt__TriggerBox4_2_K2Node_ActorBoundEvent_0_ActorBeginOverlapSignature__DelegateSignature]
    // [BotanicalDome01_P_C] [BotanicalDome01_P_C] [MapLoaded]
    // [BotanicalDome01_P_C] [BotanicalDome01_P_C] [OnLoadLevels]


    //vars.Events.FunctionFlag("ForestSplit", "BDome01_Gameplay_C", "BDome01_Gameplay_C", "BndEvt__R_EndDome2_K2Node_ActorBoundEvent_9_ActorEndOverlapSignature__DelegateSignature");
    vars.Events.FunctionFlag("ForestSplit", "BDome01_Audio_C", "BDome01_Audio_C", "BndEvt__TriggerBox13_11_K2Node_ActorBoundEvent_20_ActorBeginOverlapSignature__DelegateSignature");
    // [BDome01_Audio_C] [BDome01_Audio_C] [BndEvt__TriggerBox13_11_K2Node_ActorBoundEvent_20_ActorBeginOverlapSignature__DelegateSignature]
    


    vars.Events.FunctionFlag("LabTaigaSplit", "GlaciarDome01_Geo_C", "GlaciarDome01_Geo_C", "BndEvt__BP_NarrativeElevator2_2_K2Node_ActorBoundEvent_3_ElevatorGetsToDestination__DelegateSignature");
    vars.Events.FunctionFlag("TaigaSplit", "GlaciarDome01_Audio_C", "GlaciarDome01_Audio_C", "BndEvt__TriggerVolume3_2_K2Node_ActorBoundEvent_0_ActorBeginOverlapSignature__DelegateSignature");
    // [GlaciarDome01_Audio_C] [GlaciarDome01_Audio_C] [BndEvt__TriggerVolume3_2_K2Node_ActorBoundEvent_0_ActorBeginOverlapSignature__DelegateSignature]

    // For LabCaves Split - NEED TO ADD
    vars.Events.FunctionFlag("LabCavesSplit", "GlaciarDome02_P_C", "GlaciarDome02_P_C", "MapLoaded");
    // [GlaciarDome02_P_C] [GlaciarDome02_P_C] [MapLoaded]
    // [GlaciarDome02_Geo_C] [GlaciarDome02_Geo_C] [BndEvt__BP_NarrativeElevator2_5_K2Node_ActorBoundEvent_5_ElevatorGetsToDestination__DelegateSignature]

    // For Caves Split - NEED TO ADD
    vars.Events.FunctionFlag("CavesSplit", "GlaciarLab03_P_C", "GlaciarLab03_P_C", "MapLoaded");
    // [BP_NarrativeElevator_C] [BP_NarrativeElevator] [BndEvt__EnterElevatorCollision_K2Node_ComponentBoundEvent_0_ComponentBeginOverlapSignature__DelegateSignature]
    // [GlaciarLab03_P_C] [GlaciarLab03_P_C] [MapLoaded]

    // Split for Relicta chamber?
    // [MeteoriteChamber02_Gameplay_C] [MeteoriteChamber02_Gameplay_C] [BndEvt__BP_GenericActivator_208_K2Node_ActorBoundEvent_1_LevelEventDelegate_OnActorInteraction__DelegateSignature]
    // [MeteoriteChamber02_Gameplay_C] [MeteoriteChamber02_Gameplay_C] [OnStop]

    // For LabCliff Split - NEED TO ADD
    vars.Events.FunctionFlag("LabCliffSplit", "BotanicalDome02_P_C", "BotanicalDome02_P_C", "MapLoaded");
    // [BotanicalDome02_P_C] [BotanicalDome02_P_C] [MapLoaded]
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
