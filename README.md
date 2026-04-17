# Wizard NPC Mechanic

### Overview
Wizard NPC Mechanic is an automated emergency roadside assistance service for QB-Core servers. It allows players stranded in damaged vehicles to call an NPC mechanic to their location for full vehicle repairs and cleaning when active mechanics are offline.

### Features
* **Custom UI:** Sleek, modern interface styled for the WizardDev brand, identical to the NPC Medic system.
* **Vehicle Navigation:** NPC spawns in a flatbed and drives directly to the player's GPS coordinates.
* **Repair Sequence:** Immersive hood-repair animations and progress bar during the fixing process.
* **Economy Integration:** Automatically handles payments via cash or bank based on configurable prices.
* **Anti-Stuck:** Restart button included in the UI to reset client-side variables and re-initialize the script.

### How It Works
1. **Trigger:** A player inside a damaged vehicle runs the `/mechanic` command.
2. **Request:** The player confirms the service call via the UI (only if the vehicle is occupied).
3. **Arrival:** An NPC mechanic spawns in a service vehicle at a distance and drives to the player.
4. **Repair:** The NPC exits their vehicle, walks to the player's hood, and performs a 10-second repair sequence.
5. **Cleanup:** Once the vehicle is fixed and cleaned, the NPC drives away and despawns.

### Configuration
Everything is managed via `config.lua`. You can easily adjust:
* Service costs
* Mechanic ped models
* Service vehicle model (Default: `flatbed`)
* Repair duration
* Job name for availability checks

### Support
For bugs, updates, or assistance, join the official support server:
**Discord:** [https://discord.gg/VCRs4TSy7G](https://discord.gg/VCRs4TSy7G)

### Credits
Developed by **Wizard.dev**
