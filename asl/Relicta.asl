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

    // Load removal state should start disabled.
    vars.LoadRemovalName = false;

    dynamic[,] _settings =
    {
        // Start examples
        { "group_start", true, "Start Examples", null },
        { "UseExampleStart", false, "Start on ExampleStart", "group_start" },
        { "UseExampleStartWithSetting", false, "Start on ExampleStartWithSetting", "group_start" },

        // Split examples
        { "group_split", true, "Split Examples", null },
        { "UseExampleSplit", false, "Split on ExampleSplit", "group_split" },
        { "UseExampleSplitWithSetting", false, "Split on ExampleSplitWithSetting", "group_split" },

        // Reset examples
        { "group_reset", true, "Reset Examples", null },
        { "UseExampleReset", false, "Reset on ExampleReset", "group_reset" },
        { "UseExampleResetAndClearLoadRemoval", false, "Reset and clear load removal", "group_reset" },
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
    vars.Events.FunctionFlag("ExampleStart", "", "", "");
    vars.Events.FunctionFlag("ExampleStartWithSetting", "", "", "");
    vars.Events.FunctionFlag("ExampleSplit", "", "", "");
    vars.Events.FunctionFlag("ExampleSplitWithSetting", "", "", "");
    vars.Events.FunctionFlag("ExampleReset", "", "", "");
    vars.Events.FunctionFlag("ExampleLoadStart", "", "", "");
    vars.Events.FunctionFlag("ExampleLoadEnd", "", "", "");

    vars.LoadRemovalName = false;
}

start
{
    if (vars.MissingUhara) return false;

    // Simple start example
    if (settings["UseExampleStart"] && vars.Resolver.CheckFlag("ExampleStart")) return true;

    // Start example gated behind its own setting
    if (settings["UseExampleStartWithSetting"] && vars.Resolver.CheckFlag("ExampleStartWithSetting")) return true;
}

update
{
    if (vars.MissingUhara) return;

    vars.Uhara.Update();

    // Example load removal start and end flags
    if (vars.Resolver.CheckFlag("ExampleLoadStart"))
        vars.LoadRemovalName = true;

    if (vars.Resolver.CheckFlag("ExampleLoadEnd"))
        vars.LoadRemovalName = false;
}

split
{
    if (vars.MissingUhara) return false;

    // Simple split example
    if (settings["UseExampleSplit"] && vars.Resolver.CheckFlag("ExampleSplit")) return true;

    // Split example gated behind its own setting
    if (settings["UseExampleSplitWithSetting"] && vars.Resolver.CheckFlag("ExampleSplitWithSetting")) return true;
}

reset
{
    if (vars.MissingUhara) return false;

    // Simple reset example
    if (settings["UseExampleReset"] && vars.Resolver.CheckFlag("ExampleReset")) return true;

    // Reset example that also clears load removal state
    if (settings["UseExampleResetAndClearLoadRemoval"] && vars.Resolver.CheckFlag("ExampleReset"))
    {
        vars.LoadRemovalName = false;
        return true;
    }
}

onReset
{
    if (vars.MissingUhara) return;

    vars.LoadRemovalName = false;
}

isLoading
{
    if (vars.MissingUhara) return false;

    return vars.LoadRemovalName;
}
