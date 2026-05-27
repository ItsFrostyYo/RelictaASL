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

    dynamic[,] _settings =
    {
        // Start examples
        { "Reset", true, "Reset on exit game", null },
        { "SplitsGroup", true, "Splits", null },
        { "IntroSplit", true, "Split on Intro", "SplitsGroup" },
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

}

start
{
    if (vars.MissingUhara) return false;

    // Simple start example
    if (vars.Resolver.CheckFlag("StartGame")) return true;
}

split
{
    if (vars.MissingUhara) return false;

    if (vars.Resolver.CheckFlag("IntroSplit") && settings["IntroSplit"]) return true;
}

reset
{
    if (vars.MissingUhara) return false;

    if (vars.Resolver.CheckFlag("Reset") && settings["Reset"]) return true;
}

update
{
    if (vars.MissingUhara) return;

    vars.Uhara.Update();
}
