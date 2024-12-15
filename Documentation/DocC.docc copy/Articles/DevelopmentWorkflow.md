# Development Workflow

@Metadata {
    @PageKind(article)
    @PageColor(purple)
}

## Overview

The Vibes development workflow is designed to be efficient and maintainable, with a focus on code quality and documentation.

## Development Tools

### URL Content Fetcher
The `fetch_url.sh` script provides a simple way to fetch and cache content from URLs:

```bash
./Support/Tools/fetch_url.sh <URL>
```

Features:
- Content caching with timestamps
- HTML content extraction
- Automatic error handling
- Preview of fetched content

### Automation Shortcuts

#### "Do a backup"
Automatically stages, commits, and pushes changes:
```bash
git add .
git commit -m "Your commit message"
git push origin main
```

#### "Summarize today's work"
Updates documentation with daily progress:
1. Updates current-status.md
2. Updates current-issues.md
3. Updates README.md project status
4. Creates dated history entries

#### "Onboard Me"
Guides new developers through the codebase:
1. Reviews all documentation
2. Analyzes code structure
3. Reviews sample projects
4. Verifies platform requirements

## Documentation Process

### DocC Integration
- Source code documentation
- Article writing
- Tutorial creation
- Resource management

### Documentation Types
1. API Reference
   - Protocol documentation
   - Type documentation
   - Method documentation
   
2. Articles
   - Conceptual overviews
   - Best practices
   - Implementation guides
   
3. Tutorials
   - Step-by-step guides
   - Code examples
   - Interactive learning

## Quality Guidelines

### Code Standards
- SwiftUI best practices
- RealityKit optimization
- Error handling patterns
- Memory management

### Testing Requirements
- Unit test coverage
- Performance benchmarks
- UI/UX testing
- Device testing

## See Also
- <doc:QualityGuidelines>
- <doc:ProjectStructure>
- <doc:Architecture> 