# Shortcuts

> **Onboarding Instructions**: 
> Please review all markdown documents, the codebase, and the contents in the MVP folder to familiarize yourself with the project. Pay special attention to:
> - `Composer-history.md` for project evolution and key decisions
> - `current-status.md` and `current-issues.md` for latest state
> - `README.md` for project overview and structure
> - The MusicService package implementation
> - UI/UX components in the Views directory
> - Project configuration and dependencies
> - Reference all VisionOS sample projects at `/Users/jones/Documents/Sample Apps/VisionOS`, particularly:
>   - Spatial Audio - for audio implementation patterns
>   - Hand Tracking - for gesture controls
>   - Creating Immersive Spaces - for visualization environments
>   - RealityKit-UIPortal - for UI integration
>   - Glass - for UI styling and effects

This document contains key phrases that can be used to automate common tasks in the development workflow.

## Available Shortcuts

### "Summarize today's work"
This command will:
1. Update `current-status.md` and `current-issues.md` with today's progress
2. Update the Project Status section in `README.md` with:
   - A summary paragraph based on current-status.md and current-issues.md
   - A list of current top priorities
3. Add a new entry to `Composer-history.md`:
   - Date-stamped section for today's changes
   - Technical implementation details
   - UI/UX changes and improvements
   - Issues addressed and solutions implemented

### "Do a backup"
This command will:
1. Stage all modified files using `git add .`
2. Generate a concise commit message summarizing the changes
3. Commit the changes using the generated message
4. Push the changes to the main branch

## Format for Adding New Shortcuts
```
### "Your key phrase here"
This command will:
1. First action
2. Second action
...
``` 