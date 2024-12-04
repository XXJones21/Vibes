# GalleryView Entity Debug Test Plan

## 1. Debug Visualization Test
### Test Setup

```swift
// Add to Gallery.swift after line 27
startLine: 27
endLine: 39

### Test Steps
1. Launch app in debug mode
2. Navigate to GalleryView
3. Check debug console for "Initial RealityView setup" message
4. Verify red debug box appears at [0, 0, -0.5]

### Expected Results
- Debug box visible in RealityView
- Console shows entity position
- Box responds to basic interactions

### Actual Results
[ ] Debug box visible
[ ] Position logged correctly
[ ] Interaction working

## 2. Entity Hierarchy Logging Test
### Test Setup

```swift
// Add logging to layoutCategories() method
startLine: 95
endLine: 116
```


### Test Steps
1. Enable verbose logging
2. Load GalleryView
3. Check debug output for:
   - Root transform matrix
   - Child entity count
   - Entity positions
   - Component attachments

### Expected Results
- Complete entity hierarchy logged
- Transform matrices printed
- Component list for each entity

### Actual Results
[ ] Hierarchy logged
[ ] Transforms correct
[ ] Components listed

## 3. Material System Verification

### Test Setup
```swift
// Verify in createAlbumEntity()
startLine: 118
endLine: 152
```


### Test Steps
1. Set breakpoint at material creation
2. Check material properties:
   - Type (UnlitMaterial)
   - Color values
   - Texture loading
3. Verify texture application

### Expected Results
- UnlitMaterial created successfully
- Textures load and apply correctly
- No material property errors

### Actual Results
[ ] Material creation successful
[ ] Texture loading works
[ ] No property errors

## 4. Transform Chain Debug
### Test Setup
```swift
// Add to RealityView update block
startLine: 39
endLine: 51
```


### Test Steps
1. Add coordinate axes
2. Check entity positions
3. Verify parent-child relationships
4. Test transform propagation

### Expected Results
- Coordinate axes visible
- Correct hierarchy maintained
- Transforms properly inherited

### Actual Results
[ ] Axes visible
[ ] Hierarchy correct
[ ] Transforms working

## Environment Information
- visionOS Version: 1.0
- Xcode Version: 15.2
- Device: Vision Pro Simulator
- Build: Latest development

## Notes
- Check MusicService authorization before running tests
- Verify RealityKit content bundle is properly linked
- Monitor memory usage during texture loading
- Document any crash logs or error messages