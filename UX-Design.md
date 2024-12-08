# UX Design for Vibes

## Ideal User Journey

1. **Onboarding & Authorization:**
   - Users are greeted with a visually appealing welcome screen.
   - Clear instructions guide users to authorize Apple Music access.
   - A brief tutorial introduces the app's features and navigation.

2. **Music Selection & Playback:**
   - Users can easily browse and select music from their library.
   - Playback controls are intuitive and responsive.
   - Visual feedback is provided for actions like play, pause, and skip.

3. **Immersive Visualization:**
   - Music playback triggers dynamic, genre-specific visualizations.
   - Users can interact with visual elements using gestures.
   - Visuals adapt to the music's tempo and mood.

4. **Therapeutic Mode:**
   - A dedicated mode offers calming visualizations for therapeutic use.
   - Safety features like grounding mechanisms and exit gestures are available.

5. **Settings & Customization:**
   - Users can customize visualization intensity and color schemes.
   - Settings are easily accessible and user-friendly.

## Current Vibes Project Breakdown

1. **AuthorizationView:**
   - **Function:** Requests Apple Music authorization.
   - **Issues:** None identified, but could benefit from a more engaging design.

2. **ContentView:**
   - **Function:** Main navigation hub, displaying either the AuthorizationView or GalleryView.
   - **Issues:** Error handling for playback is present but could be more user-friendly.

3. **GalleryView:**
   - **Function:** Displays albums in horizontal rows with 3D spatial layout and allows music selection.
   - **Issues:** Hover effects and smooth transitions need refinement.

4. **ImmersiveView:**
   - **Function:** Provides immersive visualizations during playback.
   - **Issues:** Missing particle system implementation; incomplete Dolby Atmos integration.

5. **Therapeutic Mode:**
   - **Function:** Intended for therapeutic visualizations.
   - **Issues:** Not yet implemented; requires safety protocols and grounding mechanisms.

## Comparison & Recommendations

- **Critical Issues:**
  - Hover effects and transitions in GalleryView need polish
  - Incomplete particle system and Dolby Atmos integration
  - Lack of therapeutic mode features

- **Missing Features:**
  - Interactive visualizations and gesture controls.
  - Customization options for visual effects.
  - Comprehensive onboarding and tutorial.

## To-Do List for Vibes

1. **Enhance GalleryView Interactions:**
   - Verify entity hierarchy and material system
   - Implement hover effects and smooth transitions

2. **Complete Core Features:**
   - Implement particle system framework.
   - Integrate Dolby Atmos track filtering.

3. **Develop Therapeutic Mode:**
   - Create safety protocol framework.
   - Implement grounding mechanisms and exit gestures.

4. **Enhance User Experience:**
   - Add onboarding tutorial and customization options.
   - Improve error handling with user-friendly feedback.

5. **Optimize Performance:**
   - Reduce texture sizes and implement caching.
   - Optimize layout calculations and memory management.

## Welcome View

The welcome view provides an immersive introduction to the app through a dynamic particle animation system.

### Initial Setup
- Create ParticleSystem class to manage the effect
- Setup base particle properties (color, size, lifetime)
- Create emitter points in a spherical formation

### Animation Phases (Total Duration: 10 seconds)

#### 1. Globe Formation (0-3s)
- Emit particles in spherical pattern
- Use perlin noise for natural movement
- Gradient colors between purple and blue
- Soft glow/bloom effect

#### 2. Center Pull (3-4s)
- Attract particles to center point
- Increase density/compression
- Add swirl effect during pull

#### 3. Text Formation (4-6s)
- Define "VIBES" text path
- Distribute particles along path
- Add subtle oscillation
- Implement color transitions

#### 4. Stable State (6-8s)
- Gentle particle movement
- Soft color pulsing
- Maintain text shape

#### 5. Final Burst (8-10s)
- Explosive force outward
- Fade out opacity
- Smoke-like dissipation

### Technical Implementation Notes
- Use RealityKit's particle system for optimal performance
- Implement perlin noise for organic movement
- Use batch processing for particle updates
- Optimize for visionOS rendering pipeline
- Maintain 60fps performance target

### Visual Style
- Primary colors: Purple (#8A2BE2) to Blue (#4169E1)
- Particle size: 0.01-0.03 units
- Glow intensity: 0.4-0.8
- Opacity range: 0.3-0.8
- Bloom effect intensity: 0.3

### Performance Considerations
- Maximum particle count: 500
- Batch updates in groups of 50
- Use spatial partitioning for collision detection
- Implement particle pooling for memory efficiency
- Progressive loading of particle systems 