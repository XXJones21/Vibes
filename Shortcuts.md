# Shortcuts

This document contains key phrases that can be used to automate common tasks in the development workflow. If you are being asked to read this file, please navigate to the "Onboard Me" section and perform each step in that action.

> **Onboarding Instructions**: 

> Please review all markdown documents, the codebase, and the contents in the MVP folder to familiarize yourself with the project. Pay special attention to:
> - This is a visionOS-only project (requires visionOS 2.0+ for Dolby Atmos support)
> - `Support/History` directory for project evolution and key decisions
> - `current-status.md` and `current-issues.md` for latest state
> - `README.md` for project overview and structure
> - The PulsarSymphony module implementation (visionOS 2.0+ specific)
> - UI/UX components in the Views directory
> - Project configuration and dependencies
> - Reference all VisionOS sample projects at `/Users/jones/Documents/Sample Apps/VisionOS`, particularly:
>   - Spatial Audio - for audio implementation patterns
>   - Hand Tracking - for gesture controls
>   - Creating Immersive Spaces - for visualization environments
>   - RealityKit-UIPortal - for UI integration
>   - Glass - for UI styling and effects
> - The Golden Rules section below must be followed at all times

## Golden Rules

- Do not make major adjustments to any of the packages including adding, removing features. Only change if asked directly. If unsure, explain what you want to do and ask for approval first.

- Do not make any adjustments to any of the views, mainly anything to alter its' current layout unless specifically told to do so. Explain what change you want to do and ask for approval first.

- When asked to review code:
  1. Read EVERY single file in the scope
  2. Do not skip any files, even if they seem unrelated
  3. Do not make assumptions about file contents
  4. Read everything completely before formulating any response
  5. Only after having a complete picture of all files, start answering

- Always check availability attributes match the target platform (e.g., `@available(visionOS 2.0, *)`)
- When fixing issues, compare with a previous working version (preferably from git history) before making changes
- Keep the code clean and well-documented
- Follow SwiftUI and RealityKit best practices
- Test on device when possible

## Available Shortcuts

### "Onboard me"
This command will:
1. Review all markdown documents in sequence:
   - README.md for project overview
   - current-status.md for latest state
   - current-issues.md for known issues
   - Support/History/composer-history-overview.md for project overview
   - Support/History directory for chronological project evolution
2. Analyze the codebase structure:
   - PulsarSymphony TechStack implementation
   - AetherParticles TechStack implementation
   - UI/UX components in Views directory
   - Project configuration and dependencies
3. Review visionOS sample projects for reference patterns:
   - Spatial Audio implementation
   - Hand tracking gestures
   - Immersive spaces
   - RealityKit UI integration
   - Glass UI styling
   - RealityKit Particles in visionOS: '/Users/jones/Documents/Sample Apps/VisionOS/SimulatingParticlesInYourVisionOSApp'
4. Verify platform requirements:
   - visionOS 2.0+ availability attributes
   - Dolby Atmos support
   - SwiftUI and RealityKit usage
5. Confirm understanding of Golden Rules:
   - Package modification restrictions
   - View layout guidelines
   - Platform compatibility
   - Version control practices
   - Code quality standards

### "Summarize today's work"
This command will:
1. Update `current-status.md` and `current-issues.md` with today's progress
2. Update the Project Status section in `README.md` with:
   - A summary paragraph based on current-status.md and current-issues.md
   - A list of current top priorities
3. Create new dated entry files in `Support/History`:
   - Create a new file with format: YYYY-MM-DD-[description].md
   - If multiple entries for the day, use: YYYY-MM-DD-[description]-log-[number].md
   - If entry is too long, split into: YYYY-MM-DD-[description]-part-[number].md
   - Include in each file:
     - Date-stamped section for today's changes
     - Technical implementation details
     - UI/UX changes and improvements
     - Issues addressed and solutions implemented
     - New features and enhancements
     - Any other relevant information
     - Summary of accomplishments, issues faced, and next steps

### "Do a backup"
This command will:
1. Stage all modified files using `git add .`
2. Generate a concise commit message summarizing the changes
3. Commit the changes using the generated message
4. Push the changes to the main branch

### "Convert to Aether"
This command will:
1. Read and analyze provided particle simulation source (WebGL/JS/HTML/CSS or text prompt)
2. Generate summary report:
   - Core particle behaviors and effects
   - Unique characteristics
   - Potential PulseSymphony integration points
   - Performance considerations
3. Platform Compatibility Analysis:
   - visionOS performance evaluation
   - Memory and battery impact assessment
   - Required hardware capabilities check
   - Alternative implementation suggestions if needed
4. Create implementation outline:
   - Map existing behaviors to AetherPhysics functions
   - Identify new physics functions needed
   - List required particle system components
   - Define music reactivity integration points
5. Generate appropriate Aether preset:
   - AetherPreset: For standalone effects
   - AetherVisualizer: For music-reactive visualizations
   - AetherAnimation: For complex animated sequences
6. Create implementation files:
   - Add new preset/visualizer/animation file
   - Add any required physics functions
   - Include performance optimization notes
   - Document music reactivity hooks

## Format for Adding New Shortcuts
```
### "Your key phrase here"
This command will:
1. First action
2. Second action
...
``` 